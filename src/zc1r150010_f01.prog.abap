*&---------------------------------------------------------------------*
*& Include          ZC1R150010_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_emp_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_emp_data.

  SELECT pernr ename entdt gender depid carrid
    FROM ztsa1501
    INTO CORRESPONDING FIELDS OF TABLE gt_data
   WHERE pernr IN so_pernr.

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
*  gs_layout-cwidth_opt = 'X'.       "화면에서 각각의 필드의 길이를 미리 지정할 수 도 있다.(
  gs_layout-sel_mode   = 'D'.
  gs_layout-stylefname = 'STYLE'.

  IF gt_fcat IS INITIAL.     "항상 비어있을때만 하기

    PERFORM set_fcat USING :
     'X'  'PERNR'    ' '  'ZTSA1501'  'PERNR'    'X' 10,      " 'X' = edit모드
     ' '  'ENAME'    ' '  'ZTSA1501'  'ENAME'    'X' 20,
     ' '  'ENTDT'    ' '  'ZTSA1501'  'ENTDT'    'X' 10,
     ' '  'GENDER'   ' '  'ZTSA1501'  'GENDER'   'X' 5,
     ' '  'DEPID'    ' '  'ZTSA1501'  'DEPID'    'X' 8,
     ' '  'CARRID'   ' '  'ZTSA1501'  'CARRID'   'X' 10,
     ' '  'CARRNAME' ' '  'SCARR'     'CARRNAME' ' ' 20.


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
                     pv_edit
                     pv_length.

  gt_fcat = VALUE #( BASE gt_fcat              "기존껄 유지시킨다.(BASE가없으면 날아간다)
                     (
                       key       = pv_key
                       fieldname = pv_field
                       coltext   = pv_text
                       ref_table = pv_ref_table
                       ref_field = pv_ref_field
                       edit      = pv_edit
                       outputlen = pv_length"길이를 미리 지정해서 필드를 그 길이만큼 나오게할 수 있다.
                     )                      "조건으로는 gs_layout-cwidth_opt를 비활성화해야 사용가능
                   ).

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
        side      = gcl_container->dock_at_left
        extension = 3000.

    CREATE OBJECT gcl_grid
      EXPORTING
        i_parent = gcl_container.

    gs_variant-report = sy-repid.

    SET HANDLER : lcl_event_handler=>handle_data_changed     FOR gcl_grid,
                  lcl_event_handler=>handle_change_finished  FOR gcl_grid.

    CALL METHOD gcl_grid->register_edit_event
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_modified
      EXCEPTIONS
        error      = 1
        OTHERS     = 2.


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
*& Form create_row
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_row.

  CLEAR gs_data.

  APPEND gs_data TO gt_data.    "여기까지하면 인터널테이블은 생겼다. 하지만 alv에는 생기지않았으므로 top에서 stable을추가해주고
  "ALV에 반영해야하기때문에 REFRESH를 사용한다.

  PERFORM refresh_grid.

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

  gs_stable-row = 'X'.
  gs_stable-col = 'X'.

  CALL METHOD gcl_grid->refresh_table_display
    EXPORTING
      is_stable      = gs_stable
      i_soft_refresh = space.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form save_employee
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM save_employee.

  DATA : lt_save  TYPE TABLE OF ztsa1501,
         lt_del   TYPE TABLE OF ztsa1501,
         lv_cnt   TYPE i,
         lv_error.

  REFRESH lt_save.

  CALL METHOD gcl_grid->check_changed_data. "ALV의 입력된 값을 ITAB으로 반영시키기위해서 호출한 메소드

  CLEAR lv_error.   "필수입력값 입력 여부 체크
  LOOP AT gt_data INTO gs_data.

    IF gs_data-pernr IS INITIAL.
      MESSAGE s000 WITH TEXT-e01 DISPLAY LIKE 'E'.
      lv_error = 'X'.   "에러발생 했을경우 저장 플로우 수행방지를위해서 값 세팅
      EXIT.     "현재수행중인 루틴을 빠져나간다.(여기선 LOOP를 빠저나감)
    ENDIF.

    lt_save = VALUE #( BASE lt_save     "에러없는 데이터는 저장할 시 ITAB에 데이터 저장하기
                       (
                        pernr  = gs_data-pernr
                        ename  = gs_data-ename
                        entdt  = gs_data-entdt
                        gender = gs_data-gender
                        depid  = gs_data-depid
                        carrid = gs_data-carrid
                        )
                      ).


  ENDLOOP.

