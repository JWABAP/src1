*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVSA1503........................................*
TABLES: ZVSA1503, *ZVSA1503. "view work areas
CONTROLS: TCTRL_ZVSA1503
TYPE TABLEVIEW USING SCREEN '0010'.
DATA: BEGIN OF STATUS_ZVSA1503. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSA1503.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSA1503_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSA1503.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA1503_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSA1503_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSA1503.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA1503_TOTAL.

*...processing: ZVSA1504........................................*
TABLES: ZVSA1504, *ZVSA1504. "view work areas
CONTROLS: TCTRL_ZVSA1504
TYPE TABLEVIEW USING SCREEN '0020'.
DATA: BEGIN OF STATUS_ZVSA1504. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSA1504.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSA1504_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSA1504.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA1504_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSA1504_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSA1504.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA1504_TOTAL.

*...processing: ZVSA1599........................................*
TABLES: ZVSA1599, *ZVSA1599. "view work areas
CONTROLS: TCTRL_ZVSA1599
TYPE TABLEVIEW USING SCREEN '0030'.
DATA: BEGIN OF STATUS_ZVSA1599. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSA1599.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSA1599_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSA1599.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA1599_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSA1599_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSA1599.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA1599_TOTAL.

*...processing: ZVSA15PRO.......................................*
TABLES: ZVSA15PRO, *ZVSA15PRO. "view work areas
CONTROLS: TCTRL_ZVSA15PRO
TYPE TABLEVIEW USING SCREEN '0040'.
DATA: BEGIN OF STATUS_ZVSA15PRO. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSA15PRO.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSA15PRO_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSA15PRO.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA15PRO_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSA15PRO_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSA15PRO.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA15PRO_TOTAL.

*.........table declarations:.................................*
TABLES: ZTSA1501                       .
TABLES: ZTSA1503                       .
TABLES: ZTSA1503_T                     .
TABLES: ZTSA1599                       .
TABLES: ZTSA15PRO                      .
TABLES: ZTSA15PRO_T                    .
