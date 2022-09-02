*&---------------------------------------------------------------------*
*& Report ZS_A15
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zs_a15.

*DATA:
*      gv_string TYPE c LENGTH 20,
*      gv_decimal TYPE p LENGTH 5 DECIMALS 2,
*      gv_numeric TYPE n LENGTH 8,
*      gv_english TYPE c LENGTH 10,
*      gv_number TYPE n LENGTH 10,
*      gv_num TYPE i,
*      gv_decimal2 LIKE gv_decimal.
*
*      gv_string = '00000000000000'.
*      gv_decimal = '1.25'.
*WRITE :  gv_string,
*        / gv_decimal,
*        / gv_numeric,
*        / gv_english,
*        / gv_number.
*
*
*DATA : gs_str TYPE ztsa1601,         "ZTSA본인번호+01 테이블을 참조하는 스트럭쳐 선언
*       gt_int LIKE gs_str.           "위에서 선언한 스트럭쳐를 참조하는 인터널테이블 선언
*
*DATA: BEGIN OF gv_strc,
*  matnr  TYPE mara-matnr,
*  werks  TYPE marc-werks,
*  mtart  TYPE mara-mtart,
*  matkl  TYPE mara-matkl,
*  ekgrp  TYPE marc-ekgrp,
*  pstat  TYPE marc-pstat.
*DATA: END OF gv_strc.
*
*DATA: gt_internal LIKE TABLE OF gv_strc.   "위에서 선언한 스트럭쳐를 참조하는 인터널테이블 선언
*
*
*DATA : gs_sbook TYPE sbook,           "테이블 sbook의 구조를 가진 로컬스트럭쳐선언
*       gt_sbook TYPE TABLE OF sbook,  "sbook의 구조를 가진 인터널테이블 선언
*       lv_tabix TYPE sy-tabix.
*
*CLEAR: gs_sbook.
*REFRESH gt_sbook.
*
*SELECT carrid connid fldate bookid customid custtype invoice class smoker
*  FROM sbook
*  INTO CORRESPONDING FIELDS OF TABLE gt_sbook  "field of 까지만하면 한 라인만 가져온다. table을붙으면 여러개 다 가져옴.
* WHERE carrid     = 'DL'
*   AND custtype   = 'P'
*   AND order_date = '20201227'.   ".을 넣게되면 2020.12.27 10자리가 되기때문에 .을빼고넣는다.
*
*  IF sy-subrc NE 0.     "0이 아니면
*    MESSAGE i016(pn).
*    LEAVE LIST-PROCESSING. "ALV에서 스크린 콜 전까지가 리스트 프로세싱이라고보면된다.(LEAVE LIST-PROCESSING = STOP이랑 똑같다.)
*  ENDIF.
*
*  LOOP AT gt_sbook INTO gs_sbook.
*
*    lv_tabix = sy-tabix.
*
*    "if문을 써도되지만 if문으로 case 변경이 가능할 경우에는 가독성 향상을위해서 case문을 사용하기.
*    CASE gs_sbook-smoker.
*      WHEN 'X'.
*
*       CASE gs_sbook-invoice.
*         WHEN 'X'.
*           gs_sbook-class = 'F'.
*
*           MODIFY gt_sbook FROM gs_sbook INDEX lv_tabix     "반드시 몇번째를 변경할것인지 지정해주어야한다.
*           TRANSPORTING class.   "다른클래스말고 지금 클래스만 바꾸고있기 때문에 정확히 지정을 해주는게 좋다.
*      ENDCASE.
*
*    ENDCASE.
*
*  ENDLOOP.
*
*  cl_demo_output=>display_data( gt_sbook ).