*  CHECK lv_error IS INITIAL.   "에러가 없었으면 아래 로직수행
  IF lv_error IS NOT INITIAL.   "에러가 있었으면 현재 루틴을 빠져나감.
    EXIT.
  ENDIF.

  IF gt_data_del IS NOT INITIAL.

    LOOP AT gt_data_del INTO DATA(ls_del).

      lt_del = VALUE #( BASE lt_del
                        ( pernr = ls_Del-pernr )
                       ).

    ENDLOOP.

    DELETE ztsa1501 FROM TABLE lt_del.

    IF sy-dbcnt > 0.
      lv_cnt = lv_cnt + sy-dbcnt.
    ENDIF.

  ENDIF.

  IF lt_save IS NOT INITIAL.

    MODIFY ztsa1501 FROM TABLE lt_save.   "lt_save의 데이터를 ztsa1501테이블에 modify(있으면update, 없으면 insert)
    "FROM TABLE이아닌 FROM만하면 데이터 하나만들어온다(SINGLE), FROM TABLE은 모든 데이터가 들어온다

    IF sy-dbcnt > 0.
      lv_cnt += sy-dbcnt.
    ENDIF.

  ENDIF.

  IF lv_cnt > 0.
    COMMIT WORK AND WAIT.
    MESSAGE s002.
  ENDIF.

*    IF sy-dbcnt > 0.     "MODIFY는 SY-SUBRC가 0이뜨기때문에 SY-DBCNT로 체크
*      COMMIT WORK AND WAIT.
*      MESSAGE s002.       "DATA저장 성공 메시지
*    ENDIF.
*
*  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form delete_row
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM delete_row .

  REFRESH gt_rows.

  CALL METHOD gcl_grid->get_selected_rows "사용자가 선택한 행의 정보를 가져온다.
    IMPORTING
      et_index_rows = gt_rows.

  IF gt_rows IS INITIAL.   "Row(행)을 선택했는지 체크
    MESSAGE s000 WITH TEXT-e02 DISPLAY LIKE 'E'.
    EXIT.
  ENDIF.

*  LOOP AT gt_rows INTO gs_row.
*
*    READ TABLE gt_data INTO gs_data INDEX gs_row-index.
*
*    IF sy-subrc EQ 0.
*      gs_data-mark = 'X'.
*
*      MODIFY gt_data FROM gs_data INDEX gs_row-index
*      TRANSPORTING mark.
*    ENDIF.

*  ENDLOOP.

*    DELETE gt_emp WHERE mark = 'X'.
*    DELETE gt_data WHERE mark IS NOT INITIAL.



  SORT gt_rows BY index DESCENDING.   "이 로직을 해주지않으면 delete를할때 이상해짐

  LOOP AT gt_rows INTO gs_row.

*ITAB에서 삭제하기전에 DB TABLE에서도 삭제해야하므로 삭제대상을 따로보관
    READ TABLE gt_data INTO gs_data INDEX gs_row-index. "선택한 행의 정보 조회

    IF sy-subrc EQ 0.
      APPEND gs_data TO gt_data_del.    "삭제대상을 삭제ITAB에 보관'
    ENDIF.

    DELETE gt_data INDEX gs_row-index. "사용자가 선택한 행을 직접 삭제한다.

  ENDLOOP.

  PERFORM refresh_grid.     "변경된 ITAB을 ALV에 반영

  "퍼포먼스를 굳이 따지자면 밑의 로직이 더 좋다(위에껀 데이터가많을경우 그 많은데이터를 전부 마크해주고 또 삭제해야하는반면에
  "아래 로직은 선택한 행을 직접 삭제하기때문에 아래 로직이 퍼포먼스는 더 좋다.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_style
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_style .

  DATA: lv_tabix TYPE sy-tabix,
        ls_style TYPE lvc_s_styl.

  "구문법
