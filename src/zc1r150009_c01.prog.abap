*&---------------------------------------------------------------------*
*& Include          ZC1R150005_C01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Class lcl_event_handler
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
"클래스의 속성
*Inheritance   : 상속성(클래스가 부모클래스로부터 상속받는것)(내가가지고있는것처럼 사용가능)
*Encapsulation : 캡슐화(하나만의 기능을가진것이아닌 많은 클래스,메소드를가질수있는것처럼 여러가지를 내포할 수 있다 라는뜻)
*Polymorphism  : 다형성(같은이름으로 여러가지가 존재할수있다)(하지만 return값이다르거나 받는 파라미터개수가 달라서 이걸로 구분가능하다)(오버라이딩과 관련이있다)
CLASS lcl_event_handler DEFINITION FINAL.  "FINAL = 나는 더이상 상속못한다라는뜻(내가마지막! 이라서 final)
  PUBLIC SECTION.    "우리가 퍼블릭말고 프로텍티드나 시크릿을 쓸 일은 별로없다.
    METHODS : "이건 인스턴스 메소드 (스태틱메소드: 인스턴스를 선언하지않고 해당클래스를 직접 선언할 수 있다.)
      handle_double_click FOR EVENT double_click OF cl_gui_alv_grid    "= cl_gui_alv_grid메소드의 더블클릭을 위한 메소드
        IMPORTING
          e_row           "PARAMETERS 눌러서 확인
          e_column,       "PARAMETERS 눌러서 확인

      handle_hotspot FOR EVENT hotspot_click OF cl_gui_alv_grid
        IMPORTING
          e_row_id
          e_column_id.

ENDCLASS.
"클래스의 속성에는 상속성
*&---------------------------------------------------------------------*
*& Class (Implementation) lcl_event_handler
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.

  METHOD handle_double_click.

    PERFORM handle_double_click USING e_row e_column.

  ENDMETHOD.

  METHOD handle_hotspot.

    PERFORM handle_hotspot USING e_row_id e_column_id.

  ENDMETHOD.
ENDCLASS.