"필드들을 가진 로컬스트럭쳐 선언
*DATA : BEGIN OF gs_sflight.
*DATA : carrid     TYPE sflight-carrid,
*       connid     TYPE sflight-connid,
*       fldate     TYPE sflight-fldate,
*       currency   TYPE sflight-currency,
*       planetype  TYPE sflight-planetype,
*       seatsocc_b TYPE sflight-seatsocc_b.
*DATA : END OF gs_sflight,
*
*gt_sflight LIKE TABLE OF gs_sflight.     "필드들을가진 인터널테이블 선언, TYPE이아닌 LIKE인 이유는
*                                         "TYPE은 선언이 이미 되있어야 사용가능하기때문이다
*
*DATA : lv_tabix TYPE sy-tabix.
*
*
**--Select문을 통해서 레코드 선택하는 과정
*SELECT carrid connid fldate currency planetype seatsocc_b
*FROM sflight
*INTO CORRESPONDING FIELDS OF TABLE gt_sflight
*WHERE currency  = 'USD'                "조건,통화단위가 USD인것
*  AND planetype = '747-400'.
*
*"loop문을 돌려서 레코드에 값 넣기.
*LOOP AT gt_sflight INTO gs_sflight.
*
*  lv_tabix = sy-tabix.      "루프문 안에서 값을지정했기때문에 read table을하면서 sy-tabix가 변하더라도 이 루프문안에 값은 변하지 않는다.
*
*   "마찬가지로 if문대신case문이 사용가능하면 가독성을위해 case문 사용하기.
*  CASE gs_sflight-carrid.
*
*    WHEN 'UA'.
*      gs_sflight-seatsocc_b = gs_sflight-seatsocc_b + 5.
*
*    "테이블에 반영
*    MODIFY gt_sflight FROM gs_sflight INDEX lv_tabix
*
*    TRANSPORTING seatsocc_b.   "TRANSPORTING = 필드를 지정하기?
*  ENDCASE.
*ENDLOOP.
*
*cl_demo_output=>display_data( gt_sflight ).   "출력


*DATA : lv_tabix TYPE sy-tabix.
*
*DATA: BEGIN OF gs_mara,
*  matnr TYPE mara-matnr,
*  maktx TYPE makt-maktx,
*  mtart TYPE mara-mtart,
*  matkl TYPE mara-matkl,
*      END   OF gs_mara.
*DATA: gt_mara LIKE TABLE OF gs_mara.
*
*
*
*SELECT matnr mtart matkl
*  FROM mara
*  INTO CORRESPONDING FIELDS OF TABLE gt_mara.
*
*DATA: BEGIN OF gs_makt,
*  matnr TYPE makt-matnr,
*  maktx TYPE makt-maktx,
*      END   OF gs_makt.
*DATA: gt_makt LIKE TABLE OF gs_makt.
*
*SELECT matnr maktx
*  FROM makt
*  INTO CORRESPONDING FIELDS OF TABLE gt_makt
* WHERE spras = sy-langu.
*
*  LOOP AT gt_mara INTO gs_mara.
*    lv_tabix = sy-tabix.
*
*    READ TABLE gt_makt INTO gs_makt WITH KEY matnr = gs_mara-matnr.
*
*    IF sy-subrc EQ 0.
*      gs_mara-maktx = gs_makt-maktx.
*
*      MODIFY gt_mara FROM gs_mara INDEX lv_tabix TRANSPORTING maktx.
*    ENDIF.
*
*
*ENDLOOP.
*
*cl_demo_output=>display_data( gt_mara ).


*DATA : lv_tabix TYPE sy-tabix.
*"스트럭쳐
*DATA: BEGIN OF gs_spfli,
*  carrid    TYPE spfli-carrid,
*  carrname  TYPE scarr-carrname,
*  url       TYPE scarr-url,
*  connid    TYPE spfli-connid,
*  airpfrom  TYPE spfli-airpfrom,
*  airpto    TYPE spfli-airpto,
*  deptime   TYPE spfli-deptime,
*  arrtime   TYPE spfli-arrtime,
*      END   OF gs_spfli.
*DATA: gt_spfli LIKE TABLE OF gs_spfli.    "인터널테이블
*
*SELECT carrid connid airpfrom airpto deptime arrtime
*  FROM spfli
*  INTO CORRESPONDING FIELDS OF TABLE gt_spfli.
*
*
*"스트럭쳐
*DATA: BEGIN OF gs_scarr,
*  carrid    TYPE scarr-carrid,
*  carrname  TYPE scarr-carrname,
*  url       TYPE scarr-url,
*      END   OF gs_scarr.
*DATA: gt_scarr LIKE TABLE OF gs_scarr.    "인터널테이블
*
*SELECT carrid carrname url
*  FROM scarr
*  INTO CORRESPONDING FIELDS OF TABLE gt_scarr.
*
*  LOOP AT gt_spfli INTO gs_spfli.
*
*  lv_tabix = sy-tabix.
*
*
*  READ TABLE gt_scarr INTO gs_scarr WITH KEY carrid = gs_spfli-carrid.
*
*  IF sy-subrc EQ 0.
*
*    gs_spfli-carrname = gs_scarr-carrname.
*    gs_spfli-url = gs_scarr-url.
*    MODIFY gt_spfli FROM gs_spfli INDEX lv_tabix TRANSPORTING carrname url.
*                      "TRANSPORTING "필드네임" = 해당 필드들만 수정된다.
*
*  ENDIF.
*ENDLOOP.
*
*
*cl_demo_output=>display_data( gt_spfli ).
DATA : lv_tabix TYPE sy-tabix.

