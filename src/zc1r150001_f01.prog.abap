*&---------------------------------------------------------------------*
*& Include          ZC1R150001_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form init_parameter
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM init_parameter .

  pa_carr = 'KA'.    "셀렉션스크린에서 default로 설정하는것과 같은효과

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

  CLEAR:  gs_data.
  REFRESH gt_data.

  SELECT carrid connid fldate price currency planetype
    INTO CORRESPONDING FIELDS OF TABLE gt_data
    FROM sflight
   WHERE carrid  = pa_carr
     AND connid IN so_conn.

  IF sy-subrc NE 0.
    MESSAGE i016(pn) WITH 'Data not found'.
    LEAVE LIST-PROCESSING.    "Stop
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
FORM set_fcat_layout.
  gs_layout-zebra      = 'X'.
  gs_layout-sel_mode   = 'D'.
  gs_layout-cwidth_opt = 'X'.

  IF gt_fcat IS INITIAL.    "엔터만처도 계속만들기때문에 비어있을때만

    PERFORM set_fcat USING :
    'X'   'CARRID'     '' 'SFLIGHT' 'CARRID',
    'X'   'CONNID'     '' 'SFLIGHT' 'CONNID',
    'X'   'FLDATE'     '' 'SFLIGHT' 'FLDATE',
    ' '   'PRICE'      '' 'SFLIGHT' 'PRICE',
    ' '   'CURRENCY'   '' 'SFLIGHT' 'CURRENCY',
    ' '   'PLANETYPE'  '' 'SFLIGHT' 'PLANETYPE'.
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

  gs_fcat = VALUE #( key       = pv_key
                     fieldname = pv_field
                     coltext   = pv_text
                     ref_table = pv_ref_table
                     ref_field = pv_ref_field ).

  CASE pv_field.
    WHEN 'PRICE'.
      gs_fcat-cfieldname = 'CURRENCY'.

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

*  if gcl_container is INITIAL.
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
