*&---------------------------------------------------------------------*
*& Include          YCL115_001_CLS
*&---------------------------------------------------------------------*

"ALV
"1. LIST
"   ㄴ WRITE
"2. FUNCTION ALV
"   ㄴ REUSE
"3. CLASS ALV
"   ㄴSIMPLE ALV ( 편집불가능, 기능이제한되서 실무에선 잘 안씀 )
"   ㄴ GRID ALV  ( 대다수에서 사용함 )
"   ㄴ ALV WITH IDA( 최신 )  CDS뷰를 배워야한다.
"REUSE : 함수를호출해서 데이터를전달하고 ALV를 출력하는것

"CONTAINER
"1. CUSTOM CONTAINER(스크린에서 직접 그려서사용)
"2. DOCKING CONTAINER(언제든지 컨테이너를 추가해서 만들 수 있다.)(화면은 그대로있고 그 위에 창 하나가 더 뜨는게 가능하다)
"3. SPLITTER CONTAINER(하나의화면에서 하나의컨테이너를 쪼갤 수 있다.SE80화면처럼 왼쪽은 뭐 오른쪽은 뭐 이런식으로)

DATA: GR_CON      TYPE REF TO CL_GUI_DOCKING_CONTAINER,
      GR_SPLIT    TYPE REF TO CL_GUI_SPLITTER_CONTAINER,
      GR_CON_TOP  TYPE REF TO CL_GUI_CONTAINER,
      GR_CON_ALV  TYPE REF TO CL_GUI_CONTAINER.

DATA: GR_ALV      TYPE REF TO CL_GUI_ALV_GRID,
      GS_LAYOUT   TYPE LVC_S_LAYO, "GR_CON_ALV에다가 연결해서 출력하기위해 필드카탈로그,레이아웃(기본적으로 필요함)선언
      GT_FIELDCAT TYPE LVC_T_FCAT, "어떤필드들을 출력할건지
      GS_FIELDCAT TYPE LVC_S_FCAT,

      GS_VARIANT  TYPE DISVARIANT,  "레이아웃 저장(VARIANT)
      GV_SAVE     TYPE C.
