*&---------------------------------------------------------------------*
*& Include          YCL115_002_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form REFRESH_GRID_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM REFRESH_GRID_0100 .

  CHECK GR_ALV IS BOUND.      "밑의 로직(if)과 같은의미다.(체크에 해당되지않으면 이 로직을 나가겠다)

    DATA LS_STABLE TYPE LVC_S_STBL.
    LS_STABLE-ROW = ABAP_OFF.
    LS_STABLE-COL = ABAP_ON.

    CALL METHOD GR_ALV->REFRESH_TABLE_DISPLAY
      EXPORTING
        IS_STABLE      = LS_STABLE    "현재있는 위치에 새로고침이되도 그대로 그 위치에있을거냐 라고 물어보는것
        I_SOFT_REFRESH = SPACE    "필터나 정렬정보같은게 새로고침할때마다 계속유지할건지물어보는것,
                                  " 'SAPCE' = 설정된 필터나 정렬정보 초기화 'X' =  설정된 필터나 정렬정보 유지.
      EXCEPTIONS
        FINISHED       = 1
        OTHERS         = 2.




*  IF GR_ALV IS BOUND.
*
*  ELSE.
*     EXIT.      "서브루틴 종료 (EXIT는 현재구간을 종료한다)
*
*  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM  CREATE_OBJECT_0100 .
  "연결하는과정을 제일먼저 해야한다.

  CREATE OBJECT GR_CON
    EXPORTING
      CONTAINER_NAME              = 'MY_CONTAINER'   " Name of the Screen CustCtrl Name to Link Container
                                                     "레이아웃에서 만들었던 CUSTOM CONTROL 이름이랑 맞게써야한다
    EXCEPTIONS
      CNTL_ERROR                  = 1                " CNTL_ERROR
      CNTL_SYSTEM_ERROR           = 2                " CNTL_SYSTEM_ERROR
      CREATE_ERROR                = 3                " CREATE_ERROR
      LIFETIME_ERROR              = 4                " LIFETIME_ERROR
      LIFETIME_DYNPRO_DYNPRO_LINK = 5                " LIFETIME_DYNPRO_DYNPRO_LINK
      OTHERS                      = 6.

  CREATE OBJECT GR_ALV
    EXPORTING
      I_PARENT                = GR_CON           " Parent Container
    EXCEPTIONS
      ERROR_CNTL_CREATE       = 1                " Error when creating the control
      ERROR_CNTL_INIT         = 2                " Error While Initializing Control
      ERROR_CNTL_LINK         = 3                " Error While Linking Control
      ERROR_DP_CREATE         = 4                " Error While Creating DataProvider Control
      OTHERS                  = 5.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SELECT_DATA .

  REFRESH GT_SCARR.

  RANGES LR_CARRID   FOR SCARR-CARRID.                      "변수선언(select-options과 똑같다고생각하면된다.)
  RANGES LR_CARRNAME FOR SCARR-CARRNAME.                    "변수선언(select-options과 똑같다고생각하면된다.)

  "RANGES와 SELECT-OPTIONS의 차이점은 RANGES는 화면에 출력하지않고 변수만 선언한다.
  "RANGES는 헤더라인이 있는 형태로 변수가 선언이된다.

  IF SCARR-CARRID IS INITIAL AND
     SCARR-CARRNAME IS INITIAL.
    "ID와 이름이 공란인경우

  ELSEIF SCARR-CARRID IS INITIAL.
    "이름은 공란이 아닌경우
    LR_CARRNAME-SIGN   = 'I'.     "I(INCLUDE)포함 , E(EXCLUDE)제외
    LR_CARRNAME-OPTION = 'EQ'.    "EQ = 같음
    LR_CARRNAME-LOW    = SCARR-CARRNAME.
    APPEND LR_CARRNAME.
    CLEAR  LR_CARRNAME.

  ELSEIF SCARR-CARRNAME IS INITIAL.
    "ID는 공란이 아닌경우
    LR_CARRID-SIGN     = 'I'.         "I(INCLUDE)포함 , E(EXCLUDE)제외
    LR_CARRID-OPTION = 'EQ'.
    LR_CARRID-LOW    = SCARR-CARRID.
    APPEND LR_CARRID.
    CLEAR  LR_CARRID.

  ELSE.
    "ID와 이름이 둘다 공란이 아닌경우
    "이름은 공란이 아닌경우
    LR_CARRNAME-SIGN   = 'I'.
    LR_CARRNAME-OPTION = 'EQ'.      " eq = 같음
    LR_CARRNAME-LOW    = SCARR-CARRNAME.
    APPEND LR_CARRNAME.
    CLEAR  LR_CARRNAME.

    " ID 가 공란이 아닌 경우
    LR_CARRID-SIGN = 'I'.     " I / E : Include / Exclude : 포함 / 제외
    LR_CARRID-OPTION = 'EQ'.
    LR_CARRID-LOW = SCARR-CARRID.
    APPEND LR_CARRID.
    CLEAR  LR_CARRID.

  ENDIF.

