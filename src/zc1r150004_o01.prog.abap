*&---------------------------------------------------------------------*
*& Include          ZC1R150004_O01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
 SET PF-STATUS 'S100'.
 SET TITLEBAR 'T100'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module DISPLAY_SCREEN OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE display_screen OUTPUT.
  perform display_screen.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module SET_FCAT_LAYOUT OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE set_fcat_layout OUTPUT.
  perform set_fcat_layout.
ENDMODULE.
