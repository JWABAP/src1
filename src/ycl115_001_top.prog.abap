*&---------------------------------------------------------------------*
*& Include          YCL115_001_TOP
*&---------------------------------------------------------------------*

TABLES : SCARR.   "SCARR처럼생긴 구조체 변수를 선언하라는 의미다. = DATA SCARR TYPE SCARR.

DATA gt_scarr TYPE TABLE OF scarr.    "SCARR라는 테이블을 가지고 테이블형태로 선언이된다.(여러개의 필드를가지고있고
"줄단위로 데이터가 들어갈 수 있다는뜻

DATA gs_scarr TYPE scarr.             "정해져있는 크기가 있는 데이터들이 묶여있는 구조.

DATA ok_code TYPE sy-ucomm.
DATA save_ok TYPE sy-ucomm.         "OK코드를 기록,보관하기위해서 선언
