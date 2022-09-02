*&---------------------------------------------------------------------*
*& Include SAPMZC1150001_TOP                        - Module Pool      SAPMZC1150001
*&---------------------------------------------------------------------*
PROGRAM sapmzc1150001 MESSAGE-ID zmcsa15.            "모듈풀은 PROGRAM으로 시작한다.

"화면에있는입력필드는 특정변수와 1:1매핑이된다. (스트럭쳐 구조로 관리하자)

DATA: BEGIN OF gs_data,
        matnr TYPE ztc1150001-matnr,  "Material
        werks TYPE ztc1150001-werks,  "Plant
        mtart TYPE ztc1150001-mtart,  "Mat.Type
        matkl TYPE ztc1150001-matkl,  "Mat.Group
        menge TYPE ztc1150001-menge,  "Quantity
        meins TYPE ztc1150001-meins,  "Unit
        dmbtr TYPE ztc1150001-dmbtr,  "Price
        waers TYPE ztc1150001-waers,  "Currency
      END OF gs_data,

      gt_data like table of gs_data,

      gv_okcode TYPE sy-ucomm.

*ALV 관련
DATA: gcl_container TYPE REF TO cl_gui_custom_container,
      gcl_grid      TYPE REF TO cl_gui_alv_grid,
      gs_fcat       TYPE lvc_s_fcat,
      gt_fcat       TYPE lvc_t_fcat,
      gs_layout     TYPE lvc_s_layo,
      gs_variant    TYPE disvariant.
