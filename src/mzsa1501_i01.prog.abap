*&---------------------------------------------------------------------*
*& Include          MZSA1501_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.  "user command의 약자
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'BACK' OR 'CANC'.
*      leave to screen 0.         "0의의미는 이전화면으로 라는 뜻이다.leave는 떠나라=이전화면으로 떠나라 라는뜻
      SET SCREEN 0.
      LEAVE SCREEN.

      WHEN 'SEARCH'.
        " Get Data
        PERFORM get_data USING gv_pno
                         CHANGING zssa1531.



*        MESSAGE s000(zmcsa00) WITH sy-ucomm.
  ENDCASE.
ENDMODULE.
