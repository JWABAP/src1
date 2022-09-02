*&---------------------------------------------------------------------*
*& Include SAPMZC1260001_TOP                        - Module Pool      SAPMZC1260001
*&---------------------------------------------------------------------*
PROGRAM sapmzc1260001 MESSAGE-ID zc226.

DATA : BEGIN OF gs_data,
         matnr TYPE ztc1260001-matnr, "Material
         werks TYPE ztc1260001-werks, "Plant
         mtart TYPE ztc1260001-mtart, "Mat.Type
         matkl TYPE ztc1260001-matkl, "Mat.Group
         menge TYPE ztc1260001-menge, "Quantity
         meins TYPE ztc1260001-meins, "Unit
         dmbtr TYPE ztc1260001-dmbtr, "Price
         waers TYPE ztc1260001-waers, "Currency
       END OF gs_data,

       gt_data   LIKE TABLE OF gs_data,
       gv_okcode TYPE sy-ucomm.

* ALV 관련
DATA : gcl_container TYPE REF TO cl_gui_custom_container,
       gcl_grid      TYPE REF TO cl_gui_alv_grid,
       gs_fcat       TYPE lvc_s_fcat,
       gt_fcat       TYPE lvc_t_fcat,
       gs_layout     TYPE lvc_s_layo,
       gs_variant    TYPE disvariant.
