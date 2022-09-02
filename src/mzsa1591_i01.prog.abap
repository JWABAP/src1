*&---------------------------------------------------------------------*
*& Include          MZSA1590_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'ENTER'.
      "Get Airline Name
     PERFORM get_airline_name USING zssa1590-carrid
                              CHANGING zssa1590-carrname.

      "Get Meal Text
     PERFORM get_meal_text USING zssa1590-carrid
                                  zssa1590-mealnumber
                                  sy-langu
                            CHANGING zssa1590-mealnumber_t.
    WHEN 'SEARCH'.

      PERFORM get_meal_info USING zssa1590-carrid
                                  zssa1590-mealnumber
                            CHANGING zssa1591.
      PERFORM get_vendor_info USING 'M'
                                    zssa1590-carrid
                                    zssa1590-mealnumber
                              CHANGING zssa1593.

  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.
  CASE ok_code.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'CANC'.
      LEAVE TO SCREEN 0.

  ENDCASE.
ENDMODULE.
