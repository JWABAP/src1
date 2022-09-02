*&---------------------------------------------------------------------*
*& Report ZRSA15_14
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa15_14.

"Transparent Table = Structure Type
DATA gs_scarr TYPE scarr.

PARAMETERS pa_carr LIKE gs_scarr-carrid.            "like도가능하고 type도 가능

SELECT SINGLE carrid carrname currcode
  FROM scarr
  INTO CORRESPONDING FIELDS OF gs_scarr  "매칭되는 데이터만 가져온다는 뜻.
  WHERE carrid = pa_carr.

  WRITE: gs_scarr-carrid, gs_scarr-carrname, gs_scarr-currcode.

**TYPES: BEGIN OF ts_cat,
**        home TYPE c LENGTH 10,
**        name TYPE c LENGTH 10,
**        age TYPE i,
**        END OF ts_cat.
**
**DATA gs_cat TYPE ts_cat.
***DATA: gv_cat_name TYPE c LENGTH 10,
***      gv_cat_age TYPE i.
***
***DATA: BEGIN OF gs_cat,
***      name TYPE c LENGTH 10,
***      age TYPE i,
***      END OF gs_cat.
**
***WRITE gs_cat-age.
**CLEAR gs_cat
