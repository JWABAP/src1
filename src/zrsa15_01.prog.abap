*&---------------------------------------------------------------------*
*& Report ZRSA15_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa15_01.

PARAMETERS pa_carr TYPE scarr-carrid.
*PARAMETERS pa_carr TYPE c LENGTH 3.

DATA gs_scarr TYPE scarr.

SELECT SINGLE *
  FROM scarr
  INTO gs_scarr
  WHERE carrid = pa_carr.
  IF sy-subrc = 0.
    NEW-LINE.
    WRITE: gs_scarr-carrid,
           gs_scarr-carrname,
           gs_scarr-url.
    ELSE.
      WRITE 'Sorry, no data found!'(t01).
*      MESSAGE 'Sorry, no data found!' TYPE'i'.
      ENDIF.
