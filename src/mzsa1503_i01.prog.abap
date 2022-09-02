*&---------------------------------------------------------------------*
*& Include          MZSA1503_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'CANC'.
      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
      WHEN 'SEARCH'.

        CALL SCREEN 200.
        MESSAGE i000(zmcsa15) WITH'CALL'.
        PERFORM get_airline_name USING gv_carrid
                                 CHANGING gv_carrname.

*        PERFORM get_airline_name USING gv_carrid
*                                 CHANGING gv_carrname.
*         SET SCREEN 200.

  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0200 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK'.
       LEAVE TO SCREEN 0.
*      CALL SCREEN 100.
*      SET SCREEN 100.
*      MESSAGE i100(zmcsa15) WITH 'BACK'.
*      LEAVE SCREEN.

*      LEAVE TO SCREEN 100.
  ENDCASE.
ENDMODULE.
