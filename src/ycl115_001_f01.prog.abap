*&---------------------------------------------------------------------*
*& Include          YCL115_001_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form SELECT_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SELECT_DATA .

  REFRESH GT_SCARR.     "REFRESH = 인터널테이블의 내용을 초기화하겠다 라는뜻

*  CLEAR GT_SCARR.   "헤더라인을가지고있는 인터널테이블은 CLEAR를하면 헤더라인이 초기화되고
                    "헤더라인이없으면 인터널테이블의 내용이 초기화된다.

  SELECT *
    FROM SCARR
   WHERE CARRID   IN @S_CARRID  "IN = SELECT OPTIONS
     AND CARRNAME IN @S_CARRNM
    INTO TABLE @GT_SCARR.    "신문법, @ = 변수앞에 붙이고 언제든 값이 변할수있다 라는걸 알려준다.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT_0100 .

  CREATE OBJECT GR_CON
    EXPORTING
      REPID                       = SY-REPID "Report to Which This Docking Control is Linked 내가 현재 작업하고있는 프로그램
      DYNNR                       = SY-DYNNR " Screen to Which This Docking Control is Linked "작업하고있는 화면
      EXTENSION                   = 2000          " Control Extension  어떤사용자는 모니터가 클 수도있어서 크게만들기
    EXCEPTIONS
      CNTL_ERROR                  = 1                " Invalid Parent Control
      CNTL_SYSTEM_ERROR           = 2                " System Error
      CREATE_ERROR                = 3                " Create Error
      LIFETIME_ERROR              = 4                " Lifetime Error
      LIFETIME_DYNPRO_DYNPRO_LINK = 5                " LIFETIME_DYNPRO_DYNPRO_LINK
      OTHERS                      = 6.
  "오류가 날 경우 SY-SUBRC에 위의 숫자의 에러들이 들어간다.(숫자들은 바꿀 수 있음)

  CREATE OBJECT GR_SPLIT
    EXPORTING
      PARENT                  = GR_CON             " Parent Container
      ROWS                    = 2                  " Number of Rows to be displayed
      COLUMNS                 = 1                  " Number of Columns to be Displayed
    EXCEPTIONS
      CNTL_ERROR              = 1                  " See Superclass
      CNTL_SYSTEM_ERROR       = 2                  " See Superclass
      OTHERS                  = 3.

*  CALL METHOD GR_SPLIT->GET_CONTAINER
*    EXPORTING
*      ROW       = 1                " Row
*      COLUMN    = 1                " Column
*    RECEIVING
*      CONTAINER = GR_CON_TOP             " Container
*    .

*  GR_SPLIT->GET_CONTAINER(
*    EXPORTING
*      ROW       = 1                " Row
*      COLUMN    = 1                " Column
*    RECEIVING
*      CONTAINER = GR_CON_TOP                 " Container
*  ).

  "컨테이너 화면 쪼개기
  GR_CON_TOP = GR_SPLIT->GET_CONTAINER( ROW = 1 COLUMN = 1 ).
  GR_CON_ALV = GR_SPLIT->GET_CONTAINER( ROW = 2 COLUMN = 1 ).

  CREATE OBJECT GR_ALV
    EXPORTING
      I_PARENT                = GR_CON_ALV " Parent Container
    EXCEPTIONS
      ERROR_CNTL_CREATE       = 1                " Error when creating the control
      ERROR_CNTL_INIT         = 2                " Error While Initializing Control
      ERROR_CNTL_LINK         = 3                " Error While Linking Control
      ERROR_DP_CREATE         = 4                " Error While Creating DataProvider Control
      OTHERS                  = 5.

*  GR_ALV = NEW CL_GUI_ALV_GRID( I_PARENT = GR_CON_ALV ).
*  GR_ALV = NEW #( I_PARENT = GR_CON_ALV ). # = 왼쪽의 참조변수를 참고해서 선언하겠다라는뜻

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_LAYOUT_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_ALV_LAYOUT_0100 .

  CLEAR GS_LAYOUT.


  GS_LAYOUT-ZEBRA    = ABAP_ON.   "ABAP_ON. = 'X'  ABAP_OFF. = ' '
  GS_LAYOUT-SEL_MODE = 'D'.  "A:행열, B:단일행, C:복수행, D:셀단위
  GS_LAYOUT-CWIDTH_OPT = ABAP_ON.   "출력할 데이터가 많으면 OPT를 끄는게좋다.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FIELDCAT_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_ALV_FIELDCAT_0100 .

  "굳이직접 필드카탈로그를 APPEND하지않고 함수를 사용해서 해보기.

  DATA LT_FIELDCAT TYPE KKBLO_T_FIELDCAT.

  CALL FUNCTION 'K_KKB_FIELDCAT_MERGE'
      EXPORTING
        I_CALLBACK_PROGRAM     = SY-REPID         " Internal table declaration program
*        I_TABNAME              = 'GS_SCARR'      " Name of table to be displayed "내가선언한 구조체에서 가져오기
        I_STRUCNAME            = 'SCARR'          " 아밥딕셔너리에서 가져오기
        I_INCLNAME             = SY-REPID
      I_BYPASSING_BUFFER     = ABAP_ON                 " Ignore buffer while reading
      I_BUFFER_ACTIVE        = ABAP_OFF       "메모리의 유형(자주사용하는건 저장해놨다가 바로바로 갖다줘야지)
    CHANGING
      CT_FIELDCAT            = LT_FIELDCAT       " Field Catalog with Field Descriptions
    EXCEPTIONS
      INCONSISTENT_INTERFACE = 1
      OTHERS                 = 2.

  IF LT_FIELDCAT[] IS INITIAL.
    MESSAGE '필드 카탈로그 구성중 오류가 발생했습니다' TYPE 'E'.
  ELSE.
    CALL FUNCTION 'LVC_TRANSFER_FROM_KKBLO'  "KKBLO로부터 LVC로 전환을 하겠다
      EXPORTING
        IT_FIELDCAT_KKBLO         = LT_FIELDCAT
      IMPORTING
        ET_FIELDCAT_LVC           = GT_FIELDCAT
      EXCEPTIONS
        IT_DATA_MISSING           = 1
        OTHERS                    = 2.

ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV_0100 .

  CALL METHOD GR_ALV->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
      IS_LAYOUT                     = GS_LAYOUT     " Layout
    CHANGING
      IT_OUTTAB                     = GT_SCARR[]    " Output Table
      IT_FIELDCATALOG               = GT_FIELDCAT[] " Field Catalog
    EXCEPTIONS
      INVALID_PARAMETER_COMBINATION = 1 " Wrong Parameter
      PROGRAM_ERROR                 = 2 " Program Errors
      TOO_MANY_LINES                = 3 " Too many Rows in Ready for Input Grid
      OTHERS                        = 4.


ENDFORM.
