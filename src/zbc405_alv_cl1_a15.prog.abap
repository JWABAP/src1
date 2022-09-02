*&---------------------------------------------------------------------*
*& Report ZBC405_ALV_CL1_A15
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
"booking list 조회프로그램 made by ALV (우리가하는방법?: 화면에 커스텀영역을 지정하고 그 위에 컨테이너오브젝트만들고 alv생성)
REPORT zbc405_alv_cl1_a15.

TABLES : ztsbook_a15.

*-----Selection Screen-----*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.
  SELECT-OPTIONS : so_car FOR ztsbook_a15-carrid OBLIGATORY    "필수입력값 설정.
                              MEMORY ID car,
                   so_con FOR ztsbook_a15-connid
                              MEMORY ID con,
                   so_fld FOR ztsbook_a15-fldate,
                   so_cus FOR ztsbook_a15-customid.

  SELECTION-SCREEN SKIP.
  PARAMETERS : p_edit AS CHECKBOX.        "셀렉션 스크린에서 Edit모드 여부 설정하는 사용자 입력변수
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN SKIP.    "한칸 띄우기
PARAMETERS : p_layout TYPE disvariant-variant.       "셀렉션스크린에서 이미 저장된 variant를 지정해서 들어가는 사용자입력칸.

  DATA : gt_custom TYPE TABLE OF ztscustom_a15,
         gs_custom TYPE          ztscustom_a15.

*--------Data 선언 부분--------*
TYPES : BEGIN OF gty_sbook.
          INCLUDE  TYPE ztsbook_a15.
TYPES :   light TYPE c LENGTH 1.        "신호등역할을 하는 필드
TYPES :  telephone TYPE ztscustom_a15-telephone.    "전화번호를 담는 필드 추가하기
TYPES :  email     TYPE ztscustom_a15-email.         "이메일을 담는 필드 추가하기
TYPES :  row_color TYPE c LENGTH 4.    "ROW 색깔을 다르게 설정하는 필드 , ROW Color
TYPES :  it_color  TYPE lvc_t_scol.     "cell color를 담당하는 필드는 테이블이다.
TYPES :  bt        TYPE lvc_t_styl.     "필드심볼 선언해주지않으면 덤프남
TYPES :  modified  TYPE c LENGTH 1.     "레코드가 변경되면 'X'가 들어옴
TYPES : END OF gty_sbook.


DATA : gt_sbook TYPE TABLE OF gty_sbook,     "위에 types를 참조하는 테이블타입
       gs_sbook TYPE          gty_sbook.     "Work Area
*       dl_sbook TYPE TABLE OF gty_sbook.     "For deleted recordes

*--- delete 관련 변수 선언 ---*
DATA : dl_sbook TYPE TABLE OF ztsbook_a15,
       dw_sbook TYPE          ztsbook_a15.

DATA : ok_code TYPE sy-ucomm.                "ok_code는 Screen→Element list 에서 설정 해줘야 사용가능하다.

*-- ALV를 위한 변수 --*
DATA : go_container TYPE REF TO cl_gui_custom_container,
       go_alv       TYPE REF TO cl_gui_alv_grid.

DATA : gs_variant TYPE disvariant,    "variant 변수
       gs_layout  TYPE lvc_s_layo,
       gt_sort    TYPE lvc_t_sort,
       gs_sort    TYPE lvc_s_sort,
       gs_color   TYPE lvc_s_scol,     "셀별로 색깔을 넣기위해서
       gt_exct    TYPE ui_functions,   "값을 직접해줄거여서 워크에이리어가 필요없다?
       gt_fcat    TYPE lvc_t_fcat,
       gs_fcat    TYPE lvc_s_fcat.

DATA : rt_tab TYPE  zz_range_type.
DATA : rs_tab TYPE  zst03_carrid.

INCLUDE zbc405_alv_cl1_a15_class.     "include할때 위치가중요하다.(위에다하면 글로벌 변수를 사용하지못하기때문에 밑에하는것)


