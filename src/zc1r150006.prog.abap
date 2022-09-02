*&---------------------------------------------------------------------*
*& Report ZC1R150006
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zc1r150006_top                          .  " Global Data

INCLUDE ZC1R150006_s01                          .  " Selection Screen
INCLUDE ZC1R150006_c01                          .  " Local Class
INCLUDE zc1r150006_o01                          .  " PBO-Modules
INCLUDE zc1r150006_i01                          .  " PAI-Modules
INCLUDE zc1r150006_f01                          .  " FORM-Routines

START-OF-SELECTION.
  PERFORM get_flight_list.
  PERFORM set_carrname.

  CALL SCREEN '100'.
