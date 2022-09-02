*&---------------------------------------------------------------------*
*& Report ZBC405_A15_ALV
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc405_a15_alv.

TYPES BEGIN OF typ_flt.
INCLUDE TYPE sflight.       "Incldue는 Types없이 단독으로 쓴다.
TYPES : changes_possible TYPE icon-id.
TYPES : light TYPE c LENGTH 1.        "Exception Handling Field
TYPES : btn_Text TYPE c LENGTH 10.
TYPES : row_color TYPE c LENGTH 4.      "row_color = 값이 들어오게되면 그 레코드(row)는 색깔이 들어간다.
TYPES : it_color TYPE lvc_t_scol.    "셀별로 색깔을 담는다.
TYPES : it_styl TYPE lvc_t_styl.     "본인 스스로 APPEND를 못한다.
TYPES : END OF typ_flt.



DATA : gt_flt TYPE TABLE OF typ_flt.  "sflight.
DATA : gs_flt TYPE typ_flt.           " 워크 에이리어
DATA : ok_code LIKE sy-ucomm.         "버튼 눌렀을때 이벤트


*-------ALV Data 선언----------------  "테이블을 선언하면 중간다리역할을 할 워크 에이리어도 선언해주어야한다?
DATA : go_container TYPE REF TO cl_gui_custom_container,    "컨테이너를 위한거
       go_alv_grid  TYPE REF TO cl_gui_alv_grid,            "ALV를 위한거, cl_gui_alv_grid를 참조한것.
       gv_variant   TYPE disvariant,                        "Variant 활성화
       gv_save      TYPE c LENGTH 1,                        "Save 활성화
       gs_layout    TYPE lvc_s_layo,                      "layout 데이터설정
       gt_sort      TYPE lvc_t_sort,          "sort 설정, lvc_s_sort와 한쌍으로 존재한다.
       gs_sort      TYPE lvc_s_sort,          "sort 설정, lvc_t_sort와 한쌍으로 존재한다.
       gs_color     TYPE lvc_s_scol,
       gt_exct      TYPE ui_functions,
       gt_fcat      TYPE lvc_t_fcat,          "필드 카탈로그
       gs_fcat      TYPE lvc_s_fcat,
       gs_styl      TYPE lvc_s_styl.

"리프레쉬 파라미터에 들어감.
DATA : gs_stable       TYPE lvc_s_stbl,     "
       gv_soft_refresh TYPE abap_bool.      "참 거짓, X아니면 Space  X면참 Space면 거짓  (X or Space)


"앞에 선언한 필드값들(글로벌변수)도 써야하기때문에  맨 위에 include를 하지 않는다.
*------클래스----------
INCLUDE zbc405_a15_alv_class.


*-------Selection-Screen------------

SELECT-OPTIONS : so_car FOR gs_flt-carrid MEMORY ID car,
                 so_con FOR gs_flt-connid MEMORY ID con,
                 so_dat FOR gs_flt-fldate.


SELECTION-SCREEN SKIP 1.                     "한줄 띄우기

PARAMETERS : p_date TYPE sy-datum DEFAULT '20201001'.    "changes_possible, 입력한 날짜로 비교하려고 만든거임.

*------- 파서블 엔트리가 뜨게 설정하기(F4)
PARAMETERS : pa_lv TYPE disvariant-variant.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR pa_lv.   "AT SELECTION-SCREEN ON VALUE-REQUEST FOR = 버튼을 누르는 순간 타는 이벤트
  "return 되는 순간 pa_lv에 넣어라~
  gv_variant-report = sy-cprog.


  CALL FUNCTION 'LVC_VARIANT_SAVE_LOAD'
    EXPORTING
      i_save_load     = 'F'        "S, F, L    s=save ,f=f4 ,l=load
    CHANGING
      cs_variant      = gv_variant
    EXCEPTIONS
      not_found       = 1
      wrong_input     = 2
      fc_not_complete = 3
      OTHERS          = 4.
  IF sy-subrc <> 0.      "0: 성공  4: error,실패
