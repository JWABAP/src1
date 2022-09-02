*&---------------------------------------------------------------------*
*& Include          ZC1R150004_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data.

  CLEAR:  gs_data.
  REFRESH gt_data.

  SELECT a~matnr b~maktx a~stlan a~stlnr a~stlal c~mtart c~matkl
    FROM mast AS a INNER JOIN makt AS b
      ON a~matnr EQ b~matnr INNER JOIN mara AS c
      ON a~matnr EQ c~matnr
    INTO CORRESPONDING FIELDS OF TABLE gt_data
   WHERE a~werks = pa_werks
     AND a~matnr IN so_matnr.

  IF sy-subrc NE 0.
    MESSAGE i016(pn) WITH 'Data not found'.
    LEAVE LIST-PROCESSING.    "Stop
  ENDIF.

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
  IF gcl_container IS NOT BOUND. "= is INITIAL

    CREATE OBJECT gcl_container
      EXPORTING
        repid     = sy-repid
        dynnr     = sy-dynnr
*       side      = cl_gui_docking_container=>DOCK_AT_LEFT  "상수다,이 컨테이너 안에있음.(스태틱이다)
        side      = gcl_container->dock_at_left
        extension = 3000.

    CREATE OBJECT gcl_grid
      EXPORTING
        i_parent = gcl_container.

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

    PERFORM set_fcat USING:
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

  gt_fcat = VALUE #( BASE gt_fcat
                      ( key       = pv_key
                        fieldname = pv_field
                        coltext   = pv_text
                        ref_table = pv_ref_table
                        ref_field = pv_ref_field
                        )
                      ).
ENDFORM.
