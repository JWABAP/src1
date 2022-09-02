*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .
  SELECT *
  INTO CORRESPONDING FIELDS OF TABLE gt_spfli
  FROM ztspfli_a15
 WHERE carrid IN so_car
   AND connid IN so_con.

  SELECT *
   INTO TABLE gt_timezone
        FROM sairport.

  LOOP AT gt_spfli INTO gs_spfli.

*---비행타입(국내선인지 국제선인지.)
    IF gs_spfli-countryfr = gs_spfli-countryto.
      gs_spfli-int_dom = 'D'.   "국내선
    ELSE.
      gs_spfli-int_dom = 'I'.   "국제선
    ENDIF.

    "아이콘 넣기
    IF gs_spfli-fltype = 'X'.
      gs_spfli-flight_icon = icon_flight.
    ELSE.
      gs_spfli-flight_icon = icon_space.
    ENDIF.

    "I&D 필드에 색깔넣기
    IF gs_spfli-int_dom = 'D'.

      gs_color-fname = 'INT_DOM'.
      gs_color-color-col = 3.
      gs_color-color-int = 1.
      gs_color-color-inv = 0.
      APPEND gs_color TO gs_spfli-it_color.

    ELSEIF gs_spfli-int_dom = 'I'.
      gs_color-fname = 'INT_DOM'.
      gs_color-color-col = col_positive.
      gs_color-color-int = 1.
      gs_color-color-inv = 0.
      APPEND gs_color TO gs_spfli-it_color.
    ENDIF.


*---신호등---*
    IF gs_spfli-period >= 2.
      gs_spfli-light = 1.     "1 = Red
    ELSEIF gs_spfli-period = 1.
      gs_spfli-light = 2.       "2 = Yellow
    ELSE.
      gs_spfli-light = 3.      "3 = Green
    ENDIF.

*---TimeZone---*
    READ TABLE gt_timezone
    INTO gs_timezone WITH KEY id = gs_spfli-airpfrom.
    IF sy-subrc = 0.
      gs_spfli-from_tzone = gs_timezone-time_zone.

    ENDIF.

    READ TABLE gt_timezone
    INTO gs_timezone WITH KEY id = gs_spfli-airpto.
    IF sy-subrc = 0.
      gs_spfli-to_tzone = gs_timezone-time_zone.
    ENDIF.


    MODIFY gt_spfli FROM gs_spfli.             "데이터 적용

  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_variant
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_variant .
  p_layout = gs_variant-variant.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form make_fcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM make_fcat .

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'FLTIME'.
  gs_fcat-edit = p_edit.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'DEPTIME'.
  gs_fcat-edit = p_edit.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'INT_DOM'.
  gs_fcat-coltext = 'I&D'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'FLTYPE'.
  gs_fcat-no_out = 'X'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'FLIGHT_ICON'.
  gs_fcat-coltext = 'FLIGHT'.
  gs_fcat-col_pos = 9.
  APPEND gs_fcat TO gt_fcat.

  "필드추가(FTZ)
  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'FROM_TZONE'.           "펑션코드는 top에서 선언한 이름과 동일해야한다(대문자)
  gs_fcat-coltext = 'From TZ'.
  gs_fcat-ref_table = 'SAIRPORT'.
  gs_fcat-ref_field = 'TIME_ZONE'.
  gs_fcat-col_pos = 16.
  APPEND gs_fcat TO gt_fcat.

  "필드추가(TTZ)
  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'TO_TZONE'.
  gs_fcat-coltext = 'To TZO'.
  gs_fcat-ref_table = 'SAIRPORT'.
  gs_fcat-ref_field = 'TIME_ZONE'.
  gs_fcat-col_pos = 17.
  APPEND gs_fcat TO gt_fcat.

  "신호등
  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'LIGHT'.
  gs_fcat-coltext = 'Exception'.
  APPEND gs_fcat TO gt_fcat.

  "강조
  gs_fcat-fieldname = 'ARRTIME'.
  gs_fcat-emphasize = 'C400'.
  APPEND gs_fcat TO gt_fcat.


  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'PERIOD'.
  gs_fcat-emphasize = 'C600'.
  APPEND gs_fcat TO gt_fcat.




ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_layout .
  gs_layout-sel_mode = 'D'.
  gs_layout-excp_fname = 'LIGHT'.
  gs_layout-excp_led   = 'X'.
  gs_layout-zebra      = 'X'.
  gs_layout-cwidth_opt = 'X'.

  gs_layout-ctab_fname = 'IT_COLOR'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form exclude_button
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM exclude_button .
  APPEND cl_gui_alv_grid=>mc_fc_info           TO gt_exct.
  APPEND cl_gui_alv_grid=>mc_fc_loc_cut        TO gt_exct.
  APPEND cl_gui_alv_grid=>mc_fc_loc_copy       TO gt_exct.
  APPEND cl_gui_alv_grid=>mc_mb_paste          TO gt_exct.
  APPEND cl_gui_alv_grid=>mc_fc_loc_append_row TO gt_exct.
  APPEND cl_gui_alv_grid=>mc_fc_loc_insert_row TO gt_exct.
  APPEND cl_gui_alv_grid=>mc_fc_loc_delete_row TO gt_exct.
  APPEND cl_gui_alv_grid=>mc_fc_loc_copy_row   TO gt_exct.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form data_save
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM data_save .
  DATA lv_ans TYPE c LENGTH 1.

  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      titlebar              = 'Data Save'
      text_question         = '저장하시겠습니까?'
      text_button_1         = 'Yes'
      text_button_2         = 'No'
      display_cancel_button = ''
    IMPORTING
      answer                = lv_ans
    EXCEPTIONS
      text_not_found        = 1
      OTHERS                = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ELSE.
    IF lv_ans = '1'.

      "UPDATE
      LOOP AT gt_spfli INTO gs_spfli WHERE modified = 'X'.

        UPDATE ztspfli_a15
        SET fltime = gs_spfli-fltime
            deptime = gs_spfli-deptime
            arrtime = gs_spfli-arrtime
            period = gs_spfli-period
            WHERE carrid = gs_spfli-carrid
            AND connid = gs_spfli-connid.

      ENDLOOP.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form modify_check
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_MODI
*&---------------------------------------------------------------------*
FORM modify_check  USING value(p_modi) type lvc_s_modi.
  READ TABLE gt_spfli
  INTO gs_spfli INDEX p_modi-row_id.
  IF sy-subrc EQ 0.

    gs_spfli-modified = 'X'.

    MODIFY gt_spfli FROM gs_spfli INDEX p_modi-row_id.
  ENDIF.
ENDFORM.
