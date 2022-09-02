*&---------------------------------------------------------------------*
*& Include          ZBC405_A15_ALV_CLASS
*&---------------------------------------------------------------------*

*클래스 선언하는 부분
CLASS lcl_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS : on_doubleclick FOR EVENT double_click   "on_doubleclick = 우리가 정한 이름, 더블클릭 이벤트
      OF cl_gui_alv_grid
      IMPORTING e_row  e_column  es_row_no,

      on_hotspot     FOR EVENT hotspot_click  "hotspot = 한번 눌렀을때
        OF cl_gui_alv_grid
        IMPORTING e_row_id  e_column_id  es_row_no,

      on_toolbar     FOR EVENT toolbar        "버튼 생성
        OF cl_gui_alv_grid
        IMPORTING e_object,

      on_user_command FOR EVENT user_command  "생성한 버튼에대한 동작
        OF cl_gui_alv_grid
        IMPORTING e_ucomm,

      on_button_click FOR EVENT button_click  ""셀의 버튼을 클릭하면 메시지 띄우기
        OF cl_gui_alv_grid
        IMPORTING es_col_id  es_row_no,

*----컨텍스트 메뉴----*
      on_context_menu_request FOR EVENT context_menu_request
        OF cl_gui_alv_grid
        IMPORTING e_object,   "클래스타입을 주는건 타입이 다 크리에이트 된 것이다.?

*----Before UserCommand----*       "ALV 스탠다드 툴바를 사용자가 원하는것으로 변경
      on_before_user_com FOR EVENT before_user_command
        OF cl_gui_alv_grid
        IMPORTING e_ucomm.


ENDCLASS.

*-----------------로직(어떤 역할을 하느냐를 설명하는 곳)-----------------------*
CLASS lcl_handler IMPLEMENTATION.

  "더블클릭했을때
  METHOD on_doubleclick.
    DATA: total_occ TYPE i.                             "로컬변수, 이 메소드 안에서만 사용하는 변수이다.
    DATA: total_occ_c TYPE c LENGTH 10.                 "로컬변수, 이 메소드 안에서만 사용하는 변수이다.

    CASE e_column-fieldname.              "CHANGES_POSSIBLE을 더블클릭했을때 이벤트가 발생하게 하는 부분.
      WHEN 'CHANGES_POSSIBLE'.            "case를 사용하지않을 경우에는 어디를 더블클릭하던 전부 이벤트(메시지)가 발생한다.
        "case~ 이 부분이 없으면 전체 라인클릭에 해당한다.
        READ TABLE gt_flt INTO gs_flt INDEX es_row_no-row_id.  "gs_flt의 내용중 es_row_no-row_id만 얻는다.
        IF sy-subrc EQ 0.
          total_occ = gs_flt-seatsocc + gs_flt-seatsocc + gs_flt-seatsocc_f.     "이코노미 / 비즈니스 / 퍼스트
          "좌석의 합계 구하기.
          total_occ_c = total_occ.
          CONDENSE total_occ_c. "숫자는 오른쪽정렬 문자는 왼쪽정렬이라서 왼쪽으로 정렬하기위해서
          "total_occ_c가 문자열 10자리기때문에 condense를 사용하지 않으면 숫자가 오른쪽에 몰려서 나오기때문에 사용한 것이다.
          MESSAGE i000(zt03_msg) WITH 'Total number of bookings:'
                             total_occ_c.

        ELSE.
          MESSAGE i075(bc405_408).       "인터널 에러
          EXIT.
        ENDIF.

    ENDCASE.

  ENDMETHOD.

  "한번 눌렀을때(hotspot) 이벤트가 발생하는로직, 이 경우엔 항공시코드를 눌렀을때 해당 항공사 이름을 나오게.
  METHOD on_hotspot.
    DATA: carr_name TYPE scarr-carrname.
    CASE e_column_id-fieldname.
      WHEN 'CARRID'.
        READ TABLE gt_flt INTO gs_flt INDEX es_row_no-row_id.  "gs_flt의 내용중 es_row_no-row_id만 얻는다.
        IF sy-subrc EQ 0.
          SELECT SINGLE carrname
            INTO carr_name
            FROM scarr
           WHERE carrid = gs_flt-carrid.
          IF sy-subrc EQ 0.
            MESSAGE i000(zt03_msg) WITH carr_name.
          ELSE.
            MESSAGE i000(zt03_msg) WITH 'No found'.
          ENDIF.

        ELSE.
          MESSAGE i075(bc405_408).
          EXIT.
        ENDIF.
    ENDCASE.

  ENDMETHOD.

  "Toolbar와 User_command는 항상 쌍으로 만들어진다.
  "버튼을 생성하는 이벤트. (toolbar)
  METHOD on_toolbar.
    DATA: ls_button TYPE stb_button.      "Work Area

    CLEAR : ls_button.
    ls_button-function = 'PERCENTAGE'.
