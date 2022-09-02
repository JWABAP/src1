*&---------------------------------------------------------------------*
*& Include          ZBC405_A15_TEST_CLASS
*&---------------------------------------------------------------------*
CLASS lcl_handler DEFINITION.

  PUBLIC SECTION.

  CLASS-METHODS:  on_toolbar FOR EVENT
                  toolbar OF cl_gui_alv_grid
                  IMPORTING e_object,   "Attribute = data선언


                  on_usercommand FOR EVENT
                  user_command OF cl_gui_alv_grid
                  IMPORTING e_ucomm,

                  on_before_user_com FOR EVENT before_user_command
                  OF cl_gui_alv_grid
                  IMPORTING e_ucomm,

                  on_doubleclick FOR EVENT double_click
                  OF cl_gui_alv_grid
                  IMPORTING e_row e_column es_row_no,

                  on_data_changed FOR EVENT data_changed
                  OF cl_gui_alv_grid
                  IMPORTING er_data_changed,

                  on_data_changed_finished FOR EVENT data_changed_finished
                  OF cl_gui_alv_grid
                  IMPORTING e_modified et_good_cells.


ENDCLASS.

CLASS lcl_handler IMPLEMENTATION.

  "버튼 생성
  METHOD on_toolbar.

    wa_button-butn_type = '3'.
    INSERT wa_button INTO TABLE e_object->mt_toolbar.   "mt_toolbar에 데이터를 채우는것

    CLEAR : wa_button.
    wa_button-function = 'GETCARRID'.
    wa_button-icon      = ICON_Flight.
    wa_button-quickinfo = 'GET Airline Name'.
    wa_button-butn_type = '0'.
    INSERT wa_button INTO TABLE e_object->mt_toolbar.

    CLEAR : wa_button.
    wa_button-function = 'SCHE'.
    wa_button-text = 'Flight Info'.
    wa_button-quickinfo = 'Goto Flight list info'.
    wa_button-butn_type = '0'.
    INSERT wa_button INTO TABLE e_object->mt_toolbar.

    "3번째버튼
    CLEAR: wa_button.
    wa_button-butn_type   = '0'.
    wa_button-function     = 'FLDATA'.
    wa_button-quickinfo  = 'FLIGHT Data'.
    wa_button-text        = 'Flight Data'.
    INSERT wa_button INTO TABLE e_object->mt_toolbar.



  ENDMETHOD.


  "버튼 동작로직
  METHOD on_usercommand.

    DATA : lt_rows  TYPE lvc_t_row,
           ls_rows  LIKE LINE OF lt_rows.

    CALL METHOD go_alv->get_current_cell
      IMPORTING
        es_row_id = lv_row_id
        es_col_id = lv_col_id.

    CALL METHOD go_alv->get_selected_rows
      IMPORTING
        et_index_rows = lt_rows.
*        et_row_no     =


    CASE e_ucomm.
      "carrid 선택후 버튼을 눌렀을때 항공사 이름 팝업으로 가저오는 로직.
      WHEN 'GETCARRID'.
        IF  lv_col_id-fieldname = 'CARRID'.

          READ TABLE gt_spfli INTO gs_spfli INDEX lv_row_id-index.
          IF sy-subrc EQ 0.
            CLEAR : lv_text.
            SELECT SINGLE carrname
              INTO lv_text
              FROM scarr
             WHERE carrid = gs_spfli-carrid.
            IF sy-subrc EQ 0.
              MESSAGE i000(zt03_msg) WITH lv_text.
            ELSE.
              MESSAGE i000(zt03_msg) WITH 'No found!'.
            ENDIF.

          ELSE.
            MESSAGE i000(zt03_msg) WITH '항공사를 선택하세요'.
            EXIT.
          ENDIF.
        ENDIF.

        WHEN 'SCHE'.       "goto flight report
        READ TABLE gt_spfli INTO gs_spfli INDEX lv_row_id-index.
        IF sy-subrc EQ 0.
          SUBMIT bc405_event_d4 AND RETURN
