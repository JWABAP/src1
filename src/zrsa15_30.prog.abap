*&---------------------------------------------------------------------*
*& Report ZRSA15_30
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa15_30.

*data gv_name type zdname_a15.     "타입다음에는 도메인을 사용 할 수 없다.

*PARAMETERS pa_name type zename_a15.      "데이터 엘리멘트는 사용 가능

TYPES: BEGIN OF ts_info,
         stdno TYPE n LENGTH 8,
         sname TYPE c LENGTH 40,
       END OF ts_info.                   "로컬타입

"Std Info
DATA gs_std TYPE zssa1501.                "글로벌타입

gs_std-stdno = '20220001'.
gs_std-sname = 'Kang SK'.
