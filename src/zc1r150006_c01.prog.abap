*&---------------------------------------------------------------------*
*& Include          ZC1R150006_C01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Class lcl_event_handler
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION FINAL.   "FINAL = 나로끝
  PUBLIC SECTION.
    CLASS-METHODS :
      handle_double_click FOR EVENT double_click OF cl_gui_alv_grid
        IMPORTING
          e_row
          e_column.

ENDCLASS.
*&---------------------------------------------------------------------*
*& Class (Implementation) lcl_event_handler
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.

  METHOD handle_double_click.

    PERFORM handle_double_click USING e_row  e_column.

  ENDMETHOD.
ENDCLASS.
