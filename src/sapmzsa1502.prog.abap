*&---------------------------------------------------------------------*
*& Module Pool      SAPMZSA1502
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE mzsa1502_top                            .    " Global Data

 INCLUDE mzsa1502_o01                            .  " PBO-Modules
 INCLUDE mzsa1502_i01                            .  " PAI-Modules
 INCLUDE mzsa1502_f01                            .  " FORM-Routines

 LOAD-OF-PROGRAM.
  PERFORM set_default.