DATA : BEGIN OF gs_data,
         matnr TYPE mara-matnr,
         maktx TYPE makt-maktx,
         mtart TYPE mara-mtart,      "T134
         mtbez TYPE t134t-mtbez,     "T134의 텍스트테이블
         mbrsh TYPE mara-mbrsh,
         mbbez TYPE t137t-mbbez,     "T137의 텍스트테이블
         tragr TYPE mara-tragr,
         vtext TYPE ttgrt-vtext,     "ttgr의 텍스트테이블
       END   OF gs_data.
DATA: gt_data  LIKE TABLE OF gs_data,
      gs_t134t TYPE t134t,
      gt_t134t LIKE TABLE OF gs_t134t,
      gs_t137t TYPE t137t,
      gt_t137t LIKE TABLE OF gs_t137t,
      gs_ttgrt TYPE ttgrt,
      gt_ttgrt LIKE TABLE OF ttgrt.

"maktx innerjoin
SELECT a~matnr b~maktx mtart mbrsh tragr
FROM mara AS a INNER JOIN makt AS b
ON a~matnr = b~matnr
INTO CORRESPONDING FIELDS OF TABLE gt_data
WHERE b~spras = sy-langu.

SELECT mtbez mtart
  FROM t134t
  INTO CORRESPONDING FIELDS OF TABLE gt_t134t
  WHERE spras = sy-langu.

SELECT mbbez mbrsh
  FROM t137t
  INTO CORRESPONDING FIELDS OF TABLE gt_t137t
  WHERE spras = sy-langu.

SELECT vtext tragr
  FROM ttgrt
  INTO CORRESPONDING FIELDS OF TABLE gt_ttgrt
  WHERE spras = sy-langu.

LOOP AT gt_data INTO gs_data.

  lv_tabix = sy-tabix.

  READ TABLE gt_t134t INTO gs_t134t WITH KEY mtart = gs_data-mtart.

  IF sy-subrc EQ 0.
    gs_data-mtbez = gs_t134t-mtbez.
    MODIFY gt_data FROM gs_data INDEX lv_tabix TRANSPORTING mtbez.  "필드지정
  ENDIF.

  READ TABLE gt_ttgrt INTO gs_ttgrt WITH KEY tragr = gs_data-tragr.    "Read Table은 따로따로해야한다.
  "(sy-subrc가 위의 로직을 타는것이기때문에 따로따로 read를해주지않으면 어느것을 해주어야하는지 모르기때문에 따로따로 해주고 sy-subrc도 해주어야한다.)

  IF sy-subrc EQ 0.
    gs_data-vtext = gs_ttgrt-vtext.
    MODIFY gt_data FROM gs_data INDEX lv_tabix TRANSPORTING vtext.  "필드지정
  ENDIF.

  READ TABLE gt_t137t INTO gs_t137t WITH KEY mbrsh = gs_data-mbrsh.

  IF sy-subrc EQ 0.
    gs_data-mbbez = gs_t137t-mbbez.
    MODIFY gt_data FROM gs_data INDEX lv_tabix TRANSPORTING mbbez.  "필드지정
  ENDIF.
ENDLOOP.

cl_demo_output=>display_data( gt_data ).
