*&---------------------------------------------------------------------*
*& Include ZRSA15_24_TOP                            - Report ZRSA15_24
*&---------------------------------------------------------------------*
REPORT zrsa15_24.

" Sch Date Info
DATA: gt_info TYPE TABLE OF zsinfo00,
      gs_info LIKE LINE OF gt_info.

PARAMETERS: pa_car like sbook-carrid,
            pa_con like sbook-connid.
