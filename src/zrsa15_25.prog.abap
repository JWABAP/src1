*&---------------------------------------------------------------------*
*& Report ZRSA15_25
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zrsa15_25_top                           .    " Global Data

* INCLUDE ZRSA15_25_O01                           .  " PBO-Modules
* INCLUDE ZRSA15_25_I01                           .  " PAI-Modules
INCLUDE zrsa15_25_f01                           .  " FORM-Routines

INITIALIZATION.

AT SELECTION-SCREEN OUTPUT.

AT SELECTION-SCREEN.

START-OF-SELECTION.

PERFORM get_info.

cl_demo_output=>display_data( gt_info ).
