*&---------------------------------------------------------------------*
*& Include          ZSA1505_I01
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
        LEAVE PROGRAM.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'ENTER'.
      "get emp name
      PERFORM get_emp_name USING zssa0073-pernr
                           CHANGING zssa0073-ename.

    WHEN 'SEARCH'.
      "get emp name
      PERFORM get_emp_name USING zssa0073-pernr
                           CHANGING zssa0073-ename.

      "get Employee Info
      PERFORM get_emp_info USING zssa0073-pernr
                           CHANGING zssa0070.

    WHEN 'DEP'.  "Popup
      CALL SCREEN 0101 STARTING AT 10 10.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0101  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0101 INPUT.
  CASE sy-ucomm.
    WHEN 'CLOSE'.
      LEAVE TO SCREEN 0.
  ENDCASE.

  PERFORM get_dep_info.
ENDMODULE.
