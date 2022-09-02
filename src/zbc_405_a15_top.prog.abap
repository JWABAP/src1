*&---------------------------------------------------------------------*
*& Include ZBC_405_A15_TOP                          - Report ZBC405_A15_TEST
*&---------------------------------------------------------------------*
REPORT zbc405_a15_test.

TABLES : ztspfli_a15.

DATA : ok_code LIKE sy-ucomm.

TYPES: BEGIN OF gty_spfli.
       INCLUDE TYPE ztspfli_a15.
TYPES: int_dom TYPE c LENGTH 2.    "국내선,해외선
TYPES: flight_icon TYPE icon-id.
TYPES: light TYPE c LENGTH 1.      "신호등
TYPES: from_tzone TYPE sairport-time_zone.
TYPES: to_tzone TYPE sairport-time_zone.
TYPES: it_color TYPE lvc_t_scol.
TYPES:  modified  TYPE c LENGTH 1.
TYPES: END OF gty_spfli.

DATA: gt_spfli    TYPE TABLE OF gty_spfli,
      gs_spfli    TYPE          gty_spfli,
      gt_timezone TYPE TABLE OF sairport,
      gs_timezone TYPE sairport.

"ALV 변수
DATA : go_container TYPE REF TO cl_gui_custom_container,
       go_alv       TYPE REF TO cl_gui_alv_grid.

"refresh parameters
DATA : gs_stable       TYPE lvc_s_stbl,
       gv_soft_refresh TYPE abap_bool.

DATA : gs_variant TYPE disvariant,
       gs_layout  TYPE lvc_s_layo,
       gt_fcat    TYPE lvc_t_fcat,     "fcat
       gs_fcat    TYPE lvc_s_fcat,     "fcat
       gs_color   TYPE lvc_s_scol,     "색깔
       gt_exct    TYPE ui_functions.


*-----Class 변수선언-----*
DATA : wa_button TYPE stb_button.
DATA : ls_col  TYPE lvc_s_col,
       ls_roid TYPE lvc_s_roid.
DATA : lv_col_id TYPE lvc_s_col,
       lv_row_id TYPE lvc_s_row,
       lv_text(20),
       lt_rows TYPE lvc_t_row.


INCLUDE zbc405_a15_test_class.


SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.
  SELECT-OPTIONS : so_car FOR ztspfli_a15-carrid OBLIGATORY
                          MEMORY ID car,
                   so_con FOR ztspfli_a15-connid
                          MEMORY ID con.
SELECTION-SCREEN END OF BLOCK b1.



SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME.
  SELECTION-SCREEN BEGIN OF LINE.
  SELECTION-SCREEN COMMENT 1(13) TEXT-001 FOR FIELD p_layout.
  PARAMETERS : p_layout TYPE disvariant-variant.
  SELECTION-SCREEN COMMENT pos_high(10) TEXT-002 FOR FIELD p_edit.
  PARAMETERS : p_edit AS CHECKBOX DEFAULT 'X'.
  SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK b2.

  INITIALIZATION.
  gs_variant-report = sy-cprog.

  START-OF-SELECTION.

PERFORM get_data.


CALL SCREEN 100.
