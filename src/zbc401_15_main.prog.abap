*&---------------------------------------------------------------------*
*& Report ZBC401_15_MAIN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc401_15_main.

*-------------클래스 생성하기-------------*
TYPE-POOLS: icon.                        "타입으로 정의된 것들중에는 icon,symbol등등이 있다.
"Type Group에서 icon으로 미리 선언해서 어디에서든지 사용할 수 있다.사용하는 문법은 TYPE-POOLS
"상수같이 어디에서 사용하든지 항상 같은값(예를들어 파이(3.14))인 경우에 주로 사용한다.(이 경우엔 아이콘)

CLASS lcl_airplane DEFINITION.

PUBLIC SECTION.

METHODS:
    constructor
      IMPORTING iv_name       TYPE string
                iv_planetype  TYPE saplane-planetype
      EXCEPTIONS
                wrong_planetype.
*--

METHODS: set_attributes               "메소드
    IMPORTING iv_name      TYPE string
              iv_planetype TYPE saplane-planetype,
  display_attributes.
CLASS-METHODS: display_n_o_airplanes.       "스태틱메소드
CLASS-METHODS: get_n_o_airplanes
                        RETURNING VALUE(rv_count) TYPE i.  "rv_count로 값이 returning된다.

CLASS-METHODS : class_constructor.     "(이 클래스는 스태틱이다.)클래스를 선언하면 IMPLEMENTATION에 어떠한 로직을 수행한다는 내용이 있어야한다.


PRIVATE SECTION.
  CONSTANTS: c_pos_1  TYPE i VALUE 30.    "c_pos = 출력하는 위치
  DATA: mv_name       TYPE string,
        mv_planetype  TYPE saplane-planetype,
        mv_weight     TYPE saplane-weight,
        mv_tankcap    TYPE saplane-tankcap.

  TYPES: ty_planetype TYPE TABLE OF saplane.      "ty_planetype정의

  CLASS-DATA: gv_n_o_airplanes TYPE i.   "스태틱
  CLASS-DATA: gv_planetypes    TYPE ty_planetype.  "class_constructor라고하는 스태틱클래스에 이용된다.

  CLASS-METHODS : get_technical_attributes
                    IMPORTING
                        iv_type    TYPE saplane-planetype  "체크하는로직
                    EXPORTING
                        ev_weight  TYPE saplane-weight  "결과가있으면 ev_weight에 넣기
                        ev_tankcap TYPE saplane-tankcap
                    EXCEPTIONS
                      wrong_planetype.
ENDCLASS.

CLASS lcl_airplane IMPLEMENTATION.


   METHOD get_technical_attributes.

     DATA: ls_planetype TYPE saplane.

     READ TABLE gv_planetypes INTO ls_planetype
                  WITH KEY planetype = iv_type.

     IF sy-subrc EQ 0.

       ev_weight = ls_planetype-weight.
       ev_tankcap = ls_planetype-tankcap.
     ELSE.
       RAISE wrong_planetype.
     ENDIF.
   ENDMETHOD.

  "데이터를 한꺼번에 넣어서 할 수 있는 방법이 있다(항상 이렇게하는건 아님)
  "DB를 왔다갔다하면서 읽는것보다는 한꺼번에 읽는게 낫겠다 판단이 될 경우 다음로직처럼 한번에 읽는다.
  METHOD class_constructor.
    SELECT *
      INTO TABLE gv_planetypes
      FROM saplane.
  ENDMETHOD.

  METHOD constructor.
    DATA: ls_planetype TYPE saplane.      "체크하기위한 임시변수

    mv_name      = iv_name.
    mv_planetype = iv_planetype.