*----------------------------------------------
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_layout.        "p_layout F4 활성화(value request).

  CALL FUNCTION 'LVC_VARIANT_SAVE_LOAD'
    EXPORTING
      i_save_load = 'F'           "S: Save L : Load F: F4
    CHANGING
      cs_variant  = gs_variant.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ELSE.
    p_layout = gs_variant-variant.
  ENDIF.



INITIALIZATION.      "INITIALIZATION은 프로그램을 실행할때 맨 처음 실행된다(뒤에있어도 문제없다.)
  gs_variant-report = sy-cprog.      "지금 돌고있는 레포트를 설정해서 F4를 안해도된다?

*  rs_tab-low = 'AA'.   "기본적으로 AA뜨게, LOW는 selection screen에서 왼쪽칸, HIGH는 오른쪽칸이다.
*  rs_tab-sign = 'I'.
*  rs_tab-option = 'EQ'.
*  APPEND ts_tab TO rt_tab.
*
*  rs_tab-low = 'LH'.   "기본적으로 LH뜨게
*  rs_tab-sign = 'I'.
*  rs_tab-option = 'EQ'.
*  APPEND ts_tab TO rt_tab.
*
*  rs_tab-low = 'AZ'.   "기본적으로 AZ뜨게
*  rs_tab-sign = 'I'.
*  rs_tab-option = 'EQ'.
*  APPEND ts_tab TO rt_tab.
*
*  so_car[] = rt_tab[].     "레인지테이블도 똑같이 so_car처럼 쓸 수 있다고 보여주기위해서 억지로 넣은 로직?

START-OF-SELECTION.

  PERFORM get_data.

  CALL SCREEN 100.

*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .

  DATA : gt_temp   TYPE TABLE OF gty_sbook.

  SELECT *                             "데이터를 gt_sbook에 넣었음.
    INTO CORRESPONDING FIELDS OF TABLE gt_sbook FROM ztsbook_a15 "CORRESPONDING FIELDS OF TABLE
                                                                 "field name에서 넘어오는 값중에 동일한 속성을 가진 필드의 경우 그대로 가져온다는 뜻이다.
                                                                 "table을 쓰게 된다는 것은 table로 데이터를 받겠다라는 뜻
   WHERE carrid IN so_car            "조건
     AND connid IN so_con            "조건
     AND fldate IN so_fld            "조건
     AND customid IN so_cus.         "조건

  IF sy-subrc EQ 0.

    gt_temp = gt_sbook.
    DELETE gt_temp WHERE customid = space.     "데이터가 비어있으면  조회할필요가없어서 삭제한다.


    SORT gt_temp BY customid.
    DELETE ADJACENT DUPLICATES FROM gt_temp COMPARING customid. "중복된게 있을수있어서 유니크하게만들어야한다.(이미 조회한걸 또 하면 퍼포먼스가 안좋아지기때문)
    "중복된 내용을 삭제해서 유니크하게 만든다
    SELECT *
      INTO TABLE gt_custom
      FROM ztscustom_a15
       FOR ALL ENTRIES IN gt_temp
     WHERE id = gt_temp-customid.

  ENDIF.

  LOOP AT gt_sbook INTO gs_sbook.
    READ TABLE gt_custom INTO gs_custom
            WITH KEY id = gs_sbook-customid.
    IF sy-subrc EQ 0.
      gs_sbook-telephone = gs_custom-telephone.
      gs_sbook-email     = gs_custom-email.
    ENDIF.


*---------Exception Handling---------*

    IF gs_sbook-luggweight > 25.   "LUGGWEIGHT = 필드명
      gs_sbook-light = 1.     "1 = Red
    ELSEIF gs_sbook-luggweight > 15.
      gs_sbook-light = 2.     "2 = Yellow
    ELSE.
      gs_sbook-light = 3.      "3 = Green
    ENDIF.

*-----필드 레코드 단위로 필드색깔을 바꾸겠다는 로직-----*
    IF gs_sbook-class = 'F'.      "First클래스이면 색깔을 바꾸겠다는 로직 F = First Class
      gs_sbook-row_color = 'C710'.  "C = Color 7 = 색깔(주황색) 1 =inverse
    ENDIF.