* Implement suitable error handling here
  ENDIF.
*-------

START-OF-SELECTION.

  PERFORM get_data.



  CALL SCREEN 100.
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'S100'.
  SET TITLEBAR 'T10' WITH sy-datum sy-uname.   "datum오늘날짜,uname사용자이름
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE ok_code.

    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.

      CALL METHOD go_alv_grid->free. "메모리확보를 위해서 묵시적으로 free를 해주는과정.(안해줘도 문제는 없었다)
      CALL METHOD go_container->free. "내가만든 오브젝트가 릴리즈되고 새로운게 되는과정.(메모리)

      FREE : go_alv_grid, go_container.
      LEAVE TO SCREEN 0.  "SET Screen 0.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CREATE_AND_TRANSFER OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE create_and_transfer OUTPUT.

  IF go_container IS INITIAL.
    CREATE OBJECT go_container
      EXPORTING
        container_name = 'MY_CONTROL_AREA'
      EXCEPTIONS
        OTHERS         = 6.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.



    CREATE OBJECT go_alv_grid
      EXPORTING
        i_parent = go_container
      EXCEPTIONS
        OTHERS   = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
*--------------------perform------------------------
    PERFORM make_variant.

    PERFORM make_layout.

    PERFORM make_sort.

    PERFORM make_fieldcatalog.
*--------------------perform------------------------
    " ALV툴바에서 특정 툴바 지우기       Excluding(안보이게 숨기기)
    APPEND cl_gui_alv_grid=>mc_fc_filter TO gt_exct.             "=> = 어트리뷰트를 직접 참조한다 라는뜻
    APPEND cl_gui_alv_grid=>mc_fc_info   TO gt_exct.

*    APPEND cl_gui_alv_grid=>mc_fc_excl_all TO gt_exct.   "ALV툴바가 전부 사라진다. ( mc_fc_excl_all = 전체 )


*------------------------SET HANDLER 이벤트 트리거 부분--------------------*ㄴ
    SET HANDLER lcl_handler=>on_doubleclick  FOR go_alv_grid.  "set handler = 이벤트를 탈 수 있게 트리거 해준다.(이벤트 트리거)
    SET HANDLER lcl_handler=>on_hotspot      FOR go_alv_grid.
    SET HANDLER lcl_handler=>on_toolbar      FOR go_alv_grid.
    SET HANDLER lcl_handler=>on_user_command FOR go_alv_grid.
    SET HANDLER lcl_handler=>on_button_click FOR go_alv_grid.
    SET HANDLER lcl_handler=>on_context_menu_request FOR go_alv_grid.
    SET HANDLER lcl_handler=>on_before_user_com FOR go_alv_grid.





    CALL METHOD go_alv_grid->set_table_for_first_display
      EXPORTING
*       i_buffer_active               =
*       i_bypassing_buffer            =
*       i_consistency_check           =
        i_structure_name              = 'SFLIGHT'     "i_structure_name 가 가지고 있는 컴포넌트들이 보여진다.(SFLIGHT)
        is_variant                    = gv_variant
        i_save                        = gv_save    "X, A, U,  Space면 변경은 가능하나 저장이 안됨.
        i_default                     = 'X'        "x가 있으면 버튼이 보이고 비어있으면 사라진다.
        is_layout                     = gs_layout
*       is_print                      =
*       it_special_groups             =
        it_toolbar_excluding          = gt_exct
*       it_hyperlink                  =
*       it_alv_graphics               =
*       it_except_qinfo               =
*       ir_salv_adapter               =
      CHANGING
        it_outtab                     = gt_flt
        it_fieldcatalog               = gt_fcat                           "gt_flt에 보여지는 속성을 정의해주는 카탈로그이다.
        "SFLIGHT에 없는 값을 필드 카탈로그에 넣을 수 있다.(없는값을 넣을땐 당연히 types로 선언을 해주어야한다.
        "필드 카탈로그를 사용하는 경우가 더많다.(한 테이블에 모든 정보가 담겨있는 경우가 거의 없기때문)
        it_sort                       = gt_sort
