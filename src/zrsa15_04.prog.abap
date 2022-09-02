*&---------------------------------------------------------------------*
*& Report ZRSA15_04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa15_04.

*PARAMETERS pa_num TYPE i.
*DATA gv_result TYPE i.
*MOVE pa_num TO gv_result.
*ADD 1 TO gv_result.
*
*WRITE 'your input:'.
*WRITE pa_num.
*NEW-LINE.
*
*WRITE 'Result: '.
*WRITE gv_result.

PARAMETERS pa_num TYPE i.
DATA gv_result TYPE i.

MOVE pa_num
TO gv_result.

ADD 1 TO gv_result.

WRITE: 'Your input:',
        pa_num.

NEW-LINE.

WRITE: 'Result: ',gv_result.