*-----셀별로 색깔을 넣는 로직-----*
    IF gs_sbook-smoker = 'X'.
      gs_color-fname = 'SMOKER'.
      gs_color-color-col = col_negative.    "negative = 빨간색
      gs_color-color-int = '1'.
      gs_color-color-inv = '0'.
      APPEND gs_color TO gs_sbook-it_color.
    ENDIF.


    MODIFY gt_sbook FROM gs_sbook.
  ENDLOOP.
ENDFORM.

*---100번스크린 버튼(back,exit,cancle)생성---*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  IF p_edit = 'X'.         "edit모드일때는 SAVE가 보이게
    SET PF-STATUS 'T100'.

  ELSE.
    SET PF-STATUS 'T100' EXCLUDING 'SAVE'.  "else(edit모드가 아닌경우) SAVE 숨기기
  ENDIF.
  SET TITLEBAR 'T10' WITH sy-datum sy-uname.  "with로 아까 타이틀제목에 &1 &2했던부분에 추가할 수 있다. (오늘일자,유저이름)
ENDMODULE.

*---Exit Command 이벤트 동작부분---*
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.
  LEAVE TO SCREEN 0.    "Selection Screen으로 돌아가라는 뜻.(이전화면?)
ENDMODULE.

*---ALV Object 생성---*
*&---------------------------------------------------------------------*
*& Module CREATE_ALV_OBJECT OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE create_alv_object OUTPUT.

  IF go_container IS INITIAL.  "컨테이너가 비어있을때 생성하고 그렇지않으면 리프레쉬한다.
    "컨테이너 가저올때는 패턴으로 해도되고 class/interface에서 드래그앤드랍으로 가져와도됨.
    CREATE OBJECT go_container
      EXPORTING
        container_name = 'MY_CONTROL_AREA'.      "오타주의하기,레이아웃에서 지정한 이름이랑 다르면 ALV안보임.


    IF sy-subrc EQ 0.   "제대로 만들어젔으면(EQ 0.)
      CREATE OBJECT go_alv
        EXPORTING
          i_parent = go_container.   "go_container 위에 얹는다.

      IF sy-subrc EQ 0. "제대로 생성이됐으면 alv를 뿌려라

        gs_variant-variant = p_layout.   "이벤트를 탈때와 안탈때의 값이 차이가있기때문에 입력한 variant(p_layout)값을 넣어줘야한다.
        "이 로직을 안넣으면 f4를 누르지않고 variant이름을 외워서 적고 실행을하면 variant가 적용이 되지않는다.

        PERFORM set_variant.
        PERFORM set_layout.
        PERFORM set_sort_table.
        PERFORM make_fieldcatalog.

*----------데이터 체인지를 위해 꼭 해주어야 한다.(엔터칠때 이벤트를탈건지 변경할때 이벤트를 탈건지 설정하는 부분)--------------*
        CALL METHOD go_alv->register_edit_event
          EXPORTING
            i_event_id = cl_gui_alv_grid=>mc_evt_modified.    "변경되는순간 반영
                                          "MC_EVT_ENTER = 엔터치는순간 반영



        APPEND cl_gui_alv_grid=>mc_fc_filter TO gt_exct.       "Filter버튼 숨기기
        APPEND cl_gui_alv_grid=>mc_fc_info TO gt_exct.         "Info버튼 숨기기

        " Edit 모드일때 필요없는 버튼들 지우는 로직.(Exclude Toolbar?)
        APPEND cl_gui_alv_grid=>mc_fc_loc_append_row TO gt_exct.    "appendrow
        APPEND cl_gui_alv_grid=>mc_fc_loc_copy_row TO gt_exct.      "duplicated



*---------------이벤트 트리거(핸들러)---------------------*
        SET HANDLER lcl_handler=>on_doubleclick           FOR go_alv.
        SET HANDLER lcl_handler=>on_toolbar               FOR go_alv.
        SET HANDLER lcl_handler=>on_usercommand           FOR go_alv.
        SET HANDLER lcl_handler=>on_data_changed          FOR go_alv.
        SET HANDLER lcl_handler=>on_data_changed_finish   FOR go_alv.



