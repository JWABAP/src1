*&---------------------------------------------------------------------*
*& Include          MZSA1508_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form gt_airline_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_airline_info .
  CLEAR zssa1581.       "데이터를 조회하기전에 무슨값이 있을지모르니 깨끗하게 지우기
      SELECT SINGLE *
        FROM scarr
        INTO CORRESPONDING FIELDS OF zssa1581
        WHERE carrid = zssa1580-carrid.   "zssa1580-carrid.=사용자가 입력한 변수값
ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_conn_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ZSSA1580_CARRID
*&      --> ZSSA1580_CONNID
*&      <-- ZSSA1582
*&---------------------------------------------------------------------*
FORM  get_conn_info  USING   VALUE(p_carrid)
                             VALUE(p_connid)
                    CHANGING ps_info TYPE zssa1582
                             p_subrc.

"Search를 눌렀을때 Flight Number값이 입력되지않으면 메시지를출력하고 Airline Info에 값을 입력하지 않게하는 로직.
  CLEAR: p_subrc, zssa1581, ps_info.
  SELECT SINGLE *
    FROM spfli
    INTO CORRESPONDING FIELDS OF ps_info
   WHERE carrid = p_carrid
     AND connid = p_connid.
    IF sy-subrc <> 0.
      p_subrc = 4. "sy-subrc.  "4 = 에러코드.
      RETURN.
    ENDIF.

    "Get Airline Info
    PERFORM get_airline_info.

ENDFORM.
