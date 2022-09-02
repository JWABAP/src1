*&---------------------------------------------------------------------*
*& Report ZBC400_SA15_COMPURE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc400_sa15_compure.

PARAMETERS: pa_cal,
            pa_num1 TYPE i,
            pa_num2 LIKE pa_num1.
DATA gv_result TYPE p LENGTH 16 DECIMALS 2.       "DECIMALS은 소수(소수 2자리까지 쓰라는뜻이다.)

***IF pa_cal = '+'.
***  gv_result = pa_num1 + pa_num2.
***  write gv_result.
***
***  ELSEIF pa_cal = '-'.
***  gv_result = pa_num1 - pa_num2.
***  write gv_result.
***
***  ELSEIF pa_cal = '*'.
***  gv_result = pa_num1 * pa_num2.
***  write gv_result.
***
***  ELSEIF pa_cal = '/'.
***  gv_result = pa_num1 / pa_num2.
***  write gv_result.
***
***  else.
***    write '잘못 입력하셨습니다.'.
***ENDIF.

CASE pa_cal.
  WHEN '+'.
    gv_result = pa_num1 + pa_num2.
    WRITE gv_result.
  WHEN '-'.
    gv_result = pa_num1 - pa_num2.
    WRITE gv_result.
  WHEN '*'.
    gv_result = pa_num1 * pa_num2.
    WRITE gv_result.
  WHEN '/'.
    gv_result = pa_num1 / pa_num2.
    WRITE gv_result.
  WHEN OTHERS.
    write '잘못된 기호를 입력하셨습니다.'.
ENDCASE.
*write '계산결과:'.
*WRITE gv_result.
*
*clear pa_num1.
*clear pa_num2.
*clear gv_result.

"성공!