*---------------이벤트 트리거(핸들러)끝----------------------*


        CALL METHOD go_alv->set_table_for_first_display
          EXPORTING
*           i_buffer_active      =
*           i_bypassing_buffer   =
*           i_consistency_check  =
            i_structure_name     = 'ZTSBOOK_A15'     "우리가참조하고있는 테이블 이름 넣기
            is_variant           = gs_variant      "variant를 가저올땐 report가 필요하다.
            i_save               = 'A'                " ' '(space):자체변경만가능,저장이안됨, A = 다된다. X = global,default만 가능, U = 자기가 설정한것만 가능.
            i_default            = 'X'
            is_layout            = gs_layout             "sel mode
*           is_print             =
*           it_special_groups    =
            it_toolbar_excluding = gt_exct               "화면에 보이는 툴바버튼이 숨겨진다.
*           it_hyperlink         =
*           it_alv_graphics      =
*           it_except_qinfo      =
*           ir_salv_adapter      =
          CHANGING
            it_outtab            = gt_sbook      "그 안에 데이터들은 gt_sbook
            it_fieldcatalog      = gt_fcat              "i_structure_name 기존에 있던 데이터들은 수정이되고, 없는 데이터들은 append가 된다.
            it_sort              = gt_sort              "기본적으로 오름차순,내림차순 설정하는것
*           it_filter            =
*          EXCEPTIONS
*           invalid_parameter_combination = 1
*           program_error        = 2
*           too_many_lines       = 3
*           others               = 4
          .
        IF sy-subrc <> 0.
*         Implement suitable error handling here
        ENDIF.


      ENDIF.


    ENDIF.

  ELSE.

    DATA : gs_stable       TYPE lvc_s_stbl,
           gv_soft_refresh TYPE abap_bool.

*-- Refresh ALV Method가 올 자리.  내용만 다시보여주는
    gv_soft_refresh = 'X'.
    gs_stable-row = 'X'.
    gs_stable-col = 'X'.
    CALL METHOD go_alv->refresh_table_display
      EXPORTING
        is_stable      = gs_stable
        i_soft_refresh = gv_soft_refresh
      EXCEPTIONS
        finished       = 1
        OTHERS         = 2.
    IF sy-subrc <> 0.
*     Implement suitable error handling here
    ENDIF.
*    CALL METHOD cl_gui_cfw=>flush.


    ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Form set_variant
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_variant .
  p_layout = gs_variant-variant.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_layout .
  gs_layout-sel_mode = 'D'.   "A, B, C, D  , select mode 설정

  gs_layout-excp_fname = 'LIGHT'.  "위에서 선언한 필드 이름. , Exception Handling
  gs_layout-excp_led   = 'X'.        "신호등 아이콘 변경(한칸짜리로 바뀐다. 만약 맘에들지않으면 주석처리해서 3칸짜리 신호등 사용하면됨.)
  gs_layout-zebra      = 'X'.        "필드에 얼룩말처럼 색깔 패턴넣기(Zebra)
  gs_layout-cwidth_opt = 'X'.      "필드 공간 정리(엑셀에서 더블클릭했을때 제일 긴 사이즈만큼 딱 맞게해주는 그거)
*  gs_layout-edit       = 'X'.      "이렇게 layout에서 edit을 설정하면 모든 필드가 전부 edit가능하게 열린다.
  gs_layout-info_fname = 'ROW_COLOR'.    "ROW color 필드설정
  gs_layout-ctab_fname = 'IT_COLOR'.     "셀별로 색깔을 넣는것.
  gs_layout-stylefname = 'BT'.           "마찬가지로 modify_style을 할때 필드심볼을 사용하기위해서 쓴다?



ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_sort_table
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_sort_table .               "중복되는 값들은 한칸으로 표시?하기
  CLEAR : gs_sort.                  "정보를 넣기전에 clear를 하는습관을 가지기
  gs_sort-fieldname = 'CARRID'.
  gs_sort-up        = 'X'.          "Asecending, 오름차순
  gs_sort-spos      = '1'.
  APPEND gs_sort TO gt_sort.

  CLEAR : gs_sort.                  "정보를 넣기전에 clear를 하는습관을 가지기
  gs_sort-fieldname = 'CONNID'.
  gs_sort-up        = 'X'.          "Ascending, 오름차순
  gs_sort-spos      = '2'.
  APPEND gs_sort TO gt_sort.

  CLEAR : gs_sort.                  "정보를 넣기전에 clear를 하는습관을 가지기
  gs_sort-fieldname = 'FLDATE'.
  gs_sort-down        = 'X'.        "Descending, 오름차순
  gs_sort-spos        = '3'.
  APPEND gs_sort TO gt_sort.
