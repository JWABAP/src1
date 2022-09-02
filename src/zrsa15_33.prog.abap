*&---------------------------------------------------------------------*
*& Report ZRSA15_33
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa15_33.

DATA gs_dep TYPE zssa1506.  "dep info
"Emp info
DATA: gt_emp TYPE TABLE OF zssa1505,  "Emp info
     gs_emp LIKE LINE OF gt_emp.

PARAMETERS pa_dep TYPE ztsa1503-depid.

START-OF-SELECTION.
SELECT SINGLE *
  FROM ztsa1503  "dep table
  INTO CORRESPONDING FIELDS OF gs_dep
  WHERE depid = pa_dep.

  cl_demo_output=>display_data( gs_dep ).

  SELECT *
    FROM ztsa1501
    INTO CORRESPONDING FIELDS OF TABLE gt_emp
    WHERE depid = gs_dep-depid.
  cl_demo_output=>display_data( gt_emp ).