*       it_filter                     =
      EXCEPTIONS
        invalid_parameter_combination = 1
        program_error                 = 2
        too_many_lines                = 3
        OTHERS                        = 4.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

  ELSE.


    "만드는 법: 패턴 -> 2번재 아밥 오브젝트 패턴 -> 1. GO_ALV_GRID / 2. CL_GUI_ALV_GRID / 3. REFRESH_TABLE_DISPLAY
*    ON CHANGE OF gt_flt.
    gv_soft_refresh = 'X'.   "Sort를 기억
    gs_stable-row = 'X'.     "스크롤 위치를 기억.
    gs_stable-col = 'X'.


    CALL METHOD go_alv_grid->refresh_table_display
      EXPORTING
        is_stable      = gs_stable
        i_soft_refresh = gv_soft_refresh
      EXCEPTIONS
        finished       = 1
        OTHERS         = 2.
    IF sy-subrc <> 0.
*     Implement suitable error handling here
    ENDIF.
  ENDIF.



ENDMODULE.
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .

  SELECT *
  FROM sflight
  INTO CORRESPONDING FIELDS OF TABLE gt_flt   "into table이면 순서와 이름이 모두 똑같아야한다.
                                              "필드가 추가되어서 CORRESPONDING FIELDS 로 바뀐것.
 WHERE carrid IN so_car
   AND connid IN so_con
   AND fldate IN so_dat.

  "남은 좌석수에 따라서 신호등으로 표시하는 로직
  LOOP AT gt_flt INTO gs_flt.

    IF gs_flt-seatsocc < 5.
      gs_flt-light = 1.     "빨간불

    ELSEIF gs_flt-seatsocc < 100.
      gs_flt-light = 2.     "노란불

    ELSE.
      gs_flt-light = 3.

    ENDIF.

    "조건별로 해당 조건의 값을 가진 row에 색깔을 넣는 로직
    IF gs_flt-fldate+4(2) = sy-datum+4(2).     "+4(2) = YYYY/MM/DD , +4 = YYYY, 즉 4번째자리 (2)는 두자리의 값.
      " = 해당 코드를 해석하면 sy_datum, 오늘일자 +4(2) yyyy/mm = 월이 같으면~~한다 라는것이다.(이 경우엔 색을 칠한다가 된다.)
      gs_flt-row_color = 'C311'.               "C = Color 3은 색(RGB랑 비슷한듯), 두번째1 = 강조 0 = 강조안함, 세번째1 = 색상반전
      " 0 = 색상반전안함
    ENDIF.

    "조건별로 해당 조건의값을 가진 셀에 색깔을 넣는 로직 (이 경우에는 PLANETYPE이 747-400 인거)
    IF gs_flt-planetype = '747-400'.       "조건
      gs_color-fname = 'PLANETYPE'.
      gs_color-color-col = col_total.    "내스팅?내스핑? 구조여서 이렇게 쓰인다.
      gs_color-color-int = '1'.          "1이면 색깔이 진하게 0이면 색깔이 연하게
      gs_color-color-inv = '0'.
      APPEND gs_color TO gs_flt-it_color.
    ENDIF.

    "조건별로 해당 조건의값을 가진 셀에 색깔을 넣는 로직 (이 경우에는 seatsmax_b가 0 인거)
    IF gs_flt-seatsmax_b = 0.
      gs_color-fname = 'SEATSMAX_B'.
      gs_color-color-col = col_negative.
      gs_color-color-int = '1'.
      gs_color-color-inv = '0'.
      APPEND gs_color TO gs_flt-it_color.
    ENDIF.

    "아이콘 넣기
    IF gs_flt-fldate < p_date.

      gs_flt-changes_possible = icon_space.
    ELSE.
      gs_flt-changes_possible = icon_okay.
    ENDIF.

    "셀에 버튼넣기
    IF gs_flt-seatsmax_b = gs_flt-seatsocc_b.
      gs_flt-btn_text = 'FullSeats!'.

      gs_styl-fieldname = 'BTN_TEXT'.
      gs_styl-style = cl_gui_alv_grid=>mc_style_button.
      APPEND gs_styl TO gs_flt-it_styl.


    ENDIF.

    MODIFY gt_flt FROM gs_flt.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form make_variant
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM make_variant .
  gv_variant-report = sy-cprog.
  gv_variant-variant = pa_lv.
  gv_save = 'A'.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form make_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM make_layout .
  gs_layout-zebra = 'X'.
