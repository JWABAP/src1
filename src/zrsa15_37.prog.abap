*&---------------------------------------------------------------------*
*& Report ZRSA15_37
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa15_37.

DATA: gs_info TYPE zvsa1502,    "Database View(스트럭처 타입이다.=스트럭처 변수이다)
      gt_info LIKE TABLE OF gs_info.

*PARAMETERS pa_dep LIKE gs_info-depid.

START-OF-SELECTION.
*SELECT *
*  FROM zvsa1502    "Database View
*  into CORRESPONDING FIELDS OF table gt_info.
**  where depid = pa_dep.

"Open SQL
*SELECT *
*  FROM ztsa1501 INNER JOIN ztsa1503
*    ON ztsa1501~depid = ztsa1503~depid             "Inner Join에선 -대신 ~를 쓴다.(문법임)
*  INTO CORRESPONDING FIELDS OF TABLE gt_info
*  WHERE ztsa1501~depid = pa_dep.

*  SELECT a~pernr a~ename a~depid b~phone               "~를달아서 어디에있는건지 알려주는게 보기편함(~는-)
*    FROM ztsa1501 AS a INNER JOIN ztsa1503 AS b        "ztsa1501는a로 대체한다, ztsa1503은 b로 대체한다.
*      ON a~depid = b~depid                             " ON=연결고리(depid)
*    INTO CORRESPONDING FIELDS OF TABLE gt_info
*   WHERE a~depid = pa_dep.

SELECT *
  FROM ztsa1501 AS emp LEFT OUTER JOIN ztsa1503 AS dep       "LEFT OUTER JOIN은 Inner Join과는 다르게 값이 모두나온다.
    ON emp~depid = dep~depid
  INTO CORRESPONDING FIELDS OF TABLE gt_info.

  cl_demo_output=>display_data( gt_info ).
