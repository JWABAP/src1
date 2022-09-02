*&---------------------------------------------------------------------*
*& Include          MZSA1502_O01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
 SET PF-STATUS 'S100'.
 SET TITLEBAR 'T100' WITH sy-datum.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module SET_DEFAULT OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE set_default OUTPUT.
 IF zssa1560 IS INITIAL.  "zssa1560이 이니셜 밸류값이면
 zssa1560-carrid = 'AA'.
 zssa1560-connid = '0017'.
 ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module MODIFY_SCREEN_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE modify_screen_0100 OUTPUT.

   LOOP AT SCREEN.
     CASE screen-group1.
       WHEN 'GR1'.
         screen-active = 0.
     ENDCASE.
     MODIFY SCREEN.
   ENDLOOP.

*  LOOP AT SCREEN.
*    CASE screen-name.
*      WHEN 'ZSSA1560-CARRID'.
*        IF sy-uname <> 'KD-A-15'.
**          screen-input = 0.      "0은 인풋모드를 사용하지 않겠다는것이다.
*           screen-active = 0.   "액티브는 존재가치가 있냐 없냐를 따지는것(화면에 보일 필요가 있냐 없냐 라는것이다)
*        ELSE.
*          screen-input = 1.
*          screen-active = 1.
*        ENDIF.
*    ENDCASE.
*
*    MODIFY SCREEN.
*    CLEAR screen.
*  ENDLOOP.

ENDMODULE.