*  ls_style-fieldname = 'PERNR'.
*  ls_style-style     = cl_gui_alv_grid=>mc_style_disabled.

  "신문법
  ls_style = VALUE #( fieldname = 'PERNR'         "PERNR이라는 필드를
                      style     = cl_gui_alv_grid=>mc_style_disabled ).   "disabled상태로 지정했다.

* Table에서 가지고 온 데이터의 PK는 변경방지를 위해서 수정금지모드(disabled)로
  LOOP AT gt_data INTO gs_data.
    lv_tabix = sy-tabix.

    REFRESH gs_data-style.

    APPEND ls_style TO gs_data-style.

    MODIFY gt_data FROM gs_data INDEX lv_tabix
    TRANSPORTING style.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_style_table
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_style_table.

  DATA: lv_tabix TYPE sy-tabix,
        ls_style TYPE lvc_s_styl,
        lt_style TYPE lvc_t_styl.

  "구문법
*  ls_style-fieldname = 'PERNR'.
*  ls_style-style     = cl_gui_alv_grid=>mc_style_disabled.
*  APPEND ls_style TO lt_style


*  ls_style = VALUE #( fieldname = 'PERNR'         "PERNR이라는 필드를
*                      style     = cl_gui_alv_grid=>mc_style_disabled ).   "disabled상태로 지정했다.
*  APPEND ls_style TO lt_style

  "신문법 :인터널 테이블만 사용시
  lt_style = VALUE #(
                      (
                        fieldname = 'PERNR'
                        style     = cl_gui_alv_grid=>mc_style_disabled
                      )
                    ).


* Table에서 가지고 온 데이터의 PK는 변경방지를 위해서 수정금지모드(disabled)로
  LOOP AT gt_data INTO gs_data.
    lv_tabix = sy-tabix.

    REFRESH gs_data-style.

    APPEND LINES OF lt_style TO gs_data-style.
*   gs_emp-style = lt_style.
*   move-corresponding lt_style to gs_data-style.

    MODIFY gt_data FROM gs_data INDEX lv_tabix
    TRANSPORTING style.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form handle_data_changed
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ER_DATA_CHANGED
*&      --> ENDCLASS
*&---------------------------------------------------------------------*
FORM handle_data_changed  USING pcl_data_changed TYPE REF TO
                                cl_alv_changed_data_protocol.

*  LOOP AT pcl_data_changed->mt_mod_cells INTO DATA(ls_modi). "into data(ls_modi) = 신문법 (data로선언한거임)
*
*    READ TABLE gt_data INTO gs_data INDEX ls_modi-row_id.
*
*    IF sy-subrc NE 0.
*      CONTINUE.
*    ENDIF.
*
*    SELECT SINGLE carrname
*      INTO gs_data-carrname
*      FROM scarr
*     WHERE carrid = ls_modi-value.      "새로운값을 갖고있다.
*
*    IF sy-subrc NE 0.
*      CLEAR gs_data-carrname.
*    ENDIF.
*
*    MODIFY gt_data FROM gs_data INDEX ls_modi-row_id
*    TRANSPORTING carrname.
*
*  ENDLOOP.
*
*  PERFORM refresh_grid.      "루프가 다 끝나고

ENDFORM.
*&---------------------------------------------------------------------*
*& Form handle_change_finished
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_MODIFIED
*&      --> ET_GOOD_CELLS
*&---------------------------------------------------------------------*
FORM handle_change_finished  USING pv_modified
                                   pt_good_cells TYPE lvc_t_modi.

* DATA: ls_modi TYPE lvc_s_modi.

  LOOP AT pt_good_cells INTO DATA(ls_modi).

    READ TABLE gt_data INTO gs_data INDEX ls_modi-row_id.

    IF sy-subrc NE 0.
      CONTINUE.
    ENDIF.

    SELECT SINGLE carrname
      INTO gs_data-carrname
      FROM scarr
     WHERE carrid = gs_data-carrid.

    IF sy-subrc NE 0.
      CLEAR gs_data-carrname.
    ENDIF.

    MODIFY gt_data FROM gs_data INDEX ls_modi-row_id
    TRANSPORTING carrname.

  ENDLOOP.

  PERFORM refresh_grid.

ENDFORM.
