*&---------------------------------------------------------------------*
*& Include          MZSA1590_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_airline_name
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ZSSA1590_CARRID
*&      <-- ZSSA1590_CARRNAME
*&---------------------------------------------------------------------*
FORM get_airline_name  USING    VALUE(p_carrid)
                       CHANGING p_carrname.

  CLEAR p_carrname.   "성공하든 실패하든 올바른값이 아니면 지우는게좋다.
      SELECT SINGLE carrname
        FROM scarr
        INTO p_carrname
       WHERE carrid = p_carrid.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_meal_text
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ZSSA1590_CARRID
*&      --> ZSSA1590_MEALNUMBER
*&      --> SY_LANGU
*&      <-- ZSSA1590_MEALNUMBER_T
*&---------------------------------------------------------------------*
FORM get_meal_text  USING    VALUE(p_carrid)
                             VALUE(p_mealno)
                             VALUE(p_langu)
                    CHANGING VALUE(p_meal_t).

  CLEAR p_meal_t.
  SELECT SINGLE text
    FROM smealt
    INTO p_meal_t
   WHERE carrid = p_carrid
    AND mealnumber = p_mealno
    AND sprache = p_langu.   "sy-langu=로그인된 언어로


ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_meal_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_meal_info USING VALUE(p_carrid)
                         VALUE(p_mealno)
                   CHANGING ps_meal_info TYPE zssa1591.


  CLEAR zssa1591.
  "Meal Info
  SELECT SINGLE *
    FROM smeal
    INTO CORRESPONDING FIELDS OF ps_meal_info
   WHERE carrid = p_carrid
     AND mealnumber = p_mealno.

  "Airline Name
  PERFORM get_airline_name USING ps_meal_info-carrid  "meal_info안에 carrid가 있다.
                           CHANGING ps_meal_info-carrname.   "마찬가지로 carrname도 있다.
  "Meal Text
  PERFORM get_meal_text USING ps_meal_info-carrid
                              ps_meal_info-mealnumber
                              sy-langu
                        CHANGING ps_meal_info-mealnumber_t.

  "Get Price
  "Flag(V,M), Vendor ID, Airline Code, Meal Number
  DATA ls_vendor_info TYPE zssa1593.
  PERFORM get_vendor_info USING 'M'   "M = Meal Number
                                ps_meal_info-carrid
                                ps_meal_info-mealnumber
                          CHANGING ls_vendor_info.
  ps_meal_info-price = ls_vendor_info-price.
  ps_meal_info-waers = ls_vendor_info-waers.

*  SELECT SINGLE price waers
*    FROM ztsa1599    "Vendor테이블
*    INTO ( ps_meal_info-price, ps_meal_info-waers )  "()문장도 가능하다.
*   WHERE carrid = ps_meal_info-carrid
*     AND mealnumber = ps_meal_info-mealnumber.

"Meal Type Text
  PERFORM get_domain_text USING 'S_MEALTYPE'
                                 ps_meal_info-mealtype
                          CHANGING ps_meal_info-mealtype_t.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_vendor_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&      --> PS_MEAL_INFO_CARRID
*&      --> PS_MEAL_INFO_MEALNUMBER
*&      <-- LS_VENDOR_INFO
*&---------------------------------------------------------------------*
FORM get_vendor_info  USING    VALUE(p_flag)
                               VALUE(p_code1)
                               VALUE(p_code2)
                      CHANGING ps_info TYPE zssa1593.
  DATA: BEGIN OF ls_cond,
          lifnr TYPE ztsa1599-lifnr,
          carrid TYPE ztsa1599-carrid,
          mealno TYPE ztsa1599-mealnumber,
        END OF ls_cond.

  CASE p_flag.
    WHEN 'V'.  "Vendor로
      ls_cond-lifnr = p_code1.

    WHEN 'M'.  "Meal로
      ls_cond-carrid = p_code1.
      ls_cond-mealno = p_code2.
      SELECT SINGLE *
        FROM ztsa1599
        INTO CORRESPONDING FIELDS OF ps_info
       WHERE carrid = ls_cond-carrid
         AND mealnumber = ls_cond-mealno.

    WHEN OTHERS.
      RETURN.
    ENDCASE.

    "Vendor Category Text
  PERFORM get_domain_text USING 'ZEVENCA_A01' ps_info-venca
                          CHANGING ps_info-venca_t.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_domain_text
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_domain_text USING VALUE(p_domname)
                           VALUE(p_code)
                     CHANGING VALUE(p_text).
  DATA lv_domname TYPE dd07l-domname.
  DATA lt_dom_value TYPE TABLE OF dd07v.
  DATA ls_dom_value LIKE LINE OF lt_dom_value.

  lv_domname = p_domname.
  CALL FUNCTION 'GET_DOMAIN_VALUES'
    EXPORTING
      domname               = lv_domname
*     TEXT                  = 'X'
*     FILL_DD07L_TAB        = ' '
   TABLES
     values_tab            = lt_dom_value
*     VALUES_DD07L          =
   EXCEPTIONS
     no_values_found       = 1
     OTHERS                = 2
            .
  IF sy-subrc <> 0.        "<> = A와 B가 다르다.
* Implement suitable error handling here
  ENDIF.

  CLEAR ls_dom_value.
  READ TABLE lt_dom_value WITH KEY domvalue_l = p_code
  INTO ls_dom_value.
  IF sy-subrc = 0.
    p_text = ls_dom_value-ddtext.
  ENDIF.


ENDFORM.
