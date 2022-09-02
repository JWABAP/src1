*&---------------------------------------------------------------------*
*& Report ZRSA15_32
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa15_32.

"Std Info
DATA gs_emp TYPE zssa1510.
*data gs_emp type zssa1505.
*data gs_dep type zssa1506.

PARAMETERS pa_pernr LIKE gs_emp-pernr.

INITIALIZATION.
  pa_pernr = '22020001'.

START-OF-SELECTION.
SELECT SINGLE *
  FROM ztsa1501  "Employee Table
  INTO CORRESPONDING FIELDS OF gs_emp
  WHERE pernr = pa_pernr.

IF sy-subrc <> 0.
  MESSAGE i001(zmcsa15).
  RETURN.
ENDIF.
*IF gs_emp IS NOT INITIAL.
*MESSAGE i016(pn) WITH'Data is not found'.
*RETURN.
*ENDIF.
*내가한거

*WRITE gs_emp-depid.      "일반변수
*NEW-LINE.
*WRITE gs_emp-dep-depid.        "스트럭처 변수
SELECT single *
  from ztsa1503 "Dep Table
  into gs_emp-dep
  where depid = gs_emp-depid.
  cl_demo_output=>display_data( gs_emp ).
