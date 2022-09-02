*&---------------------------------------------------------------------*
*& Report ZC1R150003
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zc1r150003.

TABLES: mara, marc.

SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-t01.
  PARAMETERS: pa_werks TYPE mkal-werks DEFAULT '1010',
              pa_berid TYPE pbid-berid DEFAULT '1010',
              pa_pbdnr TYPE pbid-pbdnr,
              pa_versb TYPE pbid-versb DEFAULT '00'.
SELECTION-SCREEN END OF BLOCK bl1.

SELECTION-SCREEN BEGIN OF BLOCK bl2 WITH FRAME TITLE TEXT-t02.
  PARAMETERS: pa_crt  RADIOBUTTON GROUP rb1 DEFAULT 'X' USER-COMMAND mod, "Type R(라디오박스),체크되면 MARC필드가 보이지않게하기
              "유저커맨드하는순간 이벤트가 발생한다.
              pa_disp RADIOBUTTON GROUP rb1.                              "Type R(라디오박스),체크되면 MARA필드가 보이지않게하기
SELECTION-SCREEN END OF BLOCK bl2.

*-----라디오버튼 1을 체크했을때 mara필드가 보이지않게, 2를체크했을대 marc필드가보이지않게 와 같은상황에는 modif id를 주어서 한번에 변경이 가능하게 해 줄 수 있다.
SELECTION-SCREEN BEGIN OF BLOCK bl3 WITH FRAME TITLE TEXT-t03.
  SELECT-OPTIONS : so_matnr FOR  mara-matnr MODIF ID mar,         "Type S(셀렉션스크린)
                   so_mtart FOR  mara-mtart MODIF ID mar,         "Type S(셀렉션스크린)
                   so_matkl FOR  mara-matkl MODIF ID mar,         "Type S(셀렉션스크린)
                   so_ekgrp FOR  marc-ekgrp MODIF ID mac.         "Type S(셀렉션스크린)
  PARAMETERS     : pa_dispo TYPE marc-dispo MODIF ID mac,         "Type P(파라미터)
                   pa_dismm TYPE marc-dismm MODIF ID mac.         "Type P(파라미터)
SELECTION-SCREEN END OF BLOCK bl3.

AT SELECTION-SCREEN OUTPUT.   "화면이 나오기전에 작업
  PERFORM modify-screen.
*&---------------------------------------------------------------------*
*& Form modify-screen
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM modify-screen.

  LOOP AT SCREEN.

    CASE screen-name.       "Screen-name대신 modif id를 써도 된다.
      WHEN 'PA_PBDNR' OR 'PA_VERSB'.
        screen-input = 0. "입력끄기(Display Mode)
        MODIFY SCREEN.    "스크린도 반드시 modify해서 반영을해줘야한다.(스크린의 속성값을 바꾼다면 반드시 MODIFY SCREEN을 해줘야한다.)
    ENDCASE.

    CASE 'X'.
      WHEN pa_crt.

        CASE screen-group1.          "액티브에 속성을줘서 보이고 안보이고 할때에는 group으로 주는게 가장 좋다.(name으로 하면 뭐 다 찾아야함)
          WHEN 'MAC'.
            screen-active = 0.
            MODIFY SCREEN.
        ENDCASE.

      WHEN pa_disp.
        CASE screen-group1.
          WHEN 'MAR'.
            screen-active = 0.
            MODIFY SCREEN.
        ENDCASE.

    ENDCASE.

  ENDLOOP.

ENDFORM.
