*&---------------------------------------------------------------------*
*& Report ZRSA15_22
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa15_22.

DATA: gs_list TYPE scarr,
      gt_list LIKE TABLE OF gs_list.

CLEAR: gt_list, gs_list.
*SELECT *
*  FROM scarr
*  INTO CORRESPONDING FIELDS OF gs_list
*WHERE carrid BETWEEN 'ZZ' AND 'UA'.
*  APPEND gs_list TO gt_list.
*  CLEAR gs_list.
*ENDSELECT.             "select도 일종의 반복문이다.

SELECT *
  FROM scarr
  INTO CORRESPONDING FIELDS OF TABLE gt_list
  WHERE carrid BETWEEN 'AA' AND 'UA'.      "AA에서 UA까지(문자도 순서열이 있다.)(가나다라,abcd처럼 순서가있다), 조건에는 pk를 걸어주는게 좋다.
WRITE sy-subrc.        "
WRITE sy-dbcnt.        "00건이 있다


cl_demo_output=>display_data( gt_list ).
