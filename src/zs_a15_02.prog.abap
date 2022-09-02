*&---------------------------------------------------------------------*
*& Report ZS_A15_02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zs_a15_02.

*TABLES:sbook.
*DATA: lv_tabix TYPE sy-tabix.
*
*SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.
*  PARAMETERS    : pa_caid  TYPE sbook-carrid OBLIGATORY DEFAULT 'AA'.
*  SELECT-OPTIONS: s_conid  FOR sbook-connid OBLIGATORY.
*  PARAMETERS    : pa_cus   TYPE sbook-custtype OBLIGATORY AS LISTBOX VISIBLE LENGTH 10.
*  SELECT-OPTIONS: s_fldate FOR sbook-fldate DEFAULT sy-datum.
*  SELECT-OPTIONS: s_bid    FOR sbook-bookid.
*  SELECT-OPTIONS: s_cid    FOR sbook-customid NO INTERVALS NO-EXTENSION.   "High, Multi Selection 숨기기
*SELECTION-SCREEN END OF BLOCK b1.
*
*DATA: BEGIN OF gs_sbook,
*        carrid   TYPE sbook-carrid,
*        connid   TYPE sbook-connid,
*        fldate   TYPE sbook-fldate,
*        bookid   TYPE sbook-bookid,
*        customid TYPE sbook-customid,
*        custtype TYPE sbook-custtype,
*        invoice  TYPE sbook-invoice,
*        class    TYPE sbook-class,
*      END OF gs_sbook.
*DATA : gt_sbook LIKE TABLE OF gs_sbook.
*
*SELECT carrid connid fldate bookid customid custtype invoice class
*  FROM sbook
*  INTO CORRESPONDING FIELDS OF TABLE gt_sbook
* WHERE carrid   = pa_caid
*   AND connid   in s_conid   "SELECT-OPTIONS는 =대신 in을 써야한다.
*   AND custtype = pa_cus
*   AND fldate   in s_fldate  "SELECT-OPTIONS는 =대신 in을 써야한다.
*   AND bookid   in s_bid     "SELECT-OPTIONS는 =대신 in을 써야한다.
*   AND customid in s_cid.    "SELECT-OPTIONS는 =대신 in을 써야한다.
*
*IF sy-subrc EQ 0.
*  "인터널테이블의 내용을변경하려면 무조건 loop를하거나 read table을 해야한다.
*  LOOP AT gt_sbook INTO gs_sbook.     "테이블에 있는 데이터를 스트럭처에서 변경 후 modify로 다시 테이블에 값을 변경하는과정
*
*    lv_tabix = sy-tabix.
*
*    CASE gs_sbook-invoice.
*      WHEN 'X'.
*        gs_sbook-class = 'F'.
*    ENDCASE.
*
*    MODIFY gt_sbook FROM gs_sbook INDEX lv_tabix TRANSPORTING class.
*
*  ENDLOOP.
*   cl_demo_output=>display_data( gt_sbook ).
*ELSEIF gt_sbook IS INITIAL.
*  MESSAGE i016(pn) WITH 'Data is not found'.
*ENDIF.
**-----내가한거(성공)

TABLES: sbook.
DATA: gv_tabix TYPE sy-tabix.

SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-t01.
  PARAMETERS     : pa_carr  TYPE sbook-carrid   OBLIGATORY DEFAULT 'AA'.
  SELECT-OPTIONS : so_conn  FOR  sbook-connid   OBLIGATORY.
  PARAMETERS     : pa_cutyp TYPE sbook-custtype OBLIGATORY
                   AS LISTBOX VISIBLE LENGTH 20 DEFAULT 'P'.

  SELECT-OPTIONS : so_fldt  FOR sbook-fldate DEFAULT sy-datum,
                   so_bkid  FOR sbook-bookid,
                   so_cusid FOR sbook-customid NO INTERVALS NO-EXTENSION.
SELECTION-SCREEN END OF BLOCK bl1.

DATA: BEGIN OF gs_data,
        carrid   TYPE sbook-carrid,
        connid   TYPE sbook-connid,
        fldate   TYPE sbook-fldate,
        bookid   TYPE sbook-bookid,
        customid TYPE sbook-customid,
        custtype TYPE sbook-custtype,
        invoice  TYPE sbook-invoice,
        class    TYPE sbook-class,
      END OF gs_data,

      gt_data LIKE TABLE OF gs_data.

REFRESH gt_data.

SELECT carrid connid fldate bookid customid custtype invoice class
  INTO CORRESPONDING FIELDS OF TABLE gt_data
  FROM sbook
 WHERE carrid   =  pa_carr
   AND connid   IN so_conn      "selectoptions의 논리연산자는 in이다.
   AND custtype =  pa_cutyp
   AND fldate   IN so_fldt
   AND bookid   IN so_bkid
   AND customid IN so_cusid.

"사용자를위해서 메시지를 띄우는것이 좋다.
IF sy-subrc NE 0.
  MESSAGE i000(pn) with'Data found'.
  LEAVE LIST-PROCESSING. "STOP
ENDIF.

LOOP AT gt_data INTO gs_data.    "헤더가없기때문에 데이터를 받아줄 스트럭쳐가 필요해서 into gs_data를 하는것이다.

  gv_tabix = sy-tabix.

  CASE gs_data-invoice.
    WHEN 'X'.
      gs_data-class = 'F'.

      MODIFY gt_data FROM gs_data INDEX gv_tabix
      TRANSPORTING class.
  ENDCASE.

ENDLOOP.
cl_demo_output=>display_data( gt_data ).
