*&---------------------------------------------------------------------*
*& Report ZRSA15_21
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa15_21.
TYPES: BEGIN OF ts_info,                    "값이없는 스터럭처 타입
          carrid    TYPE c LENGTH 3,
          carrname  TYPE scarr-carrname,
          connid    TYPE spfli-connid,
          countryfr TYPE spfli-countryfr,
          countryto TYPE spfli-countryto,
          atype, "TYPE c LENGTH 1
       END OF ts_info.
* Connection에관련된 Internal Table
DATA gt_info TYPE TABLE OF ts_info.  "<Table Type>.
* Structure Variable
DATA gs_info LIKE LINE OF gt_info.
*DATA gs_info TYPE ts_info.

*DATA: gs_info TYPE ts_info,
*      gt_info LIKE TABLE OF gs_info.

PARAMETERS pa_car TYPE spfli-carrid.
*                          LIKE gs_info-carrid.

*PERFORM info USING 'AA' '0017' 'US' 'US'.
*PERFORM info USING 'AA' '0064' 'US' 'US'.



*SELECT *
*  FROM spfli
*  INTO TABLE gt_info.        "spfli테이블에있는 내용을 전부(*) 가져와서 gt_info에 넣겠다는 뜻
*                             "특별한 경우를 제외하곤 where도 쓰는게 좋다.

SELECT carrid connid countryfr countryto
  FROM spfli
  INTO CORRESPONDING FIELDS OF TABLE gt_info
WHERE carrid = pa_car.

LOOP AT gt_info INTO gs_info.
  "Get Atype( D, I )(국내선,해외선)
  IF gs_info-countryfr = gs_info-countryto.
    gs_info-atype = 'D'.
  ELSE.
    gs_info-atype = 'I'.
  ENDIF.

  "Get Airline Name
  SELECT SINGLE carrname
    FROM scarr
    INTO gs_info-carrname
    WHERE carrid = gs_info-carrid.

  MODIFY gt_info FROM gs_info
                 TRANSPORTING carrname atype.     "TRANSPORTING을 사용하지않으면 인터널테이블의 값이 바뀜
  CLEAR gs_info.
ENDLOOP.

cl_demo_output=>display_data( gt_info ).
*&---------------------------------------------------------------------*
*& Form info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GS_INFO_CARRID
*&      --> GS_INFO_CONNID
*&      --> GS_INFO_COUNTRYFR
*&      --> GS_INFO_COUNTRYTO
*&---------------------------------------------------------------------*
FORM info USING VALUE(p_carrid)
                VALUE(p_connid)
                VALUE(p_countrpfr)
                VALUE(p_countryto).

  DATA ls_info LIKE LINE OF gt_info.
  CLEAR ls_info.
  ls_info-carrid = p_carrid.
  ls_info-connid = p_connid.  "'17'.
  ls_info-countryfr = p_countrpfr.
  ls_info-countryto = p_countryto.
  APPEND ls_info TO gt_info.
  CLEAR ls_info.
ENDFORM.
