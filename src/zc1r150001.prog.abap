*&---------------------------------------------------------------------*
*& Report ZC1R150001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zc1r150001_top                          .    " Global Data

INCLUDE zc1r150001_s01                          .  " Selection Screen
INCLUDE zc1r150001_o01                          .  " PBO-Modules
INCLUDE zc1r150001_i01                          .  " PAI-Modules
INCLUDE zc1r150001_f01                          .  " FORM-Routines

INITIALIZATION.
  PERFORM init_parameter.

START-OF-SELECTION.
  PERFORM get_data.

  CALL SCREEN '0100'.
