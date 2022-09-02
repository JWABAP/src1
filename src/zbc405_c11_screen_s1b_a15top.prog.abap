*&---------------------------------------------------------------------*
*&  Include BC405_INTRO_S1_TOP                                         *
*&---------------------------------------------------------------------*

TABLES: sscrfields.     "ok_code로도 사용가능
DATA: gs_flight TYPE dv_flights.

DATA gv_change.

CONSTANTS gc_mark VALUE 'x'.

SELECTION-SCREEN BEGIN OF SCREEN 1100 AS SUBSCREEN.

SELECT-OPTIONS: so_car FOR gs_flight-carrid MEMORY ID car,
                so_con FOR gs_flight-connid.

SELECTION-SCREEN END OF SCREEN 1100.

SELECTION-SCREEN BEGIN OF SCREEN 1200 AS SUBSCREEN.

SELECT-OPTIONS so_fdt FOR gs_flight-fldate NO-EXTENSION.

SELECTION-SCREEN END OF SCREEN 1200.

SELECTION-SCREEN BEGIN OF SCREEN 1300 AS SUBSCREEN.
SELECTION-SCREEN BEGIN OF BLOCK rg WITH FRAME.

  PARAMETERS : bt_all RADIOBUTTON GROUP rd1,

               bt_dome RADIOBUTTON GROUP rd1,

               bt_int RADIOBUTTON GROUP rd1 DEFAULT 'X'.

SELECTION-SCREEN END OF BLOCK rg.
SELECTION-SCREEN END OF SCREEN 1300.

*-----------1400 서브스크린생성------------------
SELECTION-SCREEN BEGIN OF SCREEN 1400 AS SUBSCREEN.
  SELECT-OPTIONS : s_cofr FOR gs_flight-countryfr MODIF ID det,
                   s_cifr FOR gs_flight-cityfrom MODIF ID det.

  SELECTION-SCREEN SKIP 2.
  SELECTION-SCREEN PUSHBUTTON 2(10) push_but USER-COMMAND deta.

SELECTION-SCREEN END OF SCREEN 1400.
*-------Tab4 추가-----------------------------


SELECTION-SCREEN BEGIN OF TABBED BLOCK airlines

  FOR 5 LINES.
  SELECTION-SCREEN TAB (20) tab1 USER-COMMAND conn DEFAULT SCREEN 1100.
  SELECTION-SCREEN TAB (20) tab2 USER-COMMAND date DEFAULT SCREEN 1200.
  SELECTION-SCREEN TAB (20) tab3 USER-COMMAND type DEFAULT SCREEN 1300.
  SELECTION-SCREEN TAB (20) tab4 USER-COMMAND cont DEFAULT SCREEN 1400.

SELECTION-SCREEN END OF BLOCK airlines.
