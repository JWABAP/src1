*&---------------------------------------------------------------------*
*& Report ZRSA15_24
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zrsa15_24_top                           .    " Global Data

* INCLUDE ZRSA15_24_O01                           .  " PBO-Modules
* INCLUDE ZRSA15_24_I01                           .  " PAI-Modules
INCLUDE zrsa15_24_f01                           .  " FORM-Routines

*Event
INITIALIZATION.  "런타임(프로그램 시작)시에 딱 한번만 실행됨.
  IF sy-uname = 'KD-A-15'.
    pa_car = 'AA'.
    pa_con = '0017'.
  ENDIF.                        "디폴트 값 설정하는것, KD-A-15로 들어가면 AA,0017이 알아서 입력이되있음.

AT SELECTION-SCREEN OUTPUT.   "PBO(Process Before Output)

AT SELECTION-SCREEN.   "PAI(Process After Input)
  IF pa_con IS INITIAL.
    "보통 E/W를 사용함
    MESSAGE w016(pn) WITH 'Check'.
*    STOP
  ENDIF.

START-OF-SELECTION.
"Get into List
PERFORM get_info.
WRITE 'Test'.
IF gt_info IS INITIAL.
  "S, I, W, E, A, X 6개의 타입이 있다. i는 엔터를 누르기전까지 프로그램이 멈춘다.s는 멈추지않고 아래로 진행됨,여기선 보통 s나I를 사용함.
  MESSAGE i016(pn) WITH'Data is not found'.   "i016(pn)= 메시지 클래스(더블클릭하면 나옴)
  RETURN.          "빠저나간다.
ENDIF.
cl_demo_output=>display_data( gt_info ).
*If gt_info IS NOT INITIAL.
* cl_demo_output=>display_data( gt_info ).
*else.
