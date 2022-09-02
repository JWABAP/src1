*&---------------------------------------------------------------------*
*& Report ZC1R150005
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zc1r150005_top                          .    " Global Data
INCLUDE zc1r150005_c01                        .
INCLUDE zc1r150005_s01                          .  " Selection Screen
INCLUDE zc1r150005_o01                          .  " PBO-Modules
INCLUDE zc1r150005_i01                          .  " PAI-Modules
INCLUDE zc1r150005_f01                          .  " FORM-Routines

START-OF-SELECTION.
  PERFORM get_bom_data.

  CALL SCREEN '100'.
