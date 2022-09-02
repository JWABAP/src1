*&---------------------------------------------------------------------*
*& Include ZC1R150010_TOP                           - Report ZC1R150010
*&---------------------------------------------------------------------*
REPORT zc1r150010 MESSAGE-ID zmcsa15.

CLASS lcl_event_handler DEFINITION DEFERRED.

TABLES: ztsa1501.

DATA: BEGIN OF gs_data,
        mark,
        pernr    TYPE ztsa1501-pernr,
        ename    TYPE ztsa1501-ename,
        entdt    TYPE ztsa1501-entdt,
        gender   TYPE ztsa1501-gender,
        depid    TYPE ztsa1501-depid,
        carrid   TYPE ztsa1501-carrid,
        carrname TYPE scarr-carrname,
        style    TYPE lvc_t_styl,         "테이블타입은 타입만으로도 인터널테이블이 생성된다.
      END OF gs_data,
      gt_data     LIKE TABLE OF gs_data,
      gt_data_del LIKE TABLE OF gs_data.

"ALV관련 선언
DATA : gcl_container TYPE REF TO cl_gui_docking_container,
       gcl_grid      TYPE REF TO cl_gui_alv_grid,
       gcl_handler   TYPE REF TO lcl_event_handler,              "클래스
       gs_fcat       TYPE lvc_s_fcat,
       gt_fcat       TYPE lvc_t_fcat,
       gs_layout     TYPE lvc_s_layo,
       gs_variant    TYPE disvariant,
       gs_stable     TYPE lvc_s_stbl.      "CREATE ROW관련

DATA: gt_rows TYPE lvc_t_row,  "사용자가 선택한 행의 정보를 저장할 ITAB
      gs_row  TYPE lvc_s_row.

DATA : gv_okcode TYPE sy-ucomm.

DEFINE _clear.
  CLEAR &1.
  REFRESH &2.
END-OF-DEFINITION.
