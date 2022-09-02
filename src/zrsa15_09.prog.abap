*&---------------------------------------------------------------------*
*& Report ZRSA15_09
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZRSA15_09.

data gv_d type sy-datum.

gv_d = sy-datum - 365.

clear gv_d.

IF gv_d IS INITIAL.  " = '00000000'
  write 'No Date'.
  else.
  write 'Exist Date'.
ENDIF.

*DATA gv_cnt type i.
*DO 10 TIMES.
*  gv_cnt = gv_cnt + 1.
**  write sy-index
*
*do 5 times.
*  write sy-index.
*  enddo.
*  WRITE sy-index.
*  NEW-LINE.
*ENDDO.
