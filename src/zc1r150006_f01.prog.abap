*&---------------------------------------------------------------------*
*& Include          ZC1R150006_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_list
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_flight_list .

  _clear gs_list gt_list.

  SELECT carrid connid fldate price currency
         planetype paymentsum
    INTO CORRESPONDING FIELDS OF TABLE gt_list
    FROM sflight
   WHERE carrid IN so_carr.

  IF sy-subrc NE 0.
    MESSAGE s001.
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
    'X'   'CARRID'        ' '   'SFLIGHT'   'CARRID',
    'X'   'CONNID'        ' '   'SFLIGHT'   'CONNID',
    'X'   'FLDATE'        ' '   'SFLIGHT'   'FLDATE',
    ' '   'CARRNAME'      ' '   'SCARR  '   'CARRNAME',
    ' '   'PRICE'         ' '   'SFLIGHT'   'PRICE',
    ' '   'CURRENCY'      ' '   'SFLIGHT'   'CURRENCY',
    ' '   'PLANETYPE'     ' '   'SFLIGHT'   'PLANETYPE',
    ' '   'PAYMENTSUM'    ' '   'SFLIGHT'   'PAYMENTSUM'.

  ENDIF.

  IF gt_sort IS INITIAL.

    PERFORM set_sort.

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
      gs_fcat = VALUE #( BASE gs_fcat
                         cfieldname = 'CURRENCY'
                         do_sum     = 'X' ).      "do_sum = 해당필드의 total값을 자동으로 내준다.

    WHEN 'PAYMENTSUM'.
      gs_fcat = VALUE #( BASE gs_fcat
                         cfieldname = 'CURRENCY' ).

  ENDCASE.

  APPEND gs_fcat TO gt_fcat.

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
*       side      = cl_gui_docking_container=>dock_at_left
        side      = gcl_container->dock_at_left
        extension = 3000.

    CREATE OBJECT gcl_grid
      EXPORTING
        i_parent = gcl_container.

    gs_variant-report = sy-repid.
    SET HANDLER: lcl_event_handler=>handle_double_click FOR gcl_grid.

    CALL METHOD gcl_grid->set_table_for_first_display
      EXPORTING
        is_variant      = gs_variant
        i_save          = 'A'
        i_default       = 'X'
        is_layout       = gs_layout
      CHANGING
        it_outtab       = gt_list
        it_fieldcatalog = gt_fcat
        it_sort         = gt_sort.

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
FORM handle_double_click  USING ps_row     TYPE lvc_s_row
                                ps_column  TYPE lvc_s_col.

  READ TABLE gt_list INTO gs_list INDEX ps_row-index.

  IF sy-subrc NE 0.
    EXIT.
  ENDIF.

  CASE ps_column-fieldname.
    WHEN 'CARRID'.
      IF gs_list-carrid IS INITIAL.      "말도안되는상황을막기위한 방책?
        EXIT.
      ENDIF.

      PERFORM get_airline_info USING gs_list-carrid.      "using gs_list-carrid = 다른 파라미터들도 받을수있게 확장성을 고려한것.
      "고려하지않고 반드시 들어가면 빼도된다.

  ENDCASE.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_airline_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GS_LIST_CARRID
