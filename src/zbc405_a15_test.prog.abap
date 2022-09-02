*&---------------------------------------------------------------------*
*& Report ZBC405_A15_TEST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zbc_405_a15_top                         .    " Global Data

 INCLUDE zbc_405_a15_o01                         .  " PBO-Modules
 INCLUDE zbc_405_a15_i01                         .  " PAI-Modules
 INCLUDE zbc_405_a15_f01                         .  " FORM-Routines

 AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_layout.    "p_layout F4활성화

   CALL FUNCTION 'LVC_VARIANT_SAVE_LOAD'
    EXPORTING
      i_save_load = 'F'           "S: Save L : Load F: F4
    CHANGING
      cs_variant  = gs_variant.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ELSE.
    p_layout = gs_variant-variant.
  ENDIF.