ENDFORM.

*------Field Catalog-------*
*&---------------------------------------------------------------------*
*& Form make_fieldcatalog
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM make_fieldcatalog .
  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'LIGHT'. "LIGHT는 sbook에 있어야한다.(없으면 오류남)
  gs_fcat-coltext = 'Info'.    "Info로 필드명 변경.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'SMOKER'.
  gs_fcat-checkbox = 'X'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'INVOICE'.
  gs_fcat-checkbox = 'X'.
  APPEND gs_fcat TO gt_fcat.


  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'CANCELLED'.
  gs_fcat-checkbox = 'X'.
  gs_fcat-edit = p_edit.        "'X'.        "필드별로 Edit 기능 추가하기, Edit기능을 추가하면 Edit기능에 필요한 버튼들이 자동으로 추가된다.
  "원래에는 'X'를 사용하여 항상 Edit모드였지만 parameter변수로 설정한 p_edit를 사용쓰게되면 체크할경우 Edit모드,체크하지않을경우 조회모드로 실행이 된다.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'TELEPHONE'.
  gs_fcat-ref_table = 'ZTSCUSTOM_A15'.        "레퍼런스해주면 속성이 그대로나온다
  gs_fcat-ref_field = 'TELEPHONE'.
  gs_fcat-col_pos   = '30'.
  APPEND gs_fcat TO gt_fcat.


  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'EMAIL'.
  gs_fcat-ref_table = 'ZTSCUSTOM_A15'.
  gs_fcat-ref_field = 'EMAIL'.                "레퍼런스해주면 속성이 그대로나온다(Case sensitive가 그대로 따라온다?),안해주면 대문자만 나옴.
  gs_fcat-col_pos   = '31'.
  APPEND gs_fcat TO gt_fcat.

*--column에 색깔 추가하기--*
  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'CUSTOMID'.
*  gs_fcat-emphasize = 'C400'.                 "emphasize = column에 강조를 필요로할때 사용한다.
  gs_fcat-edit = p_edit.              "'X'.      "Edit 기능 추가하기, Edit기능을 추가하면 Edit기능에 필요한 버튼들이 자동으로 추가된다.
  APPEND gs_fcat TO gt_fcat.
ENDFORM.

*----------Data Changed-----------*
*&---------------------------------------------------------------------*
*& Form customer_change_part
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ER_DATA
*&      --> CHANGED
*&      --> LS_MOD_CELLS
*&---------------------------------------------------------------------*
FORM customer_change_part  USING    per_data_changed
                                    TYPE REF TO cl_alv_changed_data_protocol  "타입을 지정해주지않으면 서로다른 타입이라고 convert가뜨거나 제대로 안된다?
                                    "cl_alv_changed_data_protocol = 변경에 대한 클래스
                                    ps_mod_cells TYPE lvc_s_modi.
  "Pattern -> abap Object patterns -> get_cell_value

  DATA : l_customid TYPE ztsbook_a15-customid.
  DATA : l_phone    TYPE ztscustom_A15-telephone.
  DATA : l_email    TYPE ztscustom_A15-email,
         l_name     TYPE ztscustom_A15-name.

  READ TABLE gt_sbook INTO gs_sbook  INDEX ps_mod_cells-row_id.

  "입력하는 내용을 읽는다
  CALL METHOD per_data_changed->get_cell_value
    EXPORTING
      i_row_id    = ps_mod_cells-row_id
