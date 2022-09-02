*&---------------------------------------------------------------------*
*& Report ZBC401_T03_CL_03
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc401_a15_cl_03.

*---cl1_1 = 이벤트를 정의하고 핸들링하는 부분이다. ---*
CLASS cl_1 DEFINITION.
  PUBLIC SECTION.
    DATA: num1 TYPE i.
    METHODS: pro IMPORTING num2 TYPE i.
    EVENTS: cutoff.                      "이벤트 이름
ENDCLASS.

*---cl1_1 = 이벤트를 정의하고 핸들링하는 부분이다. ---*
CLASS cl_1 IMPLEMENTATION.
  METHOD pro.
    num1 = num2.
    IF num2 >= 2.                "2보다 클경우
      RAISE EVENT cutoff.        "RAISE EVENT = 이벤트를 발생시켜라 라고하는구문,cutoff = 이벤트 이름
    ENDIF.
  ENDMETHOD.
ENDCLASS.

*---CL_event = 그 이벤트가 하는일을 구현하는 부분?---*
CLASS CL_event DEFINITION.
  PUBLIC SECTION.
    METHODS: handling_CUTOFF FOR EVENT cutoff OF cl_1.           "이벤트 재정의
ENDCLASS.


CLASS CL_event IMPLEMENTATION.
  METHOD handling_CUTOFF.
    WRITE: 'Handling the CutOff'.
    WRITE: / 'Event has been processed'.
  ENDMETHOD.
ENDCLASS.



START-OF-SELECTION.
  DATA: main1 TYPE REF TO cl_1.
  DATA: eventh1 TYPE REF TO CL_event.

  CREATE OBJECT main1.
  CREATE OBJECT eventh1.

  SET HANDLER eventh1->handling_CUTOFF FOR main1.             "이벤트를 등록하고 사용하겠다?
  main1->pro( 4 ).
