*&---------------------------------------------------------------------*
*& Include ZRSA15_31_TOP                            - Report ZRSA15_31
*&---------------------------------------------------------------------*
REPORT ZRSA15_31.

* Employee List
DATA: gs_emp type zssa1504,
      gt_emp like table of gs_emp.

* Selection Screen
PARAMETERS: pa_ent_b like gs_emp-entdt,
            pa_ent_e like gs_emp-entdt.
