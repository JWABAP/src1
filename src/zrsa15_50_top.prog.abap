*&---------------------------------------------------------------------*
*& Include ZRSA15_50_TOP                            - Report ZRSA15_50
*&---------------------------------------------------------------------*
REPORT zrsa15_50.

DATA: gs_info TYPE ztsa15pro,
      gt_info LIKE TABLE OF gs_info.

PARAMETERS pa_pro LIKE gs_info-pernr.
