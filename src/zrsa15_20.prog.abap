*&---------------------------------------------------------------------*
*& Report ZRSA15_20
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa15_20.
DATA: BEGIN  OF gs_info,
        carrid TYPE c LENGTH 20,
        carrname TYPE c LENGTH 40,
        connid TYPE n LENGTH 4,
        countryfr TYPE c LENGTH 4,
        countryto TYPE c LENGTH 4,
        atype TYPE c LENGTH 10,
        END OF gs_info.
DATA gt_info LIKE TABLE OF gs_info.

gs_info-carrid = 'AA'.
gs_info-connid = '0017'.
gs_info-countryfr = 'US'.
gs_info-countryto = 'US'.                "Line17~20 컴포넌트(스트럭처,테이블 칸 하나하나를 컴포넌트라고 함) 값 입력부분
APPEND gs_info TO gt_info.               "APPEND는 인터널테이블에 데이터를 삽입한다는뜻(삽입되는데이터의 위치는 맨 마지막 위치)

CLEAR gs_info.                           "어떤값이 들어있을지 모르기때문에 시작전에는 클리어를 항상 해주고 시작하는 습관을 들이면 좋다.
gs_info-carrid = 'AA'.
gs_info-connid = '0064'.
gs_info-countryfr = 'US'.
gs_info-countryto = 'US'.                "Line24~27 컴포넌트(스트럭처,테이블 칸 하나하나를 컴포넌트라고 함) 값 입력부분
APPEND gs_info TO gt_info.

CLEAR gs_info.
gs_info-carrid = 'AZ'.
gs_info-connid = '0555'.
gs_info-countryfr = 'IT'.
gs_info-countryto = 'DE'.
APPEND gs_info TO gt_info.

LOOP AT gt_info INTO gs_info.
  IF gs_info-countryfr = gs_info-countryto.
    gs_info-atype = '국내선'.
    ELSE.
      gs_info-atype = '해외선'.
  ENDIF.
  MODIFY gt_info FROM gs_info.
  CLEAR gs_info.
ENDLOOP.

LOOP AT gt_info INTO gs_info.
  SELECT SINGLE carrname
    FROM scarr
    INTO CORRESPONDING FIELDS OF gs_info
    WHERE carrid = gs_info-carrid.
    MODIFY gt_info FROM gs_info.           "MODIFY = 키값을 가지고있는 데이터가 테이블에 존재하면 변경, 존재하지않으면 삽입을한다.(여기선 존재하지 않으니까 삽입)
                                           "추가설명) gt_info FROM gs_info = gs_info(스트럭쳐 변수)값을 gt_info(테이블)에 삽입하라는 뜻.
ENDLOOP.
cl_demo_output=>display_data( gt_info ).
