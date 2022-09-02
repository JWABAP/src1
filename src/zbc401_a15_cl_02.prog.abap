*&---------------------------------------------------------------------*
*& Report ZBC401_A15_CL_02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc401_a15_cl_02.

"오픈형, 다 접근이 가능하다.
INTERFACE intf.

  DATA : ch1 TYPE i,
         ch2 TYPE i.

  METHODS : met1.      "선언만 interface안에.. 구현은 class implementaion안에.       각각의 클래스 안에  met1이 정의된다.
ENDINTERFACE.

CLASS cl1 DEFINITION.
  PUBLIC SECTION.
    INTERFACES intf.     "항상 public 에 선언.      cl1,2에 둘다 선언이 되어있다.

ENDCLASS.

CLASS cl1 IMPLEMENTATION.

  METHOD intf~met1.         "intf에 소속되있는 met1 메소드다 라는뜻

    DATA : rel TYPE i.
    rel = intf~ch1 + intf~ch2.  "intf의 ch1 + intf의 ch2

    WRITE : / 'reuslt + :', rel LEFT-JUSTIFIED.      "LEFT-JUSTIFIED = 왼쪽으로 정렬
  ENDMETHOD.
ENDCLASS.

CLASS cl2 DEFINITION.
  PUBLIC SECTION.
    INTERFACES intf.     "항상 public 에 선언.    cl1,2에 둘다 선언이 되어있다.

    ALIASES multi_intf
        FOR intf~met1.

    ALIASES int_char1 FOR intf~ch1.  "일반변수처럼 이름을 다르게(ALIASES)
    ALIASES int_char2 FOR intf~ch2.  "일반변수처럼 이름을 다르게
ENDCLASS.



CLASS cl2 IMPLEMENTATION.

  METHOD intf~met1.               "cl2에서도 intf met1을 부르고있다.

    DATA : rel TYPE i.
*    rel = intf~ch1 * intf~ch2.
    rel = int_char1 * int_char2.

    WRITE : / 'reuslt * :', rel LEFT-JUSTIFIED.      "LEFT-JUSTIFIED = 왼쪽으로 정렬
  ENDMETHOD.
ENDCLASS.


* 밑의 로직이 없으면 실행이 안됨.
START-OF-SELECTION.

  DATA : clobj TYPE REF TO cl1.

  CREATE OBJECT clobj.


  clobj->intf~ch1 = 10.
  clobj->intf~ch2 = 20.

  CALL METHOD clobj->intf~met1.


  DATA : clobj1 TYPE REF TO cl2.

  CREATE OBJECT clobj1.


  clobj1->intf~ch1 = 10.
  clobj1->intf~ch2 = 20.

  CALL METHOD clobj1->intf~met1.
