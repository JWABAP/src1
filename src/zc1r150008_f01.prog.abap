*&---------------------------------------------------------------------*
*& Include          ZC1R150005_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_bom_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
"항상 인터널테이블전에 clear하기
FORM get_bom_data .

  CLEAR gs_data.
  _clear gt_data.

  SELECT a~matnr a~stlan a~stlal a~stlnr
         b~mtart b~matkl
    INTO CORRESPONDING FIELDS OF TABLE gt_data
    FROM mast AS a
    INNER JOIN mara AS b
       ON a~matnr = b~matnr  "join은 join을걸고 둘의 연결관계를 확실히 하고 그 다음조인을 거는것이 좋다.
    WHERE a~werks = pa_werks
      AND a~matnr IN so_matnr.

  IF sy-subrc NE 0.
    MESSAGE i016(pn) WITH'Data not found'.
    LEAVE LIST-PROCESSING.
  ENDIF.

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
  gs_layout-sel_mode   = 'D'.
  gs_layout-cwidth_opt = 'X'.

  IF gt_fcat IS INITIAL.

    PERFORM set_fcat USING :
    'X'   'MATNR'   ' '   'MAST'    'MATNR',
    ' '   'MAKTX'   ' '   'MAKT'    'MAKTX',
    ' '   'STLAN'   ' '   'MAST'    'STLAN',
    ' '   'STLNR'   ' '   'MAST'    'STLNR',
    ' '   'STLAL'   ' '   'MAST'    'STLAL',
    ' '   'MTART'   ' '   'MARA'    'MTART',
    ' '   'MATKL'   ' '   'MARA'    'MATKL'.

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
FORM set_fcat  USING pv_key pv_field pv_text pv_ref_table pv_ref_field.

  gs_fcat = VALUE #(
                       key       = pv_key
                       fieldname = pv_field
                       coltext   = pv_text
                       ref_table = pv_ref_table
                       ref_field = pv_ref_field
                     ).

  "핫스팟
  CASE pv_field.
    WHEN 'STLNR'.
      gs_fcat-hotspot = 'X'.

  ENDCASE.
*  gs_fcat-key       = pv_key.
*  gs_fcat-fieldname = pv_field.
*  gs_fcat-coltext   = pv_text.
*  gs_fcat-ref_table = pv_ref_table.
*  gs_fcat-ref_field = pv_ref_field.
*
  APPEND gs_fcat TO gt_fcat.
*  CLEAR  gs_fcat.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_screen
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_screen .

  IF gcl_container IS NOT BOUND.

    CREATE OBJECT gcl_container
      EXPORTING
        repid     = sy-repid
        dynnr     = sy-dynnr
*       side      = gcl_container->dock_at_left
        side      = cl_gui_docking_container=>dock_at_left
        extension = 3000.

    CREATE OBJECT gcl_grid
      EXPORTING
        i_parent = gcl_container.

    gs_variant-report = sy-repid.

    "CREATE OBJECT할때 if문으로 체크하는것이좋다.
    IF  gcl_handler IS NOT BOUND.       "is mot initial
      CREATE OBJECT gcl_handler.
    ENDIF.

    SET HANDLER : gcl_handler->handle_double_click FOR gcl_grid.
    SET HANDLER : gcl_handler->handle_hotspot      FOR gcl_grid.

    CALL METHOD gcl_grid->set_table_for_first_display
      EXPORTING
        is_variant      = gs_variant
        i_save          = 'A'
        i_default       = 'X'
        is_layout       = gs_layout
      CHANGING
        it_outtab       = gt_data
        it_fieldcatalog = gt_fcat.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form handle_double_click
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_ROW
*&      --> E_COLUMN
*&---------------------------------------------------------------------*
"더블클릭 이벤트
FORM handle_double_click  USING ps_e_row    TYPE lvc_s_row
                                ps_e_column TYPE lvc_s_col.

  READ TABLE gt_data INTO gs_data INDEX ps_e_row-index.

  IF sy-subrc NE 0.
    EXIT.
  ENDIF.

  CASE ps_e_column-fieldname.
    WHEN 'MATNR'.
      IF gs_data-matnr IS INITIAL.
        EXIT.
      ENDIF.

      SET PARAMETER ID : 'MAT' FIELD gs_data-matnr. "MM03

      CALL TRANSACTION 'MM03' AND SKIP FIRST SCREEN.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form handle_hotspot
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_ROW_ID
*&      --> E_COLUMN_ID
*&---------------------------------------------------------------------*
FORM handle_hotspot  USING ps_row_id     TYPE lvc_s_row
                           ps_column_id  TYPE lvc_s_col.

  READ TABLE gt_data INTO gs_data INDEX ps_row_id-index.

  IF sy-subrc NE 0.
    EXIT.
  ENDIF.

  CASE ps_column_id-fieldname.
    WHEN 'STLNR'.
      IF gs_data-stlnr IS INITIAL.
        EXIT.
      ENDIF.

      SET PARAMETER ID: 'MAT' FIELD gs_data-matnr,
                        'WRK' FIELD pa_werks,
                        'CSV' FIELD gs_data-stlan.

      CALL TRANSACTION 'CS03' AND SKIP FIRST SCREEN.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_maktx
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_maktx .
  DATA: lv_Tabix    TYPE sy-tabix,
        ls_maktx    TYPE maktx,
        lv_code,
        lv_msg(100).

  IF gcl_maktx IS NOT BOUND.    "확장성고려
    CREATE OBJECT gcl_maktx.
  ENDIF.

  LOOP AT gt_data INTO gs_data.
    lv_tabix = sy-tabix.

    _clear ls_maktx lt_maktx.  "loop돌면서 계속 갖고올거니까 그 전에 clear

    CLEAR: lv_code, lv_msg.

    CALL METHOD gcl_maktx->get_material_data
      EXPORTING
        pi_maktx  = gs_data-maktx
      IMPORTING
        pe_code    = lv_code
        pe_msg     = lv_msg
      CHANGING
        et_airline = lt_scarr.


  ENDLOOP.
ENDFORM.