*  gs_layout-cwidth_opt = 'X'.     "Fieldcatalog col_opt 역할.  , 셀 크기 조절하는 로직이다.
  gs_layout-sel_mode = 'D'.       "A B C D Space  D = 모두 가능한것.

  gs_layout-excp_fname = 'LIGHT'.    "Exception Handling Field 설정
  gs_layout-excp_led = 'X'.          "신호등 모양 바꾸기 (신호등 하나짜리로)

  gs_layout-info_fname = 'ROW_COLOR'.   "레코드(row) 별로 색깔을 다르게해주는것
  gs_layout-ctab_fname = 'IT_COLOR'.    "ctab = color table

  gs_layout-stylefname = 'IT_STYL'.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form make_sort
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM make_sort .

  CLEAR gs_sort.                  "워크에이리어가 반복될때는 항상 클리어하는습관을 가지기
  gs_sort-fieldname = 'CARRID'.
  gs_sort-up = 'X'.                   "up = Ascending 오름차순
  gs_sort-spos = 1.                   "spos = 순서
  APPEND gs_sort TO gt_sort.

  CLEAR gs_sort.
  gs_sort-fieldname = 'CONNID'.
  gs_sort-up = 'X'.
  gs_sort-spos = 2.
  APPEND gs_sort TO gt_sort.

  CLEAR gs_sort.
  gs_sort-fieldname = 'FLDATE'.
  gs_sort-down = 'X'.                 "down = Descending 내림차순
  gs_sort-spos = 3.
  APPEND gs_sort TO gt_sort.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form make_fieldcatalog
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
" 필드 이름바꾸는 로직(원래는 Exception 이였음)
FORM make_fieldcatalog .

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'CARRID'.
*  gs_fcat-hotspot = 'X'.
  APPEND gs_fcat TO gt_fcat.


  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'LIGHT'.
  gs_fcat-coltext = 'Info'.    "coltext = 컬럼 텍스트
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'PRICE'.
*  gs_fcat-no_out = 'X'.         "no_out = 안보이게 설정하기 (price 안보이게 설정)
  gs_fcat-col_opt = 'X'.         "셀 크기 조절하기(gs_layout-cwidth_opt = 'X'.)
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'PRICE'.
  gs_fcat-emphasize = 'C610'.
*   gs_fcat-edit = 'X'.         "edit 모드로 변경된다. (입력이 가능해짐)
  APPEND gs_fcat TO gt_fcat.



  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'CHANGES_POSSIBLE'.   "sflight에 없는 필드여서 types에 추가하고 위치설정도 해주어야한다.(안해주면 맨앞으로감)
  gs_fcat-coltext = 'Chang.poss'.
  gs_fcat-col_opt = 'X'.         "셀 크기 조절하기(gs_layout-cwidth_opt = 'X'.)
  gs_fcat-col_pos = 5.                      "위치 설정
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'SEATSOCC'.
  gs_fcat-do_sum = 'X'.              "기본적으로 seatsocc sum값 구하기
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'PAYMENTSUM'.
  gs_fcat-no_out = 'X'.               "paymentsum 숨기기(no_out)
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'BTN_TEXT'.
  gs_fcat-coltext = 'Status'.
  gs_fcat-col_pos = 12.
  APPEND gs_fcat TO gt_fcat.

ENDFORM.
