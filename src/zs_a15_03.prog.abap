*&---------------------------------------------------------------------*
*& Report ZS_A15_03
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zs_a15_03.

*TABLES:sflight,sbook.
*DATA  : gv_tabix TYPE sy-tabix.
*
*
*SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-t01.
PARAMETERS     : pa_carr TYPE sflight-carrid OBLIGATORY.
*  SELECT-OPTIONS : so_conn FOR  sflight-connid.
*  PARAMETERS     : pa_plty TYPE sflight-planetype AS LISTBOX VISIBLE LENGTH 10.
*  SELECT-OPTIONS : so_bkid FOR  sbook-bookid.
*SELECTION-SCREEN END OF BLOCK bl1.
*
*DATA: BEGIN OF gs_data,
*        carrid    TYPE sflight-carrid,
*        connid    TYPE sflight-connid,
*        fldate    TYPE sflight-fldate,
*        planetype TYPE sflight-planetype,
*        currency  TYPE sflight-currency,
*        bookid    TYPE sbook-bookid,
*        customid  TYPE sbook-customid,
*        custtype  TYPE sbook-custtype,
*        class     TYPE sbook-class,
*        agencynum TYPE sbook-agencynum,
*      END OF gs_data,
*      gt_data LIKE TABLE OF gs_data.
*
*DATA: BEGIN OF gs_data2,
*        carrid    TYPE sflight-carrid,
*        connid    TYPE sflight-connid,
*        fldate    TYPE sflight-fldate,
*        bookid    TYPE sbook-bookid,
*        customid  TYPE sbook-customid,
*        custtype  TYPE sbook-custtype,
*        agencynum TYPE sbook-agencynum,
*      END OF gs_data2,
*      gt_data2 LIKE TABLE OF gs_data2.
*
*SELECT a~carrid a~connid a~fldate a~planetype a~currency b~bookid b~customid b~custtype b~class b~agencynum
* FROM sflight AS a INNER JOIN sbook AS b
*   ON a~carrid    =  b~carrid
*  AND a~connid    =  b~connid
*  AND a~fldate    =  b~fldate
*WHERE a~carrid    =  pa_carr
*  AND a~connid    IN so_conn
*  AND a~planetype =  pa_plty
*  AND a~bookid    IN so_bkid
*INTO CORRESPONDING FIELDS OF TABLE gt_data.
*
*
*LOOP AT gt_data2 INTO gs_data2.
*
*  gv_tabix = sy-tabix.
*
*  CASE gs_data-custtype.
*    WHEN 'B'.
*      gt_data-carrid    = gt_data2-carrid.
*      gt_data-connid    = gt_data2-connid.
*      gt_data-fldate    = gt_data2-fldate.
*      gt_data-bookid    = gt_data2-bookid.
*      gt_data-customid  = gt_data2-customid.
*      gt_data-custtype  = gt_data2-custtype.
*      gt_data-agencynum = gt_data2-agencynum.
*
*      MODIFY gt_data2 FROM gt_data INDEX gv_tabix TRANSPORTING custtype.
*  ENDCASE.
*ENDLOOP.
*-------내가한것(실패)



