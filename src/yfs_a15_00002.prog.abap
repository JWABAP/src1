*&---------------------------------------------------------------------*
*& Report YTEST0001_1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT YFS_A15_00002.

data :begin of line,
    col1(12) value 'ABCDEFGHIJKL'.
DATA : end of line.

FIELD-SYMBOLS : <FS>.

assign line-col1+6(*) to <fs>.     "field symbol 이 길이가 넘어가는 것을 방지해줌.
write : / <fs>.


assign line-col1+6(6) to <fs>.
write : / <fs>.


assign line-col1+5(6) to <fs>.
write : / <fs>.

assign line-col1+5(5) to <fs>.
write : / <fs>.


*assign line-col1+5  to <fs>.
*write : / <fs>.



*assign line-col1+5(10) to <fs>.   "error 길이가 over 늘어남.
write : / <fs>.
