*&---------------------------------------------------------------------*
*& Include          SAPMZC1150001_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form f4_werks
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f4_werks .

  "신문법을 사용하면 인터널테이블을 따로 만들필요가없다.
  SELECT werks, name1, ekorg, land1
    INTO TABLE @DATA(lt_werks)
    FROM t001w.

  IF sy-subrc NE 0.
    MESSAGE i016(pn) WITH 'No Value Found'.
    EXIT.
  ENDIF.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield     = 'WERKS'
      dynpprog     = sy-repid
      dynpnr       = sy-dynnr
      dynprofield  = 'GS-DATA-WERKS'
      window_title = TEXT-t01
      value_org    = 'S'
    TABLES
      value_tab    = lt_werks.





ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .

  REFRESH gt_data.

  SELECT matnr werks mtart matkl menge meins dmbtr waers
    INTO CORRESPONDING FIELDS OF TABLE gt_data
    FROM ztc1150001.
  "데이터가없으면 저장, 있으면 누르는순간 밑에 나오게

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_fcat_layout .

  gs_layout-zebra      = 'X'.
  gs_layout-cwidth_opt = 'X'.
  gs_layout-sel_mode   = 'D'.

  IF gt_fcat IS INITIAL.

    PERFORM set_fcat USING :
    'X'   'MATNR'   ' '   'ZTC1260001'  'MATNR'   ' '       ' ',
    'X'   'WERKS'   ' '   'ZTC1260001'  'WERKS'   ' '       ' ',
    ' '   'MTART'   ' '   'ZTC1260001'  'MTART'   ' '       ' ',
    ' '   'MATKL'   ' '   'ZTC1260001'  'MATKL'   ' '       ' ',
    ' '   'MENGE'   ' '   'ZTC1260001'  'MENGE'   'MEINS'   ' ',
    ' '   'MEINS'   ' '   'ZTC1260001'  'MEINS'   ' '       ' ',
    ' '   'DMBTR'   ' '   'ZTC1260001'  'DMBTR'   ' '       'WAERS',
    ' '   'WAERS'   ' '   'ZTC1260001'  'WAERS'   ' '       ' '.

  ENDIF.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&---------------------------------------------------------------------*
FORM set_fcat  USING pv_key
                     pv_field
                     pv_text
                     pv_ref_table
                     pv_ref_field
                     pv_qfield
                     pv_cfield.

  gt_fcat = VALUE #( BASE gt_fcat
                     (
                       key        = pv_key
                       fieldname  = pv_field
                       coltext    = pv_text
                       ref_table  = pv_ref_table
                       ref_field  = pv_ref_field
                       qfieldname = pv_qfield
                       cfieldname = pv_cfield
                     )
                   ).
ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_alv.

  IF gcl_container IS NOT BOUND.

    CREATE OBJECT gcl_container
      EXPORTING
        container_name = 'GCL_CONTAINER'.

    CREATE OBJECT gcl_grid
      EXPORTING
        i_parent = gcl_container.

    gs_variant-report = sy-repid.

    CALL METHOD gcl_grid->set_table_for_first_display
      EXPORTING
        is_variant      = gs_variant
        i_save          = 'A'
        i_default       = 'X'
        is_layout       = gs_layout
      CHANGING
        it_outtab       = gt_data
        it_fieldcatalog = gt_fcat.
  ELSE.
    PERFORM refresh_grid.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form save_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM save_data .

  DATA: ls_save TYPE ztc1150001.

  CLEAR ls_save.

  IF gs_data-matnr IS INITIAL OR
     gs_data-werks IS INITIAL.
    MESSAGE i016(pn) WITH TEXT-e01 DISPLAY LIKE 'E'.
    EXIT.
  ENDIF.

  ls_save = CORRESPONDING #( gs_data ).     "필드이름이 다 똑같기때문에 이렇게 써도 된다.

*  append ls_save to lt_save.      "데이터가 하나기때문에 굳이 인터널테이블에 넣지 않아도된다.
  MODIFY ztc1150001 FROM ls_save.  "subrc로체크하면 무조건0이떨어저서 변경된사항이없으면

  IF sy-dbcnt > 0.    "하나라도 들어가면
    COMMIT WORK AND WAIT.
    MESSAGE i016(pn) WITH 'Data Saved Succesfully'.
  ELSE.
    ROLLBACK WORK.
    MESSAGE i016(pn) WITH TEXT-e02 DISPLAY LIKE 'W'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form refresh_grid
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM refresh_grid .

  DATA : ls_stable TYPE lvc_s_stbl.

  ls_stable-row = 'X'.
  ls_stable-col = 'X'.

  CALL METHOD gcl_grid->refresh_table_display
    EXPORTING
      is_stable      = ls_stable
      i_soft_refresh = space.

ENDFORM.
