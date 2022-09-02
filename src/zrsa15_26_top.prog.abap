*&---------------------------------------------------------------------*
*& Include ZRSA15_26_TOP                            - Report ZRSA15_26
*&---------------------------------------------------------------------*
REPORT zrsa15_26.

* Type 선언               "타입을 먼저 선언하는 습관이 좋다.

TYPES: BEGIN OF ts_info,
        carrid TYPE sflight-carrid,       "필드명은 테이블 이름과 통일해주는게좋다.
        connid TYPE sflight-connid,
        cityfrom type spfli-cityfrom,
        cityto type spfli-cityto,
        fldate TYPE sflight-fldate,
       END OF ts_info,
       tt_info TYPE TABLE OF ts_info.   "Table Type

* Data Object
DATA: gt_info TYPE TABLE OF ZSSA1503,
      gs_info LIKE LINE OF gt_info.

* Selection Screen
PARAMETERS: pa_car  TYPE sflight-carrid,
            pa_con1 TYPE sflight-connid,
            pa_con2 TYPE sflight-connid.
*select-options so_con for gs_info-connid.   "Variable    so_con = 변수(인터널 테이블이다)
