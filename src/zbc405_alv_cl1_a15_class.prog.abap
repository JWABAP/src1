*&---------------------------------------------------------------------*
*& Include          ZBC405_ALV_CL1_A15_CLASS
*&---------------------------------------------------------------------*
CLASS lcl_handler DEFINITION.       "정의 부분
  "클래스에는 퍼블릭섹션,프라이빗섹션,프로텍티드섹션이 있다.

  PUBLIC SECTION.

                  "더블클릭 이벤트(더블클릭하면 정보 취득)
    CLASS-METHODS: on_doubleclick FOR EVENT        "스태틱으로 정의한다.
                double_click OF cl_gui_alv_grid
                IMPORTING e_row  e_column  es_row_no,

                  "버튼 만들기
                   on_toolbar FOR EVENT
                toolbar OF cl_gui_alv_grid
                IMPORTING e_object,

                  "버튼 작동
                   on_usercommand FOR EVENT
                user_command OF cl_gui_alv_grid
                IMPORTING e_ucomm,

                  "데이터 체인지, 어떤셀이든 변경하면 들어가는 이벤트
                  on_data_changed FOR EVENT
                data_changed OF cl_gui_alv_grid
                IMPORTING er_data_changed,

                  "데이터 체인지
                  on_data_changed_finish FOR EVENT
                data_changed_finished OF cl_gui_alv_grid
                IMPORTING e_modified et_good_cells.           "et_good_cells = 테이블타입

ENDCLASS.

CLASS lcl_handler IMPLEMENTATION.  "기술부분(구현부분)

  METHOD on_doubleclick.

    DATA : carrname TYPE scarr-carrname.

    CASE e_column-fieldname.
      WHEN 'CARRID'.              "필드네임이 CARRID일때
        READ TABLE gt_sbook INTO gs_sbook
             INDEX e_row-index.
        IF sy-subrc EQ 0.

          SELECT SINGLE carrname
            INTO carrname
            FROM scarr
           WHERE carrid = gs_sbook-carrid.

            IF sy-subrc EQ 0.
              MESSAGE i000(zt03_msg) WITH carrname.
            ENDIF.

        ENDIF.

    ENDCASE.

  ENDMETHOD.

  "버튼 추가하는 로직
  METHOD on_toolbar.
    DATA : wa_button TYPE stb_button.     "stb_button =

    wa_button-butn_type = '3'.  "버튼타입 0 = 노말  3 = seperator(구분선)
    INSERT wa_button INTO TABLE e_object->mt_toolbar.   "mt_toolbar에 데이터를 채우는것

    CLEAR : wa_button.
    wa_button-butn_type = '0'.  "노말타입
    wa_button-function  = 'GOTOFL'.   "Flight Connection
    wa_button-icon      = ICON_Flight.
    wa_button-quickinfo = 'Go to Flight Connection'.
    wa_button-text      = 'Flight'.
    INSERT wa_button INTO TABLE e_object->mt_toolbar.        "mt_toolbar에 데이터 삽입


  ENDMETHOD.

  "버튼 작동 로직(유저커맨드)
  METHOD on_usercommand.
     DATA : ls_col  TYPE lvc_s_col,
            ls_roid TYPE lvc_s_roid.


     CALL METHOD go_alv->get_current_cell     "CL_GUI_ALV_GRID->method안에 있음 ,Get_Current_Cell = 클릭하고있는 위치 알려주는 로직
      IMPORTING
        es_col_id = ls_col
        es_row_no = ls_roid.         "현재 클릭하고있는위치,roid의 위치를 알 수 있다.


    CASE e_ucomm.
      WHEN 'GOTOFL'.
       READ TABLE gt_sbook INTO gs_sbook
            INDEX ls_roid-row_id.
       IF sy-subrc EQ 0.
         SET PARAMETER ID 'CAR' FIELD gs_sbook-carrid.
         SET PARAMETER ID 'CON' FIELD gs_sbook-connid.

         CALL TRANSACTION 'SAPBC405CAL'.

       ENDIF.

    ENDCASE.


        "set PARAMETER ID 'CAR' field
  ENDMETHOD.

  "EDIT모드로 들어가서 CUSTOMID를 변경하면 이메일와 전화번호가 자동으로 입력되게하는 로직.
  METHOD on_data_changed.

    FIELD-SYMBOLS : <fs> LIKE gt_sbook.

    DATA : ls_mod_cells TYPE lvc_s_modi,
           ls_ins_cells TYPE lvc_s_moce,
           ls_del_cells TYPE lvc_s_moce.

    LOOP AT er_data_changed->mt_good_cells INTO ls_mod_cells.   "변경되는 항목에대한 정보가 mt_good_cells에 쌓인다.
                                                                "테이블 타입이다. ls_mod_cells를 워크 에이리어로 넣는다.

      CASE ls_mod_cells-fieldname.

        WHEN 'CUSTOMID'.    "현재변경하고있는것중 필드이름이 CUSTOMID일때.
          PERFORM customer_change_part USING er_data_changed                       "커스텀 아이디 변경하는 부분
                                       ls_mod_cells.
          "Customer정보를 변경할때 customer_change_part를 탈것이다.

        WHEN 'CANCELLED'.


      ENDCASE.


    ENDLOOP.

