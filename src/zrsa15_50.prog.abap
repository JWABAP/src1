*&---------------------------------------------------------------------*
*& Report ZRSA15_50
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zrsa15_50_top                           .    " Global Data

* INCLUDE ZRSA15_50_O01                           .  " PBO-Modules
* INCLUDE ZRSA15_50_I01                           .  " PAI-Modules
 INCLUDE zrsa15_50_f01                           .  " FORM-Routines

 START-OF-SELECTION.
 SELECT *
   FROM ztsa15pro	INNER JOIN ztsa1501
   ON ztsa15pro~proid = ztsa1501~pernr
   INTO CORRESPONDING FIELDS OF TABLE gt_info.
*   WHERE ztsa15pro~proid = pa_pro.

   cl_demo_output=>display_data( gt_info ).
