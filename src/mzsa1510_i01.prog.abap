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
    when 'TAB1' or 'TAB2'.
      ts_info-activetab = ok_code.

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
*&---------------------------------------------------------------------*
*& Module SET_TS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE set_ts_0100 OUTPUT.
  CASE ts_info-activetab.
    WHEN 'TAB1'.
      gv_dynnr = '0101'.
    WHEN 'TAB2'.
      gv_dynnr = '0102'.
    WHEN OTHERS.  "default
      gv_dynnr = '0102'.
      ts_info-activetab = 'TAB2'.
  ENDCASE.
ENDMODULE.
