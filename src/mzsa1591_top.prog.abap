*&---------------------------------------------------------------------*
*& Include MZSA1590_TOP                             - Module Pool      SAPMZSA1590
*&---------------------------------------------------------------------*
PROGRAM sapmzsa1590.

DATA ok_code TYPE sy-ucomm.

*Condition
TABLES zssa1590.  "TABLES를 사용한이유는 실제스크린에 사용하기위해서 이 스트럭처에달려있는 정보를 적극적으로 활용하기위해서이다.

* Flight Info
TABLES zssa1591.

* Vendor Info
TABLES zssa1593.

* Tab Strip
CONTROLS ts_info TYPE TABSTRIP.
