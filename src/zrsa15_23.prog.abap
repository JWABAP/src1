*&---------------------------------------------------------------------*
*& Report ZRSA15_23
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa15_23.

*DATA: gs_info TYPE scarr,
*      gt_info LIKE TABLE OF gs_info.
*
*PARAMETERS:pa_air1 TYPE c LENGTH 2,
*           pa_air2 LIKE pa_air1.
*
*SELECT carrid carrname connid cityfrom cityto
*  FROM spfli
*  INTO CORRESPONDING FIELDS OF TABLE gt_info
*WHERE carrid BETWEEN pa_air1 AND pa_air2.
*
*cl_demo_output=>display_data( gt_info ).
*내가한거 (실패)
