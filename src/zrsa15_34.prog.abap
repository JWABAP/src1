*&---------------------------------------------------------------------*
*& Report ZRSA15_34
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa15_34.

" Dep Info
DATA gs_dep TYPE zssa1511.
DATA gt_dep LIKE TABLE OF gs_dep.

" Emp info ( structure Variable )
DATA gs_emp LIKE LINE OF gs_dep-emp_list.    "gs_dep는 스트럭처변수 gs_dep-emp_list는 인터널테이블

PARAMETERS pa_dep TYPE ztsa1503-depid.

START-OF-SELECTION.
SELECT SINGLE *
  FROM ztsa1503    "Dep Table
  INTO CORRESPONDING FIELDS OF gs_dep
  WHERE depid = pa_dep.

  IF sy-subrc <> 0.
    RETURN.
  ENDIF.

  "Get Employee List
  SELECT *
    FROM ztsa1501   "Employee table
    INTO CORRESPONDING FIELDS OF TABLE gs_dep-emp_list
    WHERE depid = gs_dep-depid.

LOOP AT gs_dep-emp_list INTO gs_emp.
    "Get Gender Text

    MODIFY gs_dep-emp_list FROM gs_emp.
    CLEAR gs_emp.
ENDLOOP.
