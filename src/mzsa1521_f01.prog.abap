*&---------------------------------------------------------------------*
*& Include          MZSA0010_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_airline_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_airline_info USING VALUE(p_carrid)
                      CHANGING ps_info TYPE zssa0081.

  CLEAR ps_info.
  SELECT SINGLE *
    FROM scarr
    INTO CORRESPONDING FIELDS OF ps_info
   WHERE carrid = p_carrid.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_conn_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ZSSA0080_CARRID
*&      --> ZSSA0080_CONNID
*&      <-- ZSSA0082
*&---------------------------------------------------------------------*
FORM get_conn_info  USING    VALUE(p_carrid)
                             VALUE(p_connid)
                    CHANGING ps_airline TYPE zssa0081
                             ps_conn TYPE zssa0082
                             p_subrc.
  CLEAR: p_subrc, ps_airline, ps_conn.
  SELECT SINGLE *
    FROM spfli
    INTO CORRESPONDING FIELDS OF ps_conn
   WHERE carrid = p_carrid
     AND connid = p_connid.
  IF sy-subrc <> 0.
    p_subrc = 4. "sy-subrc.
    RETURN.
  ENDIF.

  "Get Airline Info
  PERFORM get_airline_info  USING p_carrid
                            CHANGING ps_airline.

ENDFORM.