*TABLES: sbook,sflight.
*
*SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-t01.
*  PARAMETERS     : pa_carr  TYPE sflight-carrid OBLIGATORY.
*  SELECT-OPTIONS : so_conn  FOR  sflight-connid OBLIGATORY.
*  PARAMETERS     : pa_pltp  TYPE sflight-planetype AS LISTBOX VISIBLE LENGTH 10.
*  SELECT-OPTIONS : so_bkid  FOR  sbook-bookid.
*SELECTION-SCREEN END OF BLOCK bl1.
*
*"이벤트, Airline파라미터에서 돋보기눌렀을때 currency,carrname,carrid,url이 나오게 추가하기
*
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR pa_carr.
*  PERFORM f4_carrid.
*
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR so_bkid-low.
*
*
*
*
*START-OF-SELECTION.  "실질적으로 수행
*
*  DATA: BEGIN OF gs_itab1,
*          carrid    TYPE sflight-carrid,
*          connid    TYPE sflight-connid,
*          fldate    TYPE sflight-fldate,
*          planetype TYPE sflight-planetype,
*          currency  TYPE sflight-currency,
*          bookid    TYPE sbook-bookid,
*          customid  TYPE sbook-customid,
*          custtype  TYPE sbook-custtype,
*          class     TYPE sbook-class,
*          agencynum TYPE sbook-agencynum,
*        END OF gs_itab1,
*        gt_itab1 LIKE TABLE OF gs_itab1,
*
*        BEGIN OF gs_itab2,
*          carrid    TYPE sflight-carrid,
*          connid    TYPE sflight-connid,
*          fldate    TYPE sflight-fldate,
*          bookid    TYPE sbook-bookid,
*          customid  TYPE sbook-customid,
*          custtype  TYPE sbook-custtype,
*          agencynum TYPE sbook-agencynum,
*        END OF gs_itab2,
*        gt_itab2 LIKE TABLE OF gs_itab2.
*
*  REFRESH : gt_itab1, gt_itab2.
*
*  SELECT a~carrid a~connid a~fldate a~planetype a~currency
*         b~bookid b~customid b~custtype b~class b~agencynum
*    INTO CORRESPONDING FIELDS OF TABLE gt_itab1
*    FROM sflight AS a INNER JOIN sbook AS b
*      ON a~carrid = b~carrid
*     AND a~connid = b~connid
*     AND a~fldate = b~fldate
*   WHERE a~carrid = pa_carr
*     AND a~connid IN so_conn
*     AND a~planetype = pa_pltp
*  AND b~bookid    IN so_bkid.
**---필드들을 DB에서 Select하는 과정---*
*
*  "사용자에게 메시지 뿌려주기
*  IF sy-subrc NE 0.
*    MESSAGE i016(pn) WITH 'Data not found'.
*    LEAVE LIST-PROCESSING.
*  ENDIF.
*
*  LOOP AT gt_itab1 INTO gs_itab1.
*
*    CASE gs_itab1-custtype.
*      WHEN 'B'.
*        MOVE-CORRESPONDING gs_itab1 TO gs_itab2.       "이름이 같은애들을 알아서 집어넣어주는것.
**      gs_itab2-carrid = gs_itab1-carrid.
**      gs_itab2-connid = gs_itab1-connid.
**      gs_itab2-fldate = gs_itab1-fldate.
*
*        APPEND gs_itab2 TO gt_itab2.
*        CLEAR  gs_itab2.
*    ENDCASE.
*  ENDLOOP.
**------itab1의 CUSTTYPE이 'B'인것만 itab2에 적재하는 과정-----*
*
*  SORT gt_itab2 BY carrid connid fldate.          "중복제거는 반드시 정렬한 필드의 순서대로해야한다.
*  DELETE ADJACENT DUPLICATES FROM gt_itab2 COMPARING carrid connid fldate.
*
*  "메시지뿌려주기
*  IF gt_itab2 IS NOT INITIAL.
*    cl_demo_output=>display( gt_itab2 ).
*  ELSE.
*    MESSAGE i001(zmcsa15) WITH 'NO DATA'.
*  ENDIF.
**------ITAB 2 는 CARRID, CONNID, FLDATE 로 중복제거하고 데이터를 출력하는과정------*
**&---------------------------------------------------------------------*
**& Form f4_carrid
**&---------------------------------------------------------------------*
**& text
**&---------------------------------------------------------------------*
**& -->  p1        text
**& <--  p2        text
**&---------------------------------------------------------------------*
*FORM f4_carrid .
*
*  DATA: BEGIN OF ls_carrid,
*          carrid   TYPE scarr-carrid,
*          carrname TYPE scarr-carrname,
*          currcode TYPE scarr-currcode,
*          url      TYPE scarr-url,
*        END OF ls_carrid,
*
*        lt_carrid LIKE TABLE OF ls_carrid.
*
*  REFRESH lt_carrid.
*
*  SELECT carrid carrname currcode url
*    INTO CORRESPONDING FIELDS OF TABLE lt_carrid
*  FROM scarr.
**   where currcode = 'EUR'.      "조건을 추가로 줄 수도있다(이건 currency가 EUR인것만 보이게 추가한것)
*
*  "펑션이름이 기억이안나면 F4찾아보기
*  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
*    EXPORTING
*      retfield     = 'CARRID'   "선택하면 화면으로 세팅할 ITAB의 필드ID
*      dynpprog     = sy-repid
*      dynpnr       = sy-dynnr
*      dynprofield  = 'PA_CARR'   "서치헬프화면에서 선택한 데이터가 세팅될 화면의 필드ID(더블클릭하고 셀렉션스크린에 어느화면에 넣을것인가)
**     WINDOW_TITLE = TEXT-t02
*      window_title = 'Airline List'
*      value_org    = 'S'
*      display      = 'X' "선택한 데이터가 세팅될 화면의 필드에 세팅 되는것을 막음
*    TABLES
*      value_tab    = lt_carrid.
*
*ENDFORM.