*      i_tabix     =
      i_fieldname = 'CUSTOMID'    "내가 건드리고있는 라인,필드
    IMPORTING
      e_value     = l_customid.

  IF l_customid IS NOT INITIAL.

    "Custom 정보를 읽는다.
    READ TABLE gt_custom INTO gs_custom
    WITH KEY id = l_customid.
    IF sy-subrc EQ 0.                  "(for all enrty)기존에 있는 내용이 있으면 전화번호,이메일,이름을 넣기
        l_phone = gs_custom-telephone.
        l_email = gs_custom-email.
        l_name  = gs_custom-name.
      ELSE.                            "없으면(else) 데이터베이스를 뒤저서 찾아온다.
        "이 부분을 쓴 이유는 데이터를 찾겠다고 DB를 왔다갔다하면 퍼포먼스가 떨어지기때문에 최대한 DB에 적게 접근하기위해 쓴 것.
        SELECT SINGLE telephone email name INTO
          (l_phone, l_email, l_name)
          FROM ztscustom_a15
          WHERE id = l_customid.
      ENDIF.

      ELSE.
        CLEAR : l_email, l_phone, l_name.   "Initial인경우, 내가 입력한것이없으니 너도 지워 라는 의미이다.
      ENDIF.

      CALL METHOD per_data_changed->modify_cell       "modify_cell = 화면상에 보이는것을 바꾸는것이다.
        EXPORTING
          i_row_id     = ps_mod_cells-row_id     "내가 지금 입력하고 있는 위치를 알려주는 역할을한다.
          i_fieldname  = 'TELEPHONE'
          i_value      = l_phone.

     CALL METHOD per_data_changed->modify_cell   "내가 지금 입력하고 있는 위치를 알려주는 역할을한다.
        EXPORTING
          i_row_id     = ps_mod_cells-row_id
          i_fieldname  = 'EMAIL'
          i_value      = l_email.

     CALL METHOD per_data_changed->modify_cell   "내가 지금 입력하고 있는 위치를 알려주는 역할을한다.
        EXPORTING
          i_row_id     = ps_mod_cells-row_id
          i_fieldname  = 'PASSNAME'
          i_value      = l_name.
*-----지금 이순간까지는 보이는 화면"만"바뀐것이다. 그래서 이제 인터널테이블 내용을 바꾸기위해 밑의 modify구문을 쓰는것.-----*




     gs_sbook-email = l_email.
     gs_sbook-telephone = l_phone.
     gs_sbook-passname = l_name.

      MODIFY gt_sbook FROM gs_sbook INDEX ps_mod_cells-row_id.
      "바꾼다음에는 실제 인터널 테이블도 MODIFY한다.


  "GET CELL VALUE =
  "MODIFY CELL = 입력되지않은 셀을 변경하는것



