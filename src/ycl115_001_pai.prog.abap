*&---------------------------------------------------------------------*
*& Include          YCL115_001_PAI
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  EXIT_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE EXIT_0100 INPUT.
  SAVE_OK = OK_CODE.
  CLEAR OK_CODE.

  CASE SAVE_OK.
    WHEN 'EXIT'.
      LEAVE PROGRAM.  "현재화면과 프로그램도 같이종료
    WHEN 'CANC'.
      LEAVE TO SCREEN 0. "LEAVE TO SCREEN = 현재화면을종료하면서 저쪽화면으로이동 0 = 이전화면
    WHEN OTHERS.
      OK_CODE = SAVE_OK.
    ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.
  SAVE_OK = OK_CODE.
  CLEAR OK_CODE.

  CASE SAVE_OK..
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN OTHERS.
      LEAVE PROGRAM.
   ENDCASE.
ENDMODULE.