*    SELECT SINGLE *
*      FROM saplane
*      INTO ls_planetype
*     WHERE planetype = iv_planetype.
*
*    IF sy-subrc <> 0.                  "0이 아니면
*      RAISE wrong_planetype.
*      write : / 'wrong type'.
*    ELSE.
*      mv_weight  = ls_planetype-weight.
*      mv_tankcap = ls_planetype-tankcap.
*      gv_n_o_airplanes = gv_n_o_airplanes + 1.
*    ENDIF.

    "다른데서도 재사용이 가능하게 구조화를 시킨것(클래스의목적은 구조화)
    CALL METHOD get_technical_attributes
      EXPORTING
        iv_type         = iv_planetype
      IMPORTING
        ev_weight       = mv_weight
        ev_tankcap      = mv_tankcap
      EXCEPTIONS
        wrong_planetype = 1.

    IF sy-subrc EQ 0.
      gv_n_o_airplanes = gv_n_o_airplanes + 1.
    ELSE.

      RAISE wrong_planetype.
    ENDIF.
*    ENDIF.


  ENDMETHOD.               "constructor


  METHOD get_n_o_airplanes.
    rv_count = gv_n_o_airplanes.
  ENDMETHOD.


  METHOD set_attributes.
    mv_name = iv_name.
    mv_planetype = iv_planetype.

    gv_n_o_airplanes = gv_n_o_airplanes + 1.   "최종적으로 gv_n_o_airplanes가 return이 된다.
  ENDMETHOD.

  METHOD display_attributes.        "display_attributes = set Attributes에서 받은 것들을 출력
    WRITE: / icon_ws_plane AS ICON,
    / 'Name of Airplane' , AT c_pos_1 mv_name,
    / 'Type of Airplane:', AT c_pos_1 mv_planetype,
    / 'Weight/Tank capacity'           , AT c_pos_1 mv_weight, mv_tankcap.

  ENDMETHOD.

  METHOD display_n_o_airplanes.
    SKIP.
    WRITE: / 'Number of airplanes:',
    AT c_pos_1 gv_n_o_airplanes.

  ENDMETHOD.

ENDCLASS.
*-------------클래스 생성하기 끝-------------*

DATA: go_airplane  TYPE REF TO lcl_airplane.
DATA: gt_airplanes TYPE TABLE OF REF TO lcl_airplane.   "객체를만들땐 테이블에도 ref to가 붙는다.

START-OF-SELECTION.

  CALL METHOD lcl_airplane=>display_n_o_airplanes.
*  lcl_airplane=>display_n_o_airplanes( ).           "CALL METHOD 생략형

  CREATE OBJECT go_airplane
          EXPORTING  iv_name = 'LH Berlin'
                     iv_planetype = 'A321'
          EXCEPTIONS wrong_planetype = 1.

   IF sy-subrc EQ 0.

*  CALL METHOD go_airplane->set_attributes
*                             EXPORTING iv_name = 'LH Berlin'
*                                       iv_planetype = 'A321'.
  APPEND go_airplane TO gt_airplanes.

  ENDIF.

CREATE OBJECT go_airplane
          EXPORTING  iv_name = 'AA New York'
                     iv_planetype = '747-400'
          EXCEPTIONS wrong_planetype = 1.

  IF sy-subrc EQ 0.
      APPEND go_airplane TO gt_airplanes.
    ENDIF.

*  CALL METHOD go_airplane->set_attributes
*                             EXPORTING iv_name = 'AA New York'
*                                       iv_planetype = '747-400'.

  CREATE OBJECT go_airplane
          EXPORTING  iv_name = 'US Herculs'
                     iv_planetype = '747-200F'
          EXCEPTIONS wrong_planetype = 1.

  IF sy-subrc EQ 0.
      APPEND go_airplane TO gt_airplanes.
  ENDIF.
* CALL METHOD go_airplane->set_attributes
*                             EXPORTING iv_name = 'US Herculs'
*                                       iv_planetype = '747-200F'.

 LOOP AT gt_airplanes INTO go_airplane.

  CALL METHOD go_airplane->display_attributes.   "각각 비행기가 가지고있는값들을 보여주기.(쌓여있는 3대의 기종과 이름)
 ENDLOOP.

 DATA: gv_count TYPE i.

 gv_count = lcl_airplane=>get_n_o_airplanes( ).   "스태틱 메소드, =>로 자기자신을직접. ()안에 띄워야한다.안띄우면 오류남
 WRITE : / 'Number of airplane', gv_count.          "최종 비행기 대수