*-- Inserted Parts --* Edit모드에서 드래그 후 필드를 추가할때 레이아웃스타일을 그대로 적용시키는 로직?
    IF  er_data_changed->mt_inserted_rows IS NOT INITIAL.


     "아래의 로직은 사용자가 row를 드래그해서 새로운 셀을 추가하지않고 툴바에서 +를 눌러서 하나씩 추가하게되면 mp_mod_rows에 누른 횟수만큼 계속 쌓이게된다.
*      ASSIGN  er_data_changed->mp_mod_rows->* TO <fs>.     "mp_mod_rows DATA타입은 fs가 Assign될때 타입을 따라간다.
*mp_mod_rows = 추가하는 엔트리들이 들어오는곳.(어느타입인지도 모를 데이터들이 쌓이는곳), 필드심볼이assign되는순간 그 타입으로 바뀜.
*     <fs> = gt_sbook
*      IF sy-subrc EQ 0.
*        APPEND LINES OF <fs> TO gt_sbook.    "100번이 끝이면 101 102 103...으로 index하면서 데이터가 들어온다.
*        LOOP AT er_data_changed->mt_inserted_rows INTO ls_ins_cells.
*
*          READ TABLE gt_sbook INTO gs_sbook INDEX ls_ins_cells-row_id.
*          IF sy-subrc EQ 0.
*
*            PERFORM insert_parts USING er_data_changed
*                                          ls_ins_cells.
*
*          ENDIF.
*        ENDLOOP.
*      ENDIF.
*    ENDIF.
    "수정안
        LOOP AT er_data_changed->mt_inserted_rows INTO ls_ins_cells.

*          READ TABLE gt_sbook INTO gs_sbook INDEX ls_ins_cells-row_id.
*          IF sy-subrc EQ 0.
*
            PERFORM insert_parts USING er_data_changed
                                          ls_ins_cells.

*          ENDIF.
        ENDLOOP.

    ENDIF.



     "delete parts

    IF  er_data_changed->mt_DELETED_rows IS NOT INITIAL."지우는 부분

      LOOP AT er_data_changed->mt_DELETED_rows INTO ls_DEL_cells.

        READ TABLE gt_sbook INTO gs_sbook INDEX ls_DEL_cells-row_id.
        IF sy-subrc EQ 0.
          MOVE-CORRESPONDING gs_sbook TO dw_sbook.
          APPEND dw_sbook TO dl_sbook.  "dl_sbook = 화면에서만 사라지기때문에 지우는 대상이다 라고 따로 담아놓은것 , dl_sbook = 지우는 대상을 쌓아놓는곳이다.
        ENDIF.
      ENDLOOP.
    ENDIF.





  ENDMETHOD.

  METHOD on_data_changed_finish.
    "내가 체크하고 변경한애들만 나의 인터널테이블(gt_Sbook)에 기억하게 해놓으면된다.
    DATA : ls_mod_cells TYPE lvc_s_modi.

    CHECK e_modified = 'X'.   "check = 참일때 다음 로직을 수행해라?, 메소드 엔드메소드 안에서 참일때만 밑의 로직을 수행한다.거짓이면 빠저나간다.
                              "모디파이드가필요한 이유는 내가 변경한 라인이다 라고 마킹해주려고
                              "중간다리역할을하는 워크에이리어가 필요하다.
    LOOP AT et_good_cells INTO ls_mod_cells.

      PERFORM modify_check USING ls_mod_cells.

    ENDLOOP.

  ENDMETHOD.


ENDCLASS.
