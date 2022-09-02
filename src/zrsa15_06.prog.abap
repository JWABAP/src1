*&---------------------------------------------------------------------*
*& Report ZRSA15_06
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa15_06.

PARAMETERS pa_i TYPE i.
"A, B, C, D만 입력 가능
PARAMETERS pa_class TYPE c LENGTH 1.
DATA gv_result LIKE pa_i.

*10보다 크면 출력
*20보다 크다면, 10추가로 더해서 출력하세요
*IF pa_i > 10.
*  WRITE pa_i.
*  ELSEIF pa_i > 20.
*    WRITE pa_i.
*ENDIF. 내가한건데 실패함

*10보다 크면 출력
*20보다 크다면, 10추가로 더해서 출력하세요
*A반이라면, 입력한값에 모두 100을 추가하세요.
*IF pa_i > 20.
*  gv_result = pa_i + 10.
*  WRITE gv_result.
*ELSEIF pa_i > 10.
*  gv_result = pa_i.
*  WRITE gv_result.
*ELSE.
*
*ENDIF.

*CASE pa_class.
*  WHEN 'A'.
*    gv_result = pa_i + 100.
*    WRITE gv_result.
*  WHEN OTHERS.

CASE pa_class.
  WHEN 'A'.
    gv_result = pa_i + 100.
    WRITE gv_result.
  WHEN OTHERS.
IF pa_i > 20.
  gv_result = pa_i + 10.
  WRITE gv_result.
ELSEIF pa_i > 10.
  gv_result = pa_i.
  WRITE gv_result.
ELSE.

ENDIF.
ENDCASE.



*CASE 변수.
*	WHEN 값.

*	WHEN 값.

*	WHEN OTHERS.

*ENDCASE.


*IF pa_i > 20.
*  CLEAR gv_result.
* gv_result = pa_i + 10.
* WRITE gv_result.
*ELSE.
*  IF pa_i > 10.
*   WRITE pa_i.
*  ENDIF.
*ENDIF.
