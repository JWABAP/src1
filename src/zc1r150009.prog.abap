*&---------------------------------------------------------------------*
*& Report ZC1R150005
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE ZC1R150009_TOP.
*INCLUDE zc1r150005_top                          .    " Global Data
INCLUDE ZC1R150009_C01.
*INCLUDE zc1r150005_c01                        .
INCLUDE ZC1R150009_S01.
*INCLUDE zc1r150005_s01                          .  " Selection Screen
INCLUDE ZC1R150009_O01.
*INCLUDE zc1r150005_o01                          .  " PBO-Modules
INCLUDE ZC1R150009_I01.
*INCLUDE zc1r150005_i01                          .  " PAI-Modules
INCLUDE ZC1R150009_F01.
*INCLUDE zc1r150005_f01                          .  " FORM-Routines

START-OF-SELECTION.
  PERFORM get_bom_data.

  CALL SCREEN '100'.
