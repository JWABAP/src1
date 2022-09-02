*&---------------------------------------------------------------------*
*& Include          ZBC_405_A15_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  DATA : p_ans TYPE c LENGTH 1.

  CASE ok_code.

    WHEN 'SAVE'.
      PERFORM data_save.

  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.
    LEAVE TO SCREEN 0.
ENDMODULE.
