*&---------------------------------------------------------------------*
*& Report ZRCA15_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrca15_01.

DATA gv_num TYPE i.
do 6 TIMES.   "반복문
gv_num = gv_num + 1.
WRITE sy-index.
IF gv_num > 3.
EXIT.
ENDIF.
WRITE gv_num.
NEW-LINE.
ENDDO.

*DATA gv_gender  TYPE c LENGTH 1. "M(MALE), F(FEMALE)
*
*gv_gender = 'X'.
*CASE gv_gender.
*	WHEN 'M'.
*
*  WHEN 'F'.
*	WHEN OTHERS.
*ENDCASE.
*IF gv_gender = 'M'.
*
*ELSEIF gv_gender = 'F'.
*
*ELSE.
*
*ENDIF.

*gv_gender = 'F'.