*    ls_button-icon = ?
    ls_button-quickinfo = 'Occupied Percentage'.  "quickinfo = 커서를 갖다댔을때 설명나오는것.
    ls_button-butn_type = '0'.              " 노말 버튼(0)
    ls_button-text = 'Percentage'.          "버튼 텍스트 설정
    INSERT ls_button INTO TABLE e_object->mt_toolbar.    "mt_toolbar = 버튼을 정의하는 테이블타입

    CLEAR : ls_button.
    ls_button-butn_type = '3'.       "Seperator , 구분선  ,구분선은 맨 뒤에있는 경우에는 표시되지않는다.(필요없기때문)
    INSERT ls_button INTO TABLE e_object->mt_toolbar.


    CLEAR : ls_button.
    ls_button-function = 'PERCENTAGE_MARKED'.
*    ls_button-icon = ?
    ls_button-quickinfo = 'Occupied Percentage'.  "quickinfo = 커서를 갖다댔을때 설명나오는것.
    ls_button-butn_type = '0'.              " 노말 버튼(0)
    ls_button-text = 'Marked Percentage'.          "버튼 텍스트 설정
    INSERT ls_button INTO TABLE e_object->mt_toolbar.

    CLEAR : ls_button.
    ls_button-butn_type = '3'.       "Seperator , 구분선
    INSERT ls_button INTO TABLE e_object->mt_toolbar.

    CLEAR : ls_button.
    ls_button-function = 'GETCARRID'.
    ls_button-icon = icon_ws_plane.
    ls_button-quickinfo = 'Airline Name'.
    ls_button-butn_type = '0'.
*    ls_button-text = 'Airline Name'.
    INSERT ls_button INTO TABLE e_object->mt_toolbar.


  ENDMETHOD.

  "Toolbar와 User_command는 항상 쌍으로 만들어진다. User Command = Toolbar로 만든 버튼에 대한 작동부분
  METHOD on_user_command.

    DATA : lv_occp     TYPE i,  "occp 누적
           lv_capa     TYPE i,  "capa 누적
           lv_perct    TYPE p LENGTH 8 DECIMALS 1,
           lv_text(20).

    DATA : lt_rows TYPE lvc_t_roid,
           ls_rows TYPE lvc_s_roid.

    DATA : lv_col_id TYPE lvc_s_col,
           lv_row_id TYPE lvc_s_row.

    CALL METHOD go_alv_grid->get_current_cell     "유저 커맨드는 해당 위치만 알 수 있기때문에? get_current_cell을 사용하여 위치를
    "위치를 지정해준다.
      IMPORTING
*       e_row     =
*       e_value   =
*       e_col     =
        es_row_id = lv_row_id
        es_col_id = lv_col_id.
    CLEAR lv_text.

    CASE e_ucomm.
      WHEN 'PERCENTAGE'.            "PERCENTAGE버튼을 누르면 전체 좌석중 이미 사용중인? 좌석 비율
        LOOP AT gt_flt INTO gs_flt.
          lv_occp = lv_occp + gs_flt-seatsocc.   "lv_occp를 더하는 이유는 루프를타서?
          lv_capa = lv_capa + gs_flt-seatsmax.
        ENDLOOP.

        lv_perct = lv_occp / lv_capa * 100.
        lv_text = lv_perct.
        CONDENSE lv_text.

        MESSAGE i000(zt03_msg) WITH 'Percentage of occupied seats (%):' lv_text '%'.

      WHEN 'PERCENTAGE_MARKED'.  "선택한 row들에 대한 좌석비율을 보여주는것.
        CALL METHOD go_alv_grid->get_selected_rows      "Pattern으로 불러옴.
          IMPORTING