*&---------------------------------------------------------------------*
FORM get_airline_info  USING pv_carrid TYPE scarr-carrid.     "같은타입으로 받는게 가장 이상적이다.(타입 해주기)

  _clear gs_scarr gt_scarr.   "매크로

  SELECT carrid carrname currcode url
    INTO CORRESPONDING FIELDS OF TABLE gt_scarr
    FROM scarr
   WHERE carrid = pv_carrid.

  IF sy-subrc NE 0.                     "갖고왔는지 체크
    MESSAGE i016(pn) WITH TEXT-t02.
    EXIT.
  ENDIF.

  CALL SCREEN '0101' STARTING AT 20 3.       "팝업이라서 100번스크린이 사라지지않기때문에 0200이아닌 0101
  "STARTING AT 20 3 = 팝업의 핵심

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat_layout_pop
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_fcat_layout_pop .

  gs_layout-zebra          = 'X'.
  gs_layout_pop-cwidth_opt = 'X'.
  gs_layout_pop-sel_mode   = 'D'.
  gs_layout_pop-no_toolbar = 'X'.        "ALV팝업의 툴바를 없애준다.

  IF gt_fcat_pop IS INITIAL.
    PERFORM set_fcat_pop USING :
     'X'  'CARRID'   ' '  'SCARR'  'CARRID',
     ''  'CARRNAME'  ' '  'SCARR'  'CARRNAME',
     ''  'CURRCODE'  ' '  'SCARR'  'CURRCODE',
     ''  'URL'       ' '  'SCARR'  'URL'.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat_pop
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&---------------------------------------------------------------------*
FORM set_fcat_pop  USING pv_key  pv_field  pv_text  pv_ref_table  pv_ref_field.

  gt_fcat_pop = VALUE #( BASE gt_fcat_pop
                         (
                           key       = pv_key
                           fieldname = pv_field
                           coltext   = pv_text
                           ref_table = pv_ref_table
                           ref_field = pv_ref_field
                           )
                         ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_screen_pop
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_screen_pop .

  IF gcl_container_pop IS NOT BOUND.

    CREATE OBJECT gcl_container_pop
      EXPORTING
        container_name = 'GCL_CONTAINER_POP'.    "컨트롤+u = 대문자로 바꾸가, 컨트롤+l = 소문자로바꾸기

    CREATE OBJECT gcl_grid_pop
      EXPORTING
        i_parent = gcl_container_pop.

    CALL METHOD gcl_grid_pop->set_table_for_first_display
      EXPORTING
        i_save          = 'A'
        i_default       = 'X'
        is_layout       = gs_layout_pop
      CHANGING
        it_outtab       = gt_scarr
        it_fieldcatalog = gt_fcat_pop.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_sort
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_sort .
  "신문법
  gt_sort = VALUE #(
                      (
                        spos      = 1           "정렬순서 기준은 spos로 관리한다.(필드를 먼저쓴다고 먼저나오는게아님)
                        fieldname = 'CARRID'
                        up        = 'X'         "Assending(오름차순 정렬)
                        subtot    = 'X'         "서브토탈(안하면 정렬만해서나옴)
                       )
                       (
                        spos      = 2
                        fieldname = 'CONNID'
                        up        = 'X'
                       )
                      ).

  "구문법으로 할 경우
*  gs_sort-spos = 1.
*  gs_sort-fieldname = 'CARRID'.
*  gs_sort-up = 'X'.
*  gs_sort-subtot = 'X'.
*
*  append gs_sort to gt_sort.
*
*  gs_sort-spos = 2.
*  gs_sort-fieldname = 'CONND'.
*  gs_sort-up = 'X'.
*
*  append gs_sort to gt_sort.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_carrname
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_carrname.

  DATA: lv_Tabix    TYPE sy-tabix,
        lt_scarr    TYPE zc1tt15001,
        ls_scarr    TYPE scarr,
        lv_code,
        lv_msg(100).

  IF gcl_Scarr IS NOT BOUND.    "확장성고려
    CREATE OBJECT gcl_scarr.
  ENDIF.

  LOOP AT gt_list INTO gs_list.
    lv_tabix = sy-tabix.

    _clear ls_scarr lt_scarr.  "loop돌면서 계속 갖고올거니까 그 전에 clear

    CLEAR: lv_code, lv_msg.
    CALL METHOD gcl_scarr->get_airline_info
      EXPORTING
        pi_carrid  = gs_list-carrid
      IMPORTING
        pe_code    = lv_code
        pe_msg     = lv_msg
      CHANGING
        et_airline = lt_scarr.

    IF lv_code EQ 'S'.
      READ TABLE lt_scarr INTO ls_scarr
      WITH KEY carrid = gs_list-carrid.

      IF sy-subrc EQ 0.
        gs_list-carrname = ls_scarr-carrname.

        MODIFY gt_list FROM gs_list INDEX lv_tabix
        TRANSPORTING carrname.
      ENDIF.

    ENDIF.

  ENDLOOP.

ENDFORM.
