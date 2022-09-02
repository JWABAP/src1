*&---------------------------------------------------------------------*
*& Include          MZSA1502_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code. "sy-ucomm.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'CANC'.
      LEAVE TO SCREEN 0.
      WHEN 'BACK'.
        SET SCREEN 0.
        LEAVE SCREEN.
  ENDCASE.
ENDMODULE.
