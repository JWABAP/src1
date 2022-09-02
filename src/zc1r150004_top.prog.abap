*&---------------------------------------------------------------------*
*& Include ZC1R150004_TOP                           - Report ZC1R150004
*&---------------------------------------------------------------------*
REPORT zc1r150004.

TABLES: mast, makt, mara.

DATA: BEGIN OF gs_data,
        werks TYPE mast-werks,
        matnr TYPE mast-matnr,
        stlan TYPE mast-stlan,
        stlnr TYPE mast-stlnr,
        stlal TYPE mast-stlal,
        mtart TYPE mara-mtart,
        matkl TYPE mara-matkl,
      END OF gs_data,

      gt_data LIKE TABLE OF gs_data.

DATA : gcl_container TYPE REF TO cl_gui_docking_container,
       gcl_grid      TYPE REF TO cl_gui_alv_grid,
       gs_fcat       TYPE lvc_s_fcat,
       gt_fcat       TYPE lvc_t_fcat,
       gs_layout     TYPE lvc_s_layo,
       gs_variant    TYPE disvariant.

DATA : gv_okcode TYPE sy-ucomm.
