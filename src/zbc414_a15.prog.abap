*&---------------------------------------------------------------------*
*& Report ZBC414_T03
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc414_a15.

**TABLES : reposrc.
**
*PARAMETERS : p_var type PROGNAME OBLIGATORY.
*
*
*UPDATE reposrc SET   uccheck = 'X'
*                     WHERE progname = p_var.
*

*tables : indx.
*
*select-options : area for indx-relid, =
*                 clstr_id for indx-srtfd.


TABLES : zspfli_t03.

DATA : gt_tab TYPE TABLE OF zspfli_t03,
       gs_tab TYPE zspfli_t03.



gs_tab-carrid = 'LH'.
gs_tab-connid = '0555'.
gs_tab-cityto = 'ROME'.

APPEND gs_tab TO gt_tab.


gs_tab-carrid = 'LH'.
gs_tab-connid = '0789'.
gs_tab-cityto = 'TOKYO'.

APPEND gs_tab TO gt_tab.

gs_tab-carrid = 'LH'.
gs_tab-connid = '0064'.
gs_tab-cityto = 'SAN FRANCISCO'.


APPEND gs_tab TO gt_tab.


gs_tab-carrid = 'LH'.
gs_tab-connid = '0400'.
gs_tab-cityto = 'NEW YORK'.

APPEND gs_tab TO gt_tab.



INSERT zspfli_t03 FROM TABLE gt_tab
           ACCEPTING DUPLICATE KEYS.
WRITE :/ 'sy-subrc:', sy-subrc, 'sy-dbcnt:', sy-dbcnt.
* sy-subrc = 0 ===> success
* sy-subrc = 4 ===> 중복 안되는것만 insert . 부분 성공...
*-- sy-dbcnt 제대로 insert된 갯수.
