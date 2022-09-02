*&---------------------------------------------------------------------*
*& Include          ZC1R150007_C01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Class lcl_event_handler
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION FINAL.
PUBLIC SECTION.
  methods : "인스턴스
    handle_hotspot for event hotspot_click of cl_gui_alv_grid
      importing
        e_row_id
        e_column_id.

ENDCLASS.
*&---------------------------------------------------------------------*
*& Class (Implementation) lcl_event_handler
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.

  METHOD handle_hotspot.

    perform handle_hotspot using e_row_id e_column_id.

  ENDMETHOD.

ENDCLASS.
