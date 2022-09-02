*&---------------------------------------------------------------------*
*& Include ZBC405_A15_SOLTOP                        - Report ZBC405_A15_SOL
*&---------------------------------------------------------------------*
REPORT zbc405_a15_sol.

TABLES: dv_flights.

DATA gs_flights TYPE dv_flights.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.     "블럭이름은 유니크하게(중복이안되게)줘야함.

*PARAMETERS: p_car TYPE dv_flights-carrid
*                  MEMORY ID car OBLIGATORY DEFAULT 'LH' VALUE CHECK, "없는값을 입력하면 에러체크
*
*            p_con TYPE s_conn_id
*                  MEMORY ID con OBLIGATORY.   "OBLIGATORY=필수값 체크.

SELECT-OPTIONS : s_car FOR dv_flights-carrid
                     MEMORY ID car ,
                 s_con FOR dv_flights-connid .
SELECT-OPTIONS : s_fldate FOR dv_flights-fldate.
SELECTION-SCREEN END OF BLOCK b1.


*PARAMETERS : p_str TYPE string.     "대문자밖에 인식못함
*PARAMETERS : p_str1 TYPE string LOWER CASE   "소문자도 인식가능.
*                   MODIF ID mod.
*PARAMETERS : p_chk AS CHECKBOX DEFAULT 'X'
*                   MODIF ID mod.

PARAMETERS : p_rad1 RADIOBUTTON GROUP rd1,
             p_rad2 RADIOBUTTON GROUP rd1,
             p_rad3 RADIOBUTTON GROUP rd1.

*INITIALIZATION.

*s_fldate-low = sy-datum.
*s_fldate-high = sy-datum = 30.
*
*s_fldate-sign = 'I'.
*s_fldate-option = 'BT'.

*APPEND s_fldate.



*INITIALIZATION.

*LOOP AT SCREEN.
*  IF screen-group1 = 'MOD'.
*
*    screen-input = 0.
*    screen-output = 1.
*    MODIFY SCREEN.
*  ENDIF.
*
*
*ENDLOOP.




*CASE 'X'.
*
*  WHEN p_rad1.
*
*  WHEN p_rad2.
*
*  WHEN p_rad3.
*
*ENDCASE.

***page 43 Solution
**DATA gs_flight TYPE dv_flights.
**
**CONSTANTS gc_mark VALUE 'X'.
**
**SELECT-OPTIONS: so_car FOR gs_flight-carrid MEMORY ID car,
**                so_con FOR gs_flight-connid.
**
**SELECT-OPTIONS so_fdt FOR gs_flight-fldate NO-EXTENSION.
**
**SELECTION-SCREEN BEGIN OF BLOCK radio WITH FRAME.
**  PARAMETERS: pa_all RADIOBUTTON GROUP rbg1,
**              pa_nat RADIOBUTTON GROUP rbg1,
**              pa_int RADIOBUTTON GROUP rbg1 DEFAULT 'X'.
**SELECTION-SCREEN END OF BLOCK radio.
