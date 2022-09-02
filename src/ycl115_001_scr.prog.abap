*&---------------------------------------------------------------------*
*& Include          YCL115_001_SCR
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK B01 WITH FRAME
                                    TITLE TEXTT01. "원하는변수명을적고 INITIALIZATION에서 TITLE이름을 주어도된다.

*PARAMETERS:   "단일값을 딱 하나만 해서 그 값이 맞냐 아니냐를 따짐
SELECT-OPTIONS S_CARRID FOR GS_SCARR-CARRID.    "SELECT-OPTIONS : 최대 8자리까지만 지정가능
"FOR : 오른쪽에나오는 변수를 참조해서 만들어라("변수"이므로 이미 선언한 변수만 사용이 가능하다)
SELECT-OPTIONS S_CARRNM FOR SCARR-CARRNAME.    "SCARR이라는 구조체를 선언해줘야 사용가능하다.

SELECTION-SCREEN END OF BLOCK B01.
