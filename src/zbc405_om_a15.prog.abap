*&---------------------------------------------------------------------*
*& Report ZBC405_OM_A15
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc405_om_a15.

TABLES : spfli.

SELECT-OPTIONS : so_car FOR spfli-carrid MEMORY ID car,
                 so_con FOR spfli-connid MEMORY ID con.

DATA : gt_spfli TYPE TABLE OF spfli,
       gs_spfli TYPE spfli.

DATA : go_alv     TYPE REF TO cl_salv_table,  "cl_salv_table = 메인 , 여기서 파생해서 추가할거임.
       go_func    TYPE REF TO cl_salv_functions_list,       "functions 결과값
       go_disp    TYPE REF TO cl_salv_display_settings,
       go_columns TYPE REF TO cl_salv_columns_table,
       go_column  TYPE REF TO cl_salv_column_table,
       go_cols    TYPE REF TO cl_salv_column,
       go_layout  TYPE REF TO cl_salv_layout,
       go_selc    TYPE REF TO cl_salv_selections.

START-OF-SELECTION.

  SELECT *
    INTO TABLE gt_spfli
    FROM spfli
   WHERE carrid IN so_car
     AND connid IN so_con.

  TRY.  "클래스를 사용할때 의도치 않은 에러나 덤프를 방지해준다.(타입을 잘못넣는다던지,이름을 잘못넣는다던지.)(사용하는게 좋다)
      CALL METHOD cl_salv_table=>factory          "이름이 바로 딸려왔으니 스태틱이다.
        EXPORTING
          list_display = ''          "IF_SALV_C_BOOL_SAP=>FALSE = ' ' , true = 'X'
*         r_container  =
*         container_name =
        IMPORTING
          r_salv_table = go_alv      "인스턴스생성
        CHANGING
          t_table      = gt_spfli.   "출력할 인스턴스 테이블
    CATCH cx_salv_msg.
  ENDTRY.



  CALL METHOD go_alv->get_functions     "SALV테이블 현재의 상태를 알려주는것.
    RECEIVING
      value = go_func.                  "go_func 에 하나씩 얹는다.   "SALV테이블 세팅

*----------go_func----------*
  "버튼 추가하기

  CALL METHOD go_func->set_group_filter. "Filter버튼 추가
*  EXPORTING
*    value  = IF_SALV_C_BOOL_SAP=>TRUE.

  CALL METHOD go_func->set_sort_asc. "Sort, Ascending 버튼 추가
*  EXPORTING
*    value  = IF_SALV_C_BOOL_SAP=>TRUE.

  CALL METHOD go_func->set_sort_desc. "Sort, Descending 버튼 추가
*  EXPORTING
*    value  = IF_SALV_C_BOOL_SAP=>TRUE.

  CALL METHOD go_func->set_all. "기본 버튼들 추가(프린트 같은거)

*-- display setting --*     "실행화면 설정
  CALL METHOD go_alv->get_display_settings
    RECEIVING
      value = go_disp.    "go_disp에 얹는다.

  CALL METHOD go_disp->set_list_header
    EXPORTING
      value = 'SALV DEMO!!!!!'.

  "Zebra Pattern   지브라 패턴
  CALL METHOD go_disp->set_striped_pattern
    EXPORTING
      value = 'X'.


*--
  CALL METHOD go_alv->get_columns    "columns들의 정보를 알기위해
    RECEIVING
      value = go_columns.

  "col_opt 기능과 같다.
  CALL METHOD go_columns->set_optimize.
*    EXPORTING
*      value  = IF_SALV_C_BOOL_SAP~TRUE.

  TRY.
      CALL METHOD go_columns->get_column
        EXPORTING
          columnname = 'MANDT'      "찾으려는 필드명
        RECEIVING
          value      = go_cols.
    CATCH cx_salv_not_found.
  ENDTRY.


  go_column ?= go_cols.         " '?=' = Casting, type이 달라도 구문오류 없이 인정(같은 부모 밑에있으니까)

  "필드 카탈로그의 tech기능과 같다.
  CALL METHOD go_column->set_technical.
*  EXPORTING
*    value  = IF_SALV_C_BOOL_SAP=>TRUE


* 필드에 색깔주기
  TRY.
      CALL METHOD go_columns->get_column      "get과 set은 반복이다.
        EXPORTING
          columnname = 'FLTIME'
        RECEIVING
          value      = go_cols.
    CATCH cx_salv_not_found.
  ENDTRY.

  go_column ?= go_cols.

  DATA: g_color TYPE lvc_s_colo.

  g_color-col = '5'.
  g_color-int = '1'.
  g_color-inv = '0'.

  CALL METHOD go_column->set_color            "get과 set은 반복이다.
    EXPORTING
      value = g_color.

* 레이아웃 저장 버튼 추가
  CALL METHOD go_alv->get_layout
    RECEIVING
      value = go_layout.

* 프로그램이라는 키를 설정해주어야 한다.
  DATA : g_program TYPE salv_s_layout_key.   "키를 설정하는 이유는 내가 지금 실행하고있는 프로그램을 알려주기위해서?

  g_program-report = sy-cprog.    "키 설정

  CALL METHOD go_layout->set_key
    EXPORTING
      value = g_program.

  CALL METHOD go_layout->set_save_restriction
    EXPORTING
      value = if_salv_c_layout=>restrict_none.   "restrict_none = 상관없이 다 저장. = i_save = all과 같다.
  "dependent = u ,INDEPENDANT =  x

  " 레이아웃에서 default버튼? 추가
  CALL METHOD go_layout->set_default
    EXPORTING
      value = 'X'.

*---selection mode---*      CL_SALV_TABLE에 있음
  CALL METHOD go_alv->get_selections
    RECEIVING
      value = go_selc.

  "selmode
  CALL METHOD go_selc->set_selection_mode
    EXPORTING
      value = if_salv_c_selection_mode=>row_column. "single, multiple, cell, row_column, none




  CALL METHOD go_alv->display.
  "xxx->display. 에서 xxx에는 우리가 만든 인스턴스가 들어가야한다. CALL METHOD xxxxxxxx->get_functions
