*&---------------------------------------------------------------------*
*& Report ZRSA15_08
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa15_08.

PARAMETERS pa_code type c LENGTH 4 DEFAULT 'SYNC'.   "기본값으로 SYNC 가지고있기
PARAMETERS pa_date TYPE sy-datum.  "8자리를 가지고있는 날짜타입(더블클릭해보기)
DATA gv_cond_d1 LIKE pa_date.

gv_cond_d1 = sy-datum + 7.  "일주일후의 값.

CASE pa_code.
  WHEN 'SYNC'.
    IF pa_date > gv_cond_d1.
  WRITE 'ABAP Dictionary'(t02).
ELSE.
  WRITE 'ABAP Workbench'(t01).
ENDIF.
  WHEN OTHERS.
    WRITE '다음 기회에'(t03).
*    exit. "RETURN   "EXIT 를 만나면 빠저나가라는 뜻(문장전체를 빠저나가라는뜻이다)
ENDCASE.
