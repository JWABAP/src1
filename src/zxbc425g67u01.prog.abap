*&---------------------------------------------------------------------*
*& Include          ZXBC425G67U01
*&---------------------------------------------------------------------*

IF flight-fldate < sy-datum.
  MESSAGE w011(bc425)WITH sy-datum.
ENDIF.
