*&---------------------------------------------------------------------*
*& Include          YCL115_002_CLS
*&---------------------------------------------------------------------*

* 참조변수
DATA: GR_CON      TYPE REF TO CL_GUI_CUSTOM_CONTAINER,      "CUSTOM_CONTAINER = 화면의 특정구간에 만들기가쉽다.
      GR_ALV      TYPE REF TO CL_GUI_ALV_GRID.


DATA: GS_LAYOUT   TYPE LVC_S_LAYO, "GR_CON_ALV에다가 연결해서 출력하기위해 필드카탈로그,레이아웃(기본적으로 필요함)선언
      GT_FIELDCAT TYPE LVC_T_FCAT, "어떤필드들을 출력할건지
      GS_FIELDCAT TYPE LVC_S_FCAT.
