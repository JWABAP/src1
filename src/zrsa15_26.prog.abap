*&---------------------------------------------------------------------*
*& Report ZRSA15_26
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zrsa15_26_top                           .    " Global Data

* INCLUDE ZRSA15_26_O01                           .  " PBO-Modules
* INCLUDE ZRSA15_26_I01                           .  " PAI-Modules
 INCLUDE zrsa15_26_f01                           .  " FORM-Routines

START-OF-SELECTION.
 SELECT *
   FROM sflight
   INTO CORRESPONDING FIELDS OF TABLE gt_info
   WHERE carrid = pa_car
*    and connid IN so_con[].
   AND   connid BETWEEN pa_con1 and pa_con2.

   cl_demo_output=>display_data( gt_info ).
