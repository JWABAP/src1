*&---------------------------------------------------------------------*
*& Report ZC1R150010
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zc1r150010_top                          .    " Global Data

INCLUDE zc1r150010_c01                          .  " Local Class
INCLUDE zc1r150010_s01                          .  " Selection Screen
INCLUDE zc1r150010_o01                          .  " PBO-Modules
INCLUDE zc1r150010_i01                          .  " PAI-Modules
INCLUDE zc1r150010_f01                          .  " FORM-Routines

START-OF-SELECTION.             "REPORT프로그램에서 실질적으로 로직이 실행되는곳.
  PERFORM get_emp_data.
  PERFORM set_style.

  CALL SCREEN '100'.
