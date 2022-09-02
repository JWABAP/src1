*&---------------------------------------------------------------------*
*& Report ZRCA15_02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
*REPORT zrca15_02.
*DATA gv_step TYPE i.
*DATA gv_cal TYPE i.
*DATA gv_lev TYPE i.
*
*DO 9 TIMES.
*  gv_lev = gv_lev + 1.
*  CLEAR gv_Step.
*  DO 9 TIMES.
*  gv_step = gv_step + 1.
*  CLEAR gv_cal.
*  gv_cal = gv_lev * gv_step.
*WRITE: gv_lev, ' * ', gv_step, ' = ', gv_cal.
*NEW-LINE.
*ENDDO.
*CLEAR gv_step.
*WRITE '==========================================================='.
*NEW-LINE.
*
REPORT zrca15_02.

DATA gv_step TYPE i.   "곱하는값(*3,*4,*5...)
DATA gv_cal TYPE i.    "계산결과
DATA gv_lev TYPE i.    "구구단 단계(1단,2단...)
PARAMETERS pa_req LIKE gv_lev.   "구구단 단 수
PARAMETERS pa_syear(1) TYPE c.   "학년
DATA gv_new_lev LIKE gv_lev.

CASE pa_syear.                   "0학년인 경우
  WHEN '1'.                      "1학년인 경우에
    IF pa_req >= 3.              "만약 pa_req입력값이 3보다 크거나 같으면
    gv_new_lev = 3.
    ELSE.
      gv_new_lev = pa_req.
      ENDIF.
  WHEN '2'.
IF pa_req >= 5.
  gv_new_lev = 5.
  ELSE.
    gv_new_lev = pa_req.
     ENDIF.
  WHEN '3'.
    IF pa_req >= 7.
  gv_new_lev = 7.
  ELSE.
    gv_new_lev = pa_req.
    ENDIF.
  WHEN '4'.                          "4학년일때.
    IF pa_req >= 9.                  "
  gv_new_lev = 9.
  ELSE.
    gv_new_lev = pa_req.
    ENDIF.
    WHEN '6'.                        "만약 6학년이면
      gv_new_lev = 9.                "어떤수를 넣어도 9단이나오게
  WHEN OTHERS.


ENDCASE.

DO gv_new_lev TIMES.
  gv_lev = gv_lev + 1.
  CLEAR gv_step.
  DO 9 TIMES.
  gv_step = gv_step + 1.
  CLEAR gv_cal.
  gv_cal = gv_lev * gv_step.
WRITE: gv_lev, ' * ', gv_step, ' = ', gv_cal.
NEW-LINE.
ENDDO.
CLEAR gv_step.
WRITE '=============================================================='.
NEW-LINE.
ENDDO.