*-----구문법-----*
DATA: BEGIN OF ls_scarr,
        carrid   TYPE scarr-carrid,
        carrname TYPE scarr-carrname,
        url      TYPE scarr-url,
      END OF ls_scarr,
      lt_scarr LIKE TABLE OF ls_scarr.

SELECT carrid carrname url
  INTO CORRESPONDING FIELDS OF TABLE lt_scarr
  FROM scarr.

READ TABLE lt_scarr INTO ls_scarr WITH KEY carrid = 'AA'.

*----------------------------신문법----------------------------*
SELECT carrid, carrname, url
  INTO TABLE @DATA(lt_scarr2)     "헤더가 없는것만 생긴다.
  FROM scarr.

*READ TABLE lt_scarr2 INTO DATA(ls_scarr2) WITH KEY carrid = 'AA'.   "선언하면서 바로 사용이가능하다.

LOOP AT lt_scarr2 INTO DATA(ls_scarr2).

ENDLOOP.
**********************************************************************
"구 문법
DATA: lv_carrid   TYPE scarr-carrid,
      lv_carrname TYPE scarr-carrname.

SELECT SINGLE carrid carrname
  INTO (lv_carrid, lv_carrname)
  FROM scarr
 WHERE carrid = pa_carr.

"신 문법
SELECT SINGLE carrid, carrname
  FROM scarr
 WHERE carrid = @pa_carr
  INTO (@DATA(lv_carrid2), @DATA(lv_carrname2)).
**********************************************************************
DATA : BEGIN OF ls_scarr3,
         carrid   TYPE scarr-carrid,
         carrname TYPE scarr-carrname,
         url      TYPE scarr-url,
       END OF ls_scarr3.

ls_scarr3-carrid    = 'AA'.
ls_scarr3-carrname  = 'American Airline'.
ls_scarr3-url       = 'www.aa.com'.

ls_scarr3-carrid = 'KA'.


"신 문법
ls_scarr3 = VALUE #( carrid   = 'AA'
                     carrname = 'American Airline'
                     url      = 'www.aa.com').

ls_scarr3 = VALUE #( carrid = 'KA' ).    "VALUE에서 기술되어있지않은 필드가있으면 CLEAR가 되버린다.(KA빼고 안보임)

ls_scarr3 = VALUE #( BASE ls_scarr3      "VALUE에서 기술되지않은 필드는 모두 유지시켜준다.(AA가 KA로바뀌고 carrname,url은 그대로 유지됨)
                     carrid = 'KA' ).
**********************************************************************
"구 문법
DATA : BEGIN OF ls_scarr4,
         carrid   TYPE scarr-carrid,
         carrname TYPE scarr-carrname,
         url      TYPE scarr-url,
       END OF ls_scarr4,

       lt_scarr4 LIKE TABLE OF ls_scarr4.

ls_scarr4-carrid    = 'AA'.
ls_scarr4-carrname  = 'America Airline'.
ls_scarr4-url       = 'www.aa.com'.

APPEND ls_scarr4 TO lt_scarr4.

"신 문법
REFRESH lt_scarr4.

lt_scarr4 = VALUE #(         "Work Area필요없이 데이터 append가 가능하다.
                       ( carrid   = 'AA'
                        carrname = 'America Airline'
                        url      = 'www.aa.com'
                       )
                       ( carrid   = 'KA'
                        carrname = 'Korean Airline'
                        url      = 'www.ka.com'
                       )
                    ).

lt_scarr4 = VALUE #(         "기존 itab의 row가 모두 REFRESH되고 지금 추가한것만 남는다.
                       ( carrid   = 'LH'
                        carrname = 'Luft Hansa'
                        url      = 'www.lh.com'
                       )
                    ).

lt_scarr4 = VALUE #( BASE lt_scarr4  "기존 itab의 ROW를 모두 유지시킨다.
                       ( carrid   = 'LH'
                        carrname = 'Luft Hansa'
                        url      = 'www.lh.com'
                       )
                    ).

