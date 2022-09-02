*&---------------------------------------------------------------------*
*& Report ZRSA15_15
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa15_15.

DATA: BEGIN OF gs_std,
        stdno  TYPE n LENGTH 8,            "stdno:학번,숫자로만 이루어저있지만 코드성이 있는경우(예를들어 학번)에는 보통 타입을n으로 한다.
        sname  TYPE c LENGTH 40,
        gender TYPE c LENGTH 1,
        gender_t TYPE c LENGTH 10,
      END OF gs_std.
DATA gt_std LIKE TABLE OF gs_std.              "gt:글로벌 테이블의 약자, 인터널테이블의 이니셜밸류는 아무것도 없는 형태이다.

gs_std-stdno = '20220001'.
gs_std-sname = 'KANG'.
gs_std-gender = 'M' .
APPEND gs_std TO gt_std.            "append=추가

*CLEAR gs_std.
*gs_std-stdno = '20220002'.
*gs_std-sname = 'HAN'.
*gs_std-gender = 'F'.
*APPEND gs_std TO gt_std.            "append=추가
*
*LOOP AT gt_std INTO gs_std.
**  CASE ... or IF...
*  gs_std-gender_t = 'Male'(t01).
*  MODIFY gt_std FROM gs_std.
*  CLEAR gs_std.
*ENDLOOP.
*
**MODIFY gt_std FROM gs_std INDEX 2.
*cl_demo_output=>display_data( gt_std ). "cl_demo_output=클래스        display_data( gt_std )=스태틱
*
*CLEAR gs_std.
**READ TABLE gt_std INDEX 1 INTO gs_std.
*READ TABLE gt_std WITH KEY stdno = '20220001'
*INTO gs_std.
*WRITE gs_std.

*LOOP AT gt_std INTO gs_std.               "반복문
*  WRITE: sy-tabix, gs_std-stdno,
*         gs_std-sname, gs_std-gender.
*  NEW-LINE.
*  CLEAR gs_std.
*ENDLOOP.
*WRITE:/ sy-tabix, gs_std-stdno,
*        gs_std-sname, gs_std-gender.