*  SELECT *
*    FROM SCARR
*   WHERE CARRID   IN @LR_CARRID
*     AND CARRNAME IN @LR_CARRNAME
*    INTO TABLE @GT_SCARR.

  "SELECTION SCREEN에서 서브스크린에 맞게 SELECT문 조절
  SELECT *
    FROM SCARR
   WHERE CARRID   IN @S_CARRID
     AND CARRNAME IN @S_CARRNM
    INTO TABLE @GT_SCARR.

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

  DATA LT_FIELDCAT TYPE KKBLO_T_FIELDCAT.

  REFRESH GT_FIELDCAT.            "필드카탈로그 세팅할땐 맨 처음 리프레쉬해주는게 좋다.

  CALL FUNCTION 'K_KKB_FIELDCAT_MERGE'
    EXPORTING
      I_CALLBACK_PROGRAM     = SY-REPID         " Internal table declaration program      SY-REPID = 현재프로그램
*     I_TABNAME              = '                " Name of table to be displayed "내가선언한 구조체에서 가져오기
      I_STRUCNAME            = 'SCARR'          " 아밥딕셔너리에서 가져오기
      I_INCLNAME             = SY-REPID
      I_BYPASSING_BUFFER     = ABAP_ON          " Ignore buffer while reading
      I_BUFFER_ACTIVE        = ABAP_OFF         "메모리의 유형(자주사용하는건 저장해놨다가 바로바로 갖다줘야지)
    CHANGING
      CT_FIELDCAT            = LT_FIELDCAT       " Field Catalog with Field Descriptions
    EXCEPTIONS
      INCONSISTENT_INTERFACE = 1
      OTHERS                 = 2.

  IF LT_FIELDCAT[] IS INITIAL.
    MESSAGE 'ALV 필드 카탈로그 구성이 실패했습니다' TYPE 'E'.

  ELSE.
    CALL FUNCTION 'LVC_TRANSFER_FROM_KKBLO'
      EXPORTING
        IT_FIELDCAT_KKBLO         =  LT_FIELDCAT
      IMPORTING
        ET_FIELDCAT_LVC           =  GT_FIELDCAT    "LT_FIELDCAT에있는내용이 GT_FIELDCAT으로 옮겨진다.
      EXCEPTIONS
        IT_DATA_MISSING           = 1
        OTHERS                    = 2 .

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
      IS_LAYOUT                     = GS_LAYOUT        " Layout
    CHANGING
      IT_OUTTAB                     = GT_SCARR[]       " Output Table
      IT_FIELDCATALOG               = GT_FIELDCAT[]        " Field Catalog
    EXCEPTIONS
      INVALID_PARAMETER_COMBINATION = 1                " Wrong Parameter
      PROGRAM_ERROR                 = 2                " Program Errors
      TOO_MANY_LINES                = 3                " Too many Rows in Ready for Input Grid
      OTHERS                        = 4.

ENDFORM.
