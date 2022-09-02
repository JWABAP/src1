*&---------------------------------------------------------------------*
*& Report ZC1R150007
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zc1r150007_top                          .    " Global Data

INCLUDE zc1r150007_s01                          .  " Selection Screen
INCLUDE zc1r150007_c01                          .  " Local Class
INCLUDE zc1r150007_o01                          .  " PBO-Modules
INCLUDE zc1r150007_i01                          .  " PAI-Modules
INCLUDE zc1r150007_f01                          .  " FORM-Routines

INITIALIZATION.
  PERFORM init_param.

  "REPORT프로그램에서 실질적인로직이 시작된다.
START-OF-SELECTION.
  PERFORM get_belnr.

  CALL SCREEN '100'.      "ALV선언다음 스크린만들기
