*&---------------------------------------------------------------------*
*& Report ZS_A15_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zs_a15_01.
"내가한것(성공함)
*DATA: buspartnum TYPE sbuspart-buspartnum,
*      contact    TYPE sbuspart-contact.
*
*DATA: BEGIN OF gs_table,
*        mandant    TYPE sbuspart-mandant,
*        buspartnum TYPE sbuspart-buspartnum,
*        contact    TYPE sbuspart-contact,
*        contphono  TYPE sbuspart-contphono,
*        buspatyp   TYPE sbuspart-buspatyp,
*      END OF gs_table.
*
*DATA: gt_table LIKE TABLE OF gs_table.
*
*SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.
*
*  PARAMETERS: pa_bpnum LIKE buspartnum OBLIGATORY.       "필수값
*  SELECT-OPTIONS: cont   FOR contact NO INTERVALS.       "NO INTERVALS = High값(오른쪽) 없애기
*
*  PARAMETERS: pa_ta RADIOBUTTON GROUP rd1 DEFAULT 'X',
*              pa_FC RADIOBUTTON GROUP rd1.
*SELECTION-SCREEN END OF BLOCK b1.
*
**SELECT mandant buspartnum contact contphono buspatyp
**  FROM sbuspart
**  INTO CORRESPONDING FIELDS OF TABLE gt_table.
**----IF문에서 select할거니까 굳이 위에서 안해도된다----*
*
*IF pa_ta = 'X'.
*  SELECT mandant  buspartnum contact contphono buspatyp
*    FROM sbuspart
*    INTO CORRESPONDING FIELDS OF TABLE gt_table
*   WHERE buspatyp = 'TA'.
*ENDIF.
*"값을 변경하거나 넣지않아도되니까 MODIFY 사용하지않는다
*
*
*IF pa_fc = 'X'.
*  SELECT mandant  buspartnum contact contphono buspatyp
*    FROM sbuspart
*    INTO CORRESPONDING FIELDS OF TABLE gt_table
*   WHERE buspatyp = 'FC'.
*ENDIF.
*
*cl_demo_output=>display_data( gt_table ).
"내가한것(성공함)

***--------강사님꺼--------***
TABLES sbuspart.

SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-t01.
  PARAMETERS     : pa_num  TYPE sbuspart-buspartnum OBLIGATORY.    "필수값
  SELECT-OPTIONS : so_cont FOR  sbuspart-contact NO INTERVALS.     "High칸 없애기

  PARAMETERS: pa_ta RADIOBUTTON GROUP rb1 DEFAULT 'X',
              pa_fc RADIOBUTTON GROUP rb1.


SELECTION-SCREEN END OF BLOCK bl1.

DATA: gt_data TYPE TABLE OF sbuspart,
      gv_type TYPE sbuspart-buspatyp.        "Select문 한번만사용하기위해 선언한변수

REFRESH gt_data.

*"밑 4개가 모두 같은뜻이다.
**if pa_ta is not INITIAL.
**if pa_ta ne space.
**if pa_ta = 'X'.
*IF pa_ta = 'X'.
*  SELECT buspartnum contact contphono buspatyp
*    INTO CORRESPONDING FIELDS OF TABLE gt_data
*    FROM sbuspart
*   WHERE buspartnum = pa_num
*     AND contact    IN so_cont
*     AND buspatyp   = 'TA'.
*ELSEIF pa_fc = 'X'.
*  SELECT buspartnum contact contphono buspatyp
*    INTO CORRESPONDING FIELDS OF TABLE gt_data
*    FROM sbuspart
*   WHERE buspartnum = pa_num
*     AND contact    IN so_cont
*     AND buspatyp   = 'FC'.
*ENDIF.
***-----------------------IF문-----------------------***

*---아래와같이 select문을 한번만 사용하는방법이있는데 AND buspatyp에 TA,FC를 넣는대신 변수로 gt_type을 선언하고 case문을 미리 지정해놓아서 사용할 수도 있다.
CASE 'X'.
  WHEN pa_ta.
    gv_type = 'TA'.
  WHEN pa_fc.
    gv_type = 'FC'.
ENDCASE.

SELECT buspartnum contact contphono buspatyp
  INTO CORRESPONDING FIELDS OF TABLE gt_data
  FROM sbuspart
 WHERE buspartnum =  pa_num
   AND contact    IN so_cont
   AND buspatyp   = gv_type.

*"다음과같이 X가 누구한테있는지로 사용할 수도 있다.
*CASE 'X'.
*  WHEN pa_ta.
*    SELECT buspartnum contact contphono buspatyp
*     INTO CORRESPONDING FIELDS OF TABLE gt_data
*     FROM sbuspart
*    WHERE buspartnum =  pa_num
*      AND contact    IN so_cont
*      AND buspatyp   = 'TA'.
*  WHEN pa_fc.
*    SELECT buspartnum contact contphono buspatyp
*    INTO CORRESPONDING FIELDS OF TABLE gt_data
*    FROM sbuspart
*   WHERE buspartnum =  pa_num
*     AND contact    IN so_cont
*     AND buspatyp   = 'FC'.
*ENDCASE.
****-----------------------CASE문-----------------------***