*            et_index_rows =-
            et_row_no = lt_rows.

        IF lines( lt_rows ) > 0.       "선택된 값이 0보다 크면
          LOOP AT lt_rows INTO ls_rows.

            READ TABLE gt_flt INTO gs_flt INDEX ls_rows-row_id.
            IF sy-subrc EQ 0.
              lv_occp = lv_occp + gs_flt-seatsocc.
              lv_capa = lv_capa + gs_flt-seatsmax.
            ENDIF.

          ENDLOOP.

          lv_perct = lv_occp / lv_capa * 100.
          lv_text = lv_perct.
          CONDENSE lv_text.

          MESSAGE i000(zt03_msg) WITH 'Percentage of occupied seats (%):' lv_text '%'.

        ELSE.
          MESSAGE i000(zt03_msg) WITH 'Please select at least one line!'.
        ENDIF.



      WHEN 'GETCARRID'.
        IF  lv_col_id-fieldname = 'CARRID'.

          READ TABLE gt_flt INTO gs_flt INDEX lv_row_id-index.
          IF sy-subrc EQ 0.
            CLEAR : lv_text.
            SELECT SINGLE carrname
              INTO lv_text
              FROM scarr
             WHERE carrid = gs_flt-carrid.
            IF sy-subrc EQ 0.
              MESSAGE i000(zt03_msg) WITH lv_text.
            ELSE.
              MESSAGE i000(zt03_msg) WITH 'No found!'.
            ENDIF.

          ELSE.
            MESSAGE i000(zt03_msg) WITH '항공사를 선택하세요'.
            EXIT.
          ENDIF.
        ENDIF.

      WHEN 'SCHE'.       "goto flight report      "before유저커맨드로 바꿀 커맨드도 유저커맨드에서 미리 지정해놓아야한다.
        READ TABLE gt_flt INTO gs_flt INDEX lv_row_id-index.
        IF sy-subrc EQ 0.
          SUBMIT bc405_event_d4 AND RETURN             "프로그램 점프
*                    VIA SELECTION-SCREEN
                WITH so_car EQ gs_flt-carrid       "with = 조건을 넣을때는 with를 쓴다.
                WITH so_con EQ gs_flt-connid.
        ENDIF.

    ENDCASE.
  ENDMETHOD.

  "셀의 버튼을 클릭하면 메시지 띄우기
  METHOD on_button_click.
    CASE es_col_id-fieldname.
      WHEN 'BTN_TEXT'.
        READ TABLE gt_flt INTO gs_flt
            INDEX es_row_no-row_id.
        IF ( gs_flt-seatsmax NE gs_flt-seatsocc ) OR    "전체좌석 과 점유좌석이 같지않거나
           ( gs_flt-seatsmax_F NE gs_flt-seatsocc_f ).  "퍼스트클래스 전체좌석과 퍼스트클래스 점유좌석이 같지않으면
          MESSAGE i000(zt03_msg) WITH '다른 등급의 좌석을 예약하세요'.
        ELSE.
          MESSAGE i000(zt03_msg) WITH '모든 좌석이 예약된 상태입니다.'.
        ENDIF.
    ENDCASE.

  ENDMETHOD.



  "컨텍스트 메뉴

  METHOD on_context_menu_request.

    DATA : lv_col_id TYPE lvc_s_col,
           lv_row_id TYPE lvc_s_row.

    CALL METHOD go_alv_grid->get_current_cell      "get_current_cell을 이용해서 특정 셀에서만 특정 컨텍스트 메뉴가 보이게하는 로직..
      IMPORTING
*       e_row     =
*       e_value   =
*       e_col     =
        es_row_id = lv_row_id
        es_col_id = lv_col_id.

    IF lv_col_id-fieldname = 'CARRID'.   "선택된 셀의 필드명이 CARRID일때 보이게 하라는것.

*    CALL METHOD e_object->add_separator. "컨텍스트메뉴도 구분선을 줄 수 있다.
*
*    "자체적으로 불러오는것
*    CALL METHOD cl_ctmenu=>load_gui_status    "이름이 딸려오면 스태틱 메소드
*      EXPORTING
*        program    = sy-cprog
*        status     = 'CT_MENU'           "Context Menu 이름
**       disable    =
*        menu       = e_object
*      EXCEPTIONS
*        read_error = 1
*        OTHERS     = 2.
*    IF sy-subrc <> 0.
** Implement suitable error handling here
*    ENDIF.

      CALL METHOD e_object->add_separator. "컨텍스트메뉴도 구분선을 줄 수 있다.

      "메뉴 한줄을 추가하는것.(add_function)
      CALL METHOD e_object->add_function  "이름이 안딸려오면 인스턴스 메소드 (CALL METHOD xxxxxxxx ->)
        EXPORTING
          fcode = 'DIS_CARR'
          text  = 'Display Airline'
*         icon  =
*         ftype =
*         disabled          =
*         hidden            =
*         checked           =
*         accelerator       =
*         insert_at_the_top = SPACE
        .

    ENDIF.
  ENDMETHOD.

  "Before UserCommand
  METHOD on_before_user_com.

    CASE e_ucomm.
      WHEN cl_gui_alv_grid=>mc_fc_detail.      "detail버튼을 바꾸는것.
        CALL METHOD go_alv_grid->set_user_command
          EXPORTING
            i_ucomm = 'SCHE'.       "Flight schedule report  "유저커맨드에서 when으로 설정해놓음.   sche로 변경
    ENDCASE.

  ENDMETHOD.
ENDCLASS.
