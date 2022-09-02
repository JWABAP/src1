class ZCLC115_0002 definition
  public
  final
  create public .

public section.

  methods GET_MATERIAL_DATA
    importing
      !PI_MATNR type MATNR
    exporting
      !PE_MAKTX type MAKT-MAKTX
      !PE_CODE type CHAR1
      !PE_MSG type CHAR100 .
protected section.
private section.
ENDCLASS.



CLASS ZCLC115_0002 IMPLEMENTATION.


  METHOD get_material_data.

    IF pi_matnr IS INITIAL.
      pe_code = 'E'.
      pe_msg  = TEXT-e01.
      EXIT.
    ENDIF.

    SELECT SINGLE maktx           "하나만 가져올거니까 select single.
      INTO pe_maktx
      FROM makt
     WHERE matnr = pi_matnr
       AND spras = sy-langu.      "파라미터에 따로추가하지않고 시스템변수 언어키를 사용해도된다.

    IF sy-subrc NE 0.
      pe_code = 'E'.
      pe_msg  = TEXT-e02.
      EXIT.
    ELSE.
      pe_code = 'S'.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