*                    VIA SELECTION-SCREEN
                WITH so_car EQ gs_spfli-carrid
                WITH so_con EQ gs_spfli-connid.
        ENDIF.

        "3번째 버튼
        WHEN 'FLDATA'.
        READ TABLE gt_spfli INTO gs_spfli
        INDEX lv_row_id-index.             "index는 row나 cell선택이아니라 값을 선택하는것.

        IF sy-subrc = 0.
          SET PARAMETER ID 'CAR' FIELD gs_spfli-carrid.
          SET PARAMETER ID 'CON' FIELD gs_spfli-connid.

          CALL TRANSACTION 'SAPBC410A_INPUT_FIEL'.

        ENDIF.

    ENDCASE.
  ENDMETHOD.


  METHOD on_before_user_com.

    CASE e_ucomm.
      WHEN cl_gui_alv_grid=>mc_fc_detail.      "detail버튼을 바꾸는것.
        CALL METHOD go_alv->set_user_command
          EXPORTING
            i_ucomm = 'SCHE'.       "Flight schedule report  "유저커맨드에서 when으로 설정해놓음.   sche로 변경
    ENDCASE.

  ENDMETHOD.

  METHOD on_doubleclick.
    DATA : ls_col    TYPE lvc_s_col,
           ls_row_no TYPE lvc_s_roid,
           lv_value  TYPE c LENGTH 20.

    CALL METHOD go_alv->get_current_cell
      IMPORTING
*       e_row     =
        e_value   = lv_value
*       e_col     =
*       es_row_id =
        es_col_id = ls_col
        es_row_no = ls_row_no.

    CASE ls_col-fieldname.
      WHEN 'CARRID' OR 'CONNID'.
        READ TABLE gt_spfli
        INTO gs_spfli INDEX ls_row_no-row_id.
        SUBMIT bc405_event_s4 AND RETURN                "(8/16리뷰)and return을 해주어야한다.(안해주면 back하는순간 프로그램이 종료되버림)
        WITH so_car = gs_spfli-carrid
        WITH so_con = gs_spfli-connid.

    ENDCASE.
  ENDMETHOD.

  METHOD on_data_changed.
    DATA : ls_modi    TYPE lvc_s_modi,
           lv_fltime  TYPE ztspfli_a15-fltime,
           lv_depTime TYPE ztspfli_a15-depTime,
           lv_arrtime TYPE spfli-arrtime,
           lv_period  TYPE n,
           lv_light   TYPE c LENGTH 1.

    LOOP AT er_data_changed->mt_mod_cells INTO ls_modi.
      CASE ls_modi-fieldname.
        WHEN 'FLTIME' OR 'DEPTIME'.

          READ TABLE gt_spfli INTO gs_spfli INDEX ls_modi-row_id.

          CALL METHOD er_data_changed->get_cell_value
            EXPORTING
              i_row_id    = ls_modi-row_id
*             i_tabix     =
              i_fieldname = 'FLTIME'
            IMPORTING
              e_value     = lv_fltime.

          CALL METHOD er_data_changed->get_cell_value
            EXPORTING
              i_row_id    = ls_modi-row_id
*             i_tabix     =
              i_fieldname = 'DEPTIME'
            IMPORTING
              e_value     = lv_deptime.

          CALL FUNCTION 'ZBC405_CALC_ARRTIME'
            EXPORTING
              iv_fltime       = lv_fltime
              iv_deptime      = lv_deptime
              iv_utc          = gs_spfli-from_tzone
              iv_utc1         = gs_spfli-to_tzone
            IMPORTING
              ev_arrival_time = lv_arrtime
              ev_period       = lv_period.

          IF lv_period = 0.
            lv_LIGHT = 3.
          ELSEIF lv_period = 1.
            lv_LIGHT = 2.
          ELSEIF lv_period >= 2.
            lv_LIGHT = 1.
          ENDIF.


          CALL METHOD er_data_changed->modify_cell
            EXPORTING
              i_row_id    = ls_modi-row_id
*             i_tabix     =
              i_fieldname = 'ARRTIME'
              i_value     = lv_arrtime.

          CALL METHOD er_data_changed->modify_cell
            EXPORTING
              i_row_id    = ls_modi-row_id
*             i_tabix     =
              i_fieldname = 'PERIOD'
              i_value     = lv_period.

          CALL METHOD er_data_changed->modify_cell
            EXPORTING
              i_row_id    = ls_modi-row_id
*             i_tabix     =
              i_fieldname = 'LIGHT'
              i_value     = lv_LIGHT.

          gs_spfli-fltime = lv_fltime.
          gs_spfli-deptime = lv_deptime.
          gs_spfli-arrtime = lv_arrtime.
          gs_spfli-period = lv_period.
          gs_SPFLI-light = lv_LIGHT.

          MODIFY gt_spfli FROM gs_spfli INDEX ls_modi-row_id.

      ENDCASE.
    ENDLOOP.

  ENDMETHOD.

  METHOD on_data_changed_finished.

    DATA : ls_modi TYPE lvc_s_modi.

    CHECK e_modified = 'X'.

    LOOP AT et_good_cells INTO ls_modi.

      PERFORM modify_check USING ls_modi.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