*LOOP AT itab INTO wa.
*
*  lt_scarr4 = VALUE #( BASE lt_scarr4
*                        ( carrid   = wa-carrid
*                          carrname = wa-carrname
*                          url      = wa-url
*                         )
*                      ).
*
*ENDLOOP.
**********************************************************************
"구 문법
MOVE-CORRESPONDING ls_scarr3 to ls_scarr4.

"신 문법
ls_scarr4 = CORRESPONDING #( ls_scarr3 ).
**********************************************************************
* ITAB의 데이터 이동 문법
**********************************************************************
*gt_color = lt_color."둘다 같은 구조의 itab 이어야 함 :기존데이터 사라짐
*gt_color[] = lt_color[]."둘다 같은 구조의 itab 이어야 함
** 둘다 같은 구조의 itab이면서 기존 데이터 밑으로 append
*APPEND LINES OF lt_color TO gt_color.
*
** 같은필드ID 에 대해서만 데이터 이동 : 기존 데이터 사라짐
*MOVE-CORRESPONDING lt_color TO gt_color.
*
**같은필드ID 에 대해서만 데이터 이동 : 기존 데이터 밑으로 append됨
*MOVE-CORRESPONDING lt_color TO gt_color KEEPING TARGET LINES.
**********************************************************************
* DB Table 과 ITAB의 Join 방법
**********************************************************************
DATA : BEGIN OF ls_key,
         carrid TYPE sflight-carrid,
         connid TYPE sflight-connid,
         fldate TYPE sflight-fldate,
       END OF ls_key,

       lt_key LIKE TABLE OF ls_key,
       lt_sbook TYPE TABLE OF sbook.

SELECT carrid connid fldate
  INTO CORRESPONDING FIELDS OF TABLE lt_key
  FROM sflight
 WHERE carrid = 'AA'.

* FOR ALL ENTRIES 의 선제조건
* 1. 반드시 정렬 먼저 할것 : SORT
* 2. 정렬 후 중복제거 할것
* 3. ITAB이 비어있는지 체크하고 수행할것 : 비어있으면 안된다
SORT lt_key BY carrid connid fldate.
DELETE ADJACENT DUPLICATES FROM lt_key COMPARING carrid connid fldate.

IF lt_key IS NOT INITIAL.
  SELECT carrid connid fldate bookid customid custtype
    INTO CORRESPONDING FIELDS OF TABLE lt_sbook
    FROM sbook
     FOR ALL ENTRIES IN lt_key
   WHERE carrid   = lt_key-carrid
     AND connid   = lt_key-connid
     AND fldate   = lt_key-fldate
     AND customid = '00000279'.
ENDIF.
* new syntax
SORT lt_key BY carrid connid fldate.
DELETE ADJACENT DUPLICATES FROM lt_key COMPARING carrid connid fldate.

SELECT a~carrid, a~connid, a~fldate, a~bookid, a~customid
  FROM sbook AS a
 INNER JOIN @lt_key AS b
    ON a~carrid = b~carrid
   AND a~connid = b~connid
   AND a~fldate = b~fldate
 WHERE a~customid = '00000279'
  INTO TABLE @DATA(lt_sbook2).
**********************************************************************
* lt_sbook2 에서 connid 의 MAX 값을 알고자 할때
SORT lt_sbook2 BY connid DESCENDING.
READ TABLE lt_sbook2 INTO DATA(ls_sbook2) INDEX 1.
*new syntax
SELECT MAX( connid ) AS connid
  FROM @lt_sbook2 AS a
  INTO @DATA(lv_max).
**********************************************************************
*SELECT carrid connid price currency fldate
*  INTO CORRESPONDING FIELDS OF TABLE gt_data
*  FROM sflight.
*
*LOOP AT gt_data INTO gs_data.
*
*  CASE gs_data-carrid.
*    WHEN 'AA'.
*      gs_data-carrid = 'BB'.
*
*      MODIFY gt_data FROM gs_data INDEX sy-tabix TRANSPORTING carrid.
*  ENDCASE.
*
*ENDLOOP.

* new syntax
SELECT CASE carrid
       	 WHEN 'AA' THEN 'BB'
         ELSE carrid
       END AS carrid, connid, price, currency, fldate
   INTO TABLE @DATA(lt_sflight)
   FROM sflight.
**********************************************************************
