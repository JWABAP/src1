*&---------------------------------------------------------------------*
*& Report YCL115_001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT YCL115_001.

INCLUDE YCL115_001_TOP.    "전역변수 선언
INCLUDE YCL115_001_CLS.    "alv관련 선언
INCLUDE YCL115_001_SCR.    "검색화면
INCLUDE YCL115_001_PBO.    "PROCESS BEFORE OUTPUT
INCLUDE YCL115_001_PAI.    "PROCESS AFTER INPUT
INCLUDE YCL115_001_F01.    "SUBROUTINES

INITIALIZATION.           "프로그램이 실행될때 가장 처음 실행되는구간

TEXTT01 = '검색조건'.     "셀렉션스크린 블럭 타이틀변수(왜 텍스트 엘리먼트말고 변수를 쓰냐면 활용도를 높일 수 있어서다)

AT SELECTION-SCREEN OUTPUT.   "검색화면에서 화면이 출력되기 직전에 수행되는구간
  "주 용도는 검색화면에 대한 제어(특정필드 숨김,읽기전용 처리)

AT SELECTION-SCREEN.      "검색화면에서 사용자가 특정 이벤트를 발생시켰을때 수행되는 구간.
  "주 용도는 상단의 Function 키 이벤트나 특정 필드의 클릭,엔터등(이벤트들)의 이벤트에서
  "입력값에 대한 점검이나 실행권한 점검

START-OF-SELECTION.           "검색화면이 뜬 다음에 어떤작업을 했을때 도입되는구간
  "주 용도는 데이터조회이다.
  "데이터 조회&출력도 가능하다(END OF SELECTION 통합도 가능)
  PERFORM SELECT_DATA.
END-OF-SELECTION.
  "START-OF-SELECTION이 끝나고 실행되는 구간.
  "데이터 출력
IF GT_SCARR[] IS INITIAL.
  MESSAGE '데이터가 없습니다.' TYPE 'S' DISPLAY LIKE 'W'.  "DISPLAY LIKE = 어떤식으로 보이게할것인지
  "프로그램을 계속 이어서 진행되도록 만드는타입 ( S, I )
  "S : 하단에 메시지를 출력하면서 로직 계속 진행
  "I : 팝업창을 출력하면서 일시정지
  "프로그램을 중단시키는 타입( W, E, X (STOP))
ELSE.
  CALL SCREEN 0100.
ENDIF.
