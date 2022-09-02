*&---------------------------------------------------------------------*
*& Include          ZBC_405_A15_O01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
 IF p_edit = 'X'.
 SET PF-STATUS 'T100'.
 ELSE.
   SET PF-STATUS 'T100' EXCLUDING 'SAVE'.
 ENDIF.
 SET TITLEBAR 'T10' WITH sy-datum sy-uname.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CREATE_ALV_OBJECT OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE create_alv_object OUTPUT.
  IF go_container IS INITIAL.
    CREATE OBJECT go_container
      EXPORTING
        container_name = 'MY_CONTROL_AREA'.

    IF sy-subrc EQ 0.
      CREATE OBJECT go_alv
        EXPORTING
          i_parent = go_container.

     IF sy-subrc EQ 0.



       PERFORM set_variant.
       PERFORM set_layout.
       PERFORM make_fcat.
       PERFORM exclude_button.

*-----이벤트 트리거-----*
       SET HANDLER lcl_handler=>on_toolbar               FOR go_alv.
       SET HANDLER lcl_handler=>on_usercommand           FOR go_alv.
       SET HANDLER lcl_handler=>on_before_user_com       FOR go_alv.
       SET HANDLER lcl_handler=>on_doubleclick           FOR go_alv.

*-----이벤트 트리거-----*



       CALL METHOD go_alv->set_table_for_first_display
         EXPORTING
*           i_buffer_active               =
*           i_bypassing_buffer            =
*           i_consistency_check           =
           i_structure_name              = 'ZTSPFLI_A15'
           is_variant                    = gs_variant
           i_save                        = 'A'
           i_default                     = 'X'
           is_layout                     = gs_layout
*           is_print                      =
*           it_special_groups             =
           it_toolbar_excluding          = gt_exct      "툴바 버튼들 지우기
*           it_hyperlink                  =
*           it_alv_graphics               =
*           it_except_qinfo               =
*           ir_salv_adapter               =
         CHANGING
           it_outtab                     = gt_spfli
           it_fieldcatalog               = gt_fcat
*           it_sort                       = gt_sort
*           it_filter                     =
         EXCEPTIONS
           invalid_parameter_combination = 1
           program_error                 = 2
           too_many_lines                = 3
           OTHERS                        = 4.
       IF sy-subrc <> 0.
*        Implement suitable error handling here
       ENDIF.




     ENDIF.

    ENDIF.
  ELSE.
    gv_soft_refresh = 'X'.
    gs_stable-row = 'X'.
    gs_stable-col = 'X'.

    CALL METHOD go_alv->refresh_table_display
      EXPORTING
        is_stable      = gs_stable
        i_soft_refresh = gv_soft_refresh
      EXCEPTIONS
        finished       = 1
        OTHERS         = 2.
    IF sy-subrc <> 0.
*     Implement suitable error handling here
    ENDIF.
*    CALL METHOD cl_gui_cfw=>flush.


  ENDIF.

ENDMODULE.
