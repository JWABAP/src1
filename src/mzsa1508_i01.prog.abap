*&---------------------------------------------------------------------*
*& Include          MZSA1508_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.    "sy-ucomm.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'SEARCH'.

      "Get Condition Info
      PERFORM get_conn_info USING zssa1580-carrid
                                  zssa1580-connid
                            CHANGING zssa1582
                                     gv_subrc.

      IF gv_subrc <> 0.
        MESSAGE i016(pn) WITH 'Data is not found'.
        RETURN.
      ENDIF.

    WHEN 'ENTER'.




  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.
  CASE sy-ucomm.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'CANC'.
      LEAVE TO SCREEN 0.
   ENDCASE.
ENDMODULE.
