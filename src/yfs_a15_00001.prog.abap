*&---------------------------------------------------------------------*
*& Report YTEST0001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT yfs_a15_00001.

TYPES : BEGIN OF wa,
          field1(3) TYPE c,
          field2(3) TYPE c,
        END OF wa.
DATA : ws   TYPE wa,
       gtab TYPE TABLE OF line.

DATA: f_value TYPE c LENGTH 4.

FIELD-SYMBOLS : <fs> LIKE ws.      "명시적으로 타입이 들어있는것으로도 선언이 가능.
FIELD-SYMBOLS : <fs1> TYPE wa.
FIELD-SYMBOLS : <fs2>.             "타입이 없이 선언도가능하다.

ASSIGN f_value TO <fs2>.
<fs2> = 'BBBB'.               "fs2에 BBBB등록

WRITE : / <fs2>, f_value.


ASSIGN ws TO <fs>.                     "ASSIGN하는순간 ws를 가리킨다.(그 값을 가지게된다)
<fs>-field1 = 'AAA'.
WRITE :/ <fs>-field1, ws-field1 .






*
*
*
**-----
FIELD-SYMBOLS : <fn> TYPE any.          "타입 any로도 선언가능(프리디파인드 형식,모든타입 허용)
*DATA : wa_cosp TYPE cosp.
*DATA : sum_12 LIKE cosp-wtg001.
*
*DATA : fname(20).
*DATA : nn(2) TYPE n.
*
*
*DO 12 TIMES.
*  nn = nn + 1.
*  CONCATENATE 'WA_COSP-WTG0' nn INTO fname.
*  CONDENSE fname.
*  ASSIGN (fname) TO <fn>.
*  <fn> = sy-index.
*  sum_12 = sum_12 + <fn>.
*  WRITE : / <fn>.
*ENDDO.
*WRITE : /   sum_12.
*
*
*
*DATA : BEGIN OF gs_str,
*         col1 TYPE char5 VALUE 'KOREA',
*         col2 TYPE char10 VALUE 'SEOUL',
*         col3 TYPE char15 VALUE 'DMC',
*       END OF gs_str.
*
*FIELD-SYMBOLS : <fstr> LIKE gs_str,
*                <fch>  TYPE any.
*
*ASSIGN gs_str TO <fstr>.
*
*NEW-LINE.
*DO 3 TIMES.
*  ASSIGN COMPONENT sy-index .OF STRUCTURE <fstr> TO <fch>.
*  ASSIGN COMPONENT 'COL1' OF STRUCTURE <fstr> TO <fch>.
*  WRITE <fch>.
*ENDDO.
*
*
*
*
*
*
**---fieldcatalog를 이용한  예제,ALV에서 많이 이용
*FIELD-SYMBOLS : <lf> TYPE lvc_s_fcat.        "필드심볼은 테이블타입으로도 가능하다.
*FIELD-SYMBOLS : <fn1>, <fn2>.
*DATA : lt_fcat TYPE lvc_t_fcat.
*
*DATA : gt_tab TYPE TABLE OF cosp.
*
*LOOP AT lt_fcat ASSIGNING <lf>.
*  IF <lf>-fieldname CS 'WTG'.       "필드네임 앞 3자리가 WTG면
*
**-- 구조체의 필드를 field symbol 에 assign.
*    ASSIGN COMPONENT <lf>-fieldname OF STRUCTURE  "하나씩 값이 들어온다.
*               gt_tab TO <fn1>.
*
*  ENDIF.
*
*ENDLOOP.
