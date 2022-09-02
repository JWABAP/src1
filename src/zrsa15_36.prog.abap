*&---------------------------------------------------------------------*
*& Report ZRSA15_36
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa15_36.

TYPES: BEGIN OF ts_dep,
        budget TYPE ztsa1503-budget,
        waers  TYPE ztsa1503-waers,
       END OF ts_dep.               "TYPES 로주면 레퍼런스필드 레퍼런스테이블을 설정해줄 수 없다.

DATA: gs_dep TYPE zssa1520, "ts_dep, "ztsa1503,    "DB Table
      gt_dep LIKE TABLE OF gs_dep.

DATA go_salv TYPE REF TO cl_salv_table.


START-OF-SELECTION.
SELECT *
  FROM ztsa1503
  INTO CORRESPONDING FIELDS OF TABLE gt_dep.

cl_salv_table=>factory(
  IMPORTING R_salv_table = go_salv
  CHANGING t_table = gt_dep
).
go_salv->display( ).

*cl_demo_output=>display_data( gt_dep ).
"테이블에 있는걸 그래도 보여준다.(100.1)
