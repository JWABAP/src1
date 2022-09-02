*&---------------------------------------------------------------------*
*& Include MZSA1508_TOP                             - Module Pool      SAPMZSA1508
*&---------------------------------------------------------------------*
PROGRAM sapmzsa1508.

DATA ok_code TYPE sy-ucomm.     "ok_code 쓰는습관 가지기(sy-ucomm)
DATA gv_subrc TYPE sy-subrc.   "0 / 0

"Condition
TABLES zssa1580.   "Use Screen용도
*DATA gs_cond TYPE zssa1580.    "Use ABAP 용도

"Airline Info
TABLES zssa1581.
*DATA gs_airline TYPE zssa1581.

"Connection Info
TABLES zssa1582.
*DATA gs_conn type zssa1582.
