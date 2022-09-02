*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZSAPLANE_A15....................................*
DATA:  BEGIN OF STATUS_ZSAPLANE_A15                  .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSAPLANE_A15                  .
CONTROLS: TCTRL_ZSAPLANE_A15
            TYPE TABLEVIEW USING SCREEN '0050'.
*...processing: ZSCARR_A15......................................*
DATA:  BEGIN OF STATUS_ZSCARR_A15                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSCARR_A15                    .
CONTROLS: TCTRL_ZSCARR_A15
            TYPE TABLEVIEW USING SCREEN '0021'.
*...processing: ZSFLIGHT_A15....................................*
DATA:  BEGIN OF STATUS_ZSFLIGHT_A15                  .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSFLIGHT_A15                  .
CONTROLS: TCTRL_ZSFLIGHT_A15
            TYPE TABLEVIEW USING SCREEN '0017'.
*...processing: ZSPFLI_A15......................................*
DATA:  BEGIN OF STATUS_ZSPFLI_A15                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSPFLI_A15                    .
CONTROLS: TCTRL_ZSPFLI_A15
            TYPE TABLEVIEW USING SCREEN '0031'.
*.........table declarations:.................................*
TABLES: *ZSAPLANE_A15                  .
TABLES: *ZSCARR_A15                    .
TABLES: *ZSFLIGHT_A15                  .
TABLES: *ZSPFLI_A15                    .
TABLES: ZSAPLANE_A15                   .
TABLES: ZSCARR_A15                     .
TABLES: ZSFLIGHT_A15                   .
TABLES: ZSPFLI_A15                     .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
