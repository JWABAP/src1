*&---------------------------------------------------------------------*
*& Include ZC1R150005_TOP                           - Report ZC1R150005
*&---------------------------------------------------------------------*
REPORT zc1r150005 MESSAGE-ID zmcsa15.

CLASS lcl_event_handler DEFINITION DEFERRED.
TABLES: mast.  "Select-Options를 위해서

DATA : BEGIN OF gs_data,      "헤더있는걸 쓰려면 occures 0
         matnr TYPE mast-matnr,
         stlan TYPE mast-stlan,
         stlnr TYPE mast-stlnr,
         stlal TYPE mast-stlal,
         mtart TYPE mara-mtart,
         matkl TYPE mara-matkl,
         maktx TYPE makt-maktx,
       END OF gs_data,

       gt_data   LIKE TABLE OF gs_data,

       gcl_maktx TYPE REF TO zclc115_0002.

"ALV관련 선언
DATA : gcl_container TYPE REF TO cl_gui_docking_container,
       gcl_grid      TYPE REF TO cl_gui_alv_grid,
       gcl_handler   TYPE REF TO lcl_event_handler,              "클래스
       gs_fcat       TYPE lvc_s_fcat,
       gt_fcat       TYPE lvc_t_fcat,
       gs_layout     TYPE lvc_s_layo,
       gs_variant    TYPE disvariant.

DATA : gv_okcode TYPE sy-ucomm.



"매크로
DEFINE _clear.

  CLEAR   &1.     "인터널테이블
  REFRESH &1.

END-OF-DEFINITION.