ENDFORM.
*&---------------------------------------------------------------------*
*& Form insert_parts
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ER_DATA_CHANGED
*&      --> LS_INS_CELLS
*&---------------------------------------------------------------------*
FORM insert_parts  USING    rr_data_changed TYPE REF TO
                            cl_alv_changed_data_protocol
                            Rs_ins_cells TYPE lvc_s_moce.

  "셀렉션스크린에 있는값을 직접 주려고 쓴것.
  gs_sbook-carrid = so_car-low.  "so_car-sign = 'I' so_car-option = 'EQ'.
  gs_sbook-connid = so_con-low.
  gs_sbook-fldate = so_fld-low.


  CALL METHOD rr_data_changed->modify_cell
    EXPORTING
      i_row_id    = Rs_ins_cells-row_id
      i_fieldname = 'CARRID'
      i_value     = gs_sbook-carrid.     "ALV에서 드래그해서 추가했을때 셀렉션 스크린에서 입력한 값이 자동으로 들어가게해주는것.


  CALL METHOD rr_data_changed->modify_cell
    EXPORTING
      i_row_id    = Rs_ins_cells-row_id
      i_fieldname = 'CONNID'
      i_value     = gs_sbook-connid.



  CALL METHOD rr_data_changed->modify_cell
    EXPORTING
      i_row_id    = Rs_ins_cells-row_id
      i_fieldname = 'FLDATE'
      i_value     = gs_sbook-fldate.



  CALL METHOD rr_data_changed->modify_cell
    EXPORTING
      i_row_id    = Rs_ins_cells-row_id
      i_fieldname = 'ORDER_DATE'        "Booking 날짜
      i_value     = sy-datum.

  CALL METHOD rr_data_changed->modify_cell
    EXPORTING
      i_row_id    = Rs_ins_cells-row_id
      i_fieldname = 'CUSTTYPE'
      i_value     = 'P'.

  CALL METHOD rr_data_changed->modify_cell
    EXPORTING
      i_row_id    = Rs_ins_cells-row_id
      i_fieldname = 'CLASS'
      i_value     = 'C'.


  PERFORM modify_style USING rr_data_changed
                             Rs_ins_cells
                             'CONNID'.
  PERFORM modify_style USING rr_data_changed
                             Rs_ins_cells
                             'FLDATE'.
  PERFORM modify_style USING rr_data_changed
                             Rs_ins_cells
                             'CUSTTYPE'.
  PERFORM modify_style USING rr_data_changed
                             Rs_ins_cells
                             'CLASS'.
  PERFORM modify_style USING rr_data_changed
                             Rs_ins_cells
                             'DISCOUNT'.
  PERFORM modify_style USING rr_data_changed
                            Rs_ins_cells
                            'SMOKER'.
  PERFORM modify_style USING rr_data_changed
                           Rs_ins_cells
                           'LUGGWEIGHT'.
  PERFORM modify_style USING rr_data_changed
                           Rs_ins_cells
                           'WUNIT'.
  PERFORM modify_style USING rr_data_changed
                          Rs_ins_cells
                          'INVOICE'.
  PERFORM modify_style USING rr_data_changed
                          Rs_ins_cells
                          'FORCURAM'.
  PERFORM modify_style USING rr_data_changed
                         Rs_ins_cells
                         'FORCURKEY'.
  PERFORM modify_style USING rr_data_changed
                       Rs_ins_cells
                       'LOCCURAM'.
  PERFORM modify_style USING rr_data_changed
                        Rs_ins_cells
                        'LOCCURKEY'.
  PERFORM modify_style USING rr_data_changed
                        Rs_ins_cells
                        'ORDER_DATE'.
  PERFORM modify_style USING rr_data_changed
                        Rs_ins_cells
                        'AGENCYNUM'.


  MODIFY gt_sbook FROM gs_sbook INDEX Rs_ins_cells-row_id .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form modify_style
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> RR_DATA_CHANGED
*&      --> RS_INS_CELLS
*&      --> P_
*&---------------------------------------------------------------------*
FORM modify_style  USING  rr_data_changed  TYPE REF TO
                             cl_alv_changed_data_protocol
                            Rs_ins_cells TYPE lvc_s_moce
                            VALUE(p_val).

  CALL METHOD rr_data_changed->modify_style
    EXPORTING
      i_row_id    = Rs_ins_cells-row_id
      i_fieldname = p_val
      i_style     = cl_gui_alv_grid=>mc_style_enabled.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form modify_check
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_MOD_CELLS
*&---------------------------------------------------------------------*
FORM modify_check  USING    pls_mod_cells TYPE lvc_s_modi.

  READ TABLE gt_sbook INTO gs_sbook INDEX pls_mod_cells-row_id.
   IF sy-subrc EQ 0.  "값을 읽었으면
     gs_sbook-modified = 'X'.
     MODIFY gt_sbook FROM gs_sbook INDEX pls_mod_cells-row_id.      "modify하는 대상은 index를 주어야한다. 안주면 dump남.
   ENDIF.

ENDFORM.

*-----100번스크린 Module  USER_COMMAND_0100-----------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  DATA : p_ans TYPE c LENGTH 1.

  CASE ok_code.

    WHEN 'SAVE'.
      "save를 눌렀을때 다시한번 물어보는 팝업창 만들기   (pattern -> popup_to_confirm)
      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
         titlebar                    = 'Data Save'
         text_question               = '정말로 저장하시겠습니까?'
         text_button_1               = 'Yes'(001)
         text_button_2               = 'No'(002)
