*&---------------------------------------------------------------------*
*& Module Pool      SAPMZSA1505
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zsa1505_top                             .    " Global Data

 INCLUDE zsa1505_o01                             .  " PBO-Modules
 INCLUDE zsa1505_i01                             .  " PAI-Modules
 INCLUDE zsa1505_f01                             .  " FORM-Routines

 LOAD-OF-PROGRAM.
  PERFORM set_default CHANGING zssa0073.
