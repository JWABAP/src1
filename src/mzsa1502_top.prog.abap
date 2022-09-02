*&---------------------------------------------------------------------*
*& Include MZSA1502_TOP                             - Module Pool      SAPMZSA1502
*&---------------------------------------------------------------------*
PROGRAM sapmzsa1502.

*DATA: BEGIN OF gs_cond,
*        carrid TYPE sflight-carrid,
*        connid TYPE sflight-connid,
*END OF gs_cond.

"Condition
"Use Cond
TABLES zssa1560.

DATA gs_cond TYPE zssa1560.
DATA ok_code LIKE sy-ucomm.
