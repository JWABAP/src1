*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVSA15VEN.......................................*
TABLES: ZVSA15VEN, *ZVSA15VEN. "view work areas
CONTROLS: TCTRL_ZVSA15VEN
TYPE TABLEVIEW USING SCREEN '0010'.
DATA: BEGIN OF STATUS_ZVSA15VEN. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSA15VEN.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSA15VEN_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSA15VEN.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA15VEN_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSA15VEN_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSA15VEN.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA15VEN_TOTAL.

*.........table declarations:.................................*
TABLES: ZTSA15VEN                      .