*         DEFAULT_BUTTON              = '1'    "1 = Yes  2 = No
         display_cancel_button       = ''      "Cancel버튼

       IMPORTING
         answer                      = p_ans      "yes를 눌렀는지 no를눌렀는지 알려주는것
       EXCEPTIONS
         text_not_found              = 1
         OTHERS                      = 2.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ELSE.
        IF p_ans = '1'.
          PERFORM data_save.
        ENDIF.
      ENDIF.


      PERFORM data_save.

  ENDCASE.
ENDMODULE.

*&---------------------------------------------------------------------*
*& Form data_save
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM data_save.
  DATA : ins_sbook TYPE TABLE OF ztsbook_a15,
         wa_sbook  TYPE ztsbook_a15.           "insert를 한번에 모으려고 만든 work area



  CLEAR : ins_sbook.
  REFRESH : ins_sbook.
*--Update 대상
  LOOP AT gt_sbook INTO gs_sbook WHERE modified = 'X'.

    UPDATE ztsbook_a15
        SET customid = gs_sbook-customid
            cancelled = gs_sbook-cancelled
            passname = gs_sbook-passname
      WHERE carrid = gs_sbook-carrid         "update 조건
        AND connid = gs_sbook-connid
        AND fldate = gs_sbook-fldate
        AND bookid = gs_sbook-bookid.
  ENDLOOP.

*-----insert 부분-----*    "SAVE를 눌렀을때 book.no가 자동으로 따지고 그 정보들이 DB테이블에도 저장되게 하는로직
  "insert = 추가해서 booking id를 따는것?, bookingid가 없는애들이 insert대상이다.
  DATA : next_number TYPE s_book_id,
         ret_code    TYPE inri-returncode.

  DATA : l_tabix LIKE sy-tabix.

  LOOP AT gt_sbook INTO gs_sbook
    WHERE bookid IS INITIAL.         "bookid가 비어있을때

    l_tabix = sy-tabix.               "내 위치를 기억하게끔 ,쓰지않으면 내가 변경하고자할때 위치가바뀌어버리기때문에 사전에 방지하기위해 쓰는것.

    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        nr_range_nr                   = '01'
        object                        = 'ZBOOKIDA15'       "넘버레인지
       subobject                     = gs_sbook-carrid
       ignore_buffer                 = ''
     IMPORTING
       number                        = next_number  "다음번호로 번호를 알려주는것.
       returncode                    = ret_code
     EXCEPTIONS
       interval_not_found            = 1
       number_range_not_intern       = 2
       object_not_found              = 3
       quantity_is_0                 = 4
       quantity_is_not_1             = 5
       interval_overflow             = 6
       buffer_overflow               = 7
       OTHERS                        = 8.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ELSE.
      IF next_number IS NOT INITIAL.
        gs_sbook-bookid = next_number.

        MOVE-CORRESPONDING gs_sbook TO wa_sbook.         "우리가 빼고 추가하고등등 여러가지를 해서 공간이 같지않기때문에 corresponding를 쓴다.
        APPEND wa_sbook TO ins_sbook.

        MODIFY gt_sbook FROM gs_sbook INDEX l_tabix
              TRANSPORTING bookid.

      ENDIF.

    ENDIF.
  ENDLOOP.

  IF ins_sbook IS NOT INITIAL.
    INSERT ztsbook_a15 FROM TABLE ins_sbook.        "ztsbook_a15 = db테이블     ins_sbook. = 데이터가 쌓아진곳

  ENDIF.

*---Delete파트
 IF dl_sbook IS NOT INITIAL.
   DELETE ztsbook_a15 FROM TABLE dl_sbook.

   CLEAR : dl_sbook.       "clear : 라인하나를지우거나 통으로 지우는역할, 구조를 clear
   REFRESH : dl_sbook.     "refresh : 안에있는 내용을 clear하는것.
 ENDIF.



ENDFORM.
