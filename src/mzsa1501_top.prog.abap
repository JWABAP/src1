*&---------------------------------------------------------------------*
*& Include MZSA1501_TOP                             - Module Pool      SAPMZSA1501
*&---------------------------------------------------------------------*
PROGRAM sapmzsa1501.

* Condition
DATA gv_pno TYPE ztsa0001-pernr.

* Employee Info
*DATA gs_info TYPE zssa1531.
TABLES zssa1531.             "TABLES뒤에는 일반적인 스트럭처타입이 올 수 있다.
*DATA zssa1531 TYPE zssa1531.
