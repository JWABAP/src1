*&---------------------------------------------------------------------*
*& Module Pool      SAPMZSA1505
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zsa1506_top.
*INCLUDE zsa1505_top                             .    " Global Data

INCLUDE zsa1506_o01.
* INCLUDE zsa1505_o01                             .  " PBO-Modules
INCLUDE zsa1506_i01.
* INCLUDE zsa1505_i01                             .  " PAI-Modules
INCLUDE zsa1506_f01.
* INCLUDE zsa1505_f01                             .  " FORM-Routines

 LOAD-OF-PROGRAM.
  PERFORM set_default CHANGING zssa0073.
  CLEAR: gv_r1, gv_r2, gv_r3.
  gv_r2 = 'X'.
