*&---------------------------------------------------------------------*
*& Report ZRSA15_12
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa15_12.

DATA gv_carrname TYPE scarr-carrname.
PARAMETERS pa_carr TYPE scarr-carrid.

"Get Airline Name
PERFORM get_airline_name USING pa_carr
                         CHANGING gv_carrname.

"Display Airline Name
  WRITE gv_carrname.
*&---------------------------------------------------------------------*
*& Form get_airline_name
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_airline_name USING value(p_code)  "p_code = pa_carr    ,value가 엄청중요하다(value를빼고 p_code를 다르게 설정하면 출력이 안됨)
                      CHANGING p_carrname.
  p_code = 'UA'.
  SELECT SINGLE carrname
  FROM scarr
  INTO p_carrname              "p_carrname = gv_carrname
 WHERE carrid = p_code.
    WRITE 'TEST gv_carrname:'.
    WRITE gv_carrname.
ENDFORM.
