*&---------------------------------------------------------------------*
*&  Include BC405_INTRO_S_E01                                          *
*&---------------------------------------------------------------------*

INITIALIZATION.

push_but = 'Detail'.   "'Hide'.
gv_change = 1.

 MOVE: 'AA' TO so_car-low,
       'QF' TO so_car-high,
       'BT' TO so_car-option,
       'I' TO so_car-sign.
 APPEND so_car.

 CLEAR so_car.

MOVE: 'AZ' TO so_car-low,
      'EQ' TO so_car-option,
      'E' TO so_car-sign.
APPEND so_car.

tab1 = 'Connections'(t11).
tab2 = 'Date'(t12).
tab3 = 'Type of flight'(t13).
tab4 = 'Counrty From' .

* Set second tab page as initial tab
airlines-activetab = 'TYPE'.             "액티브 탭 기본값설정(설정안해주면 첫번째 탭이 된다.)
airlines-dynnr = '1300'.

AT SELECTION-SCREEN.

  CASE sscrfields-ucomm.
    WHEN 'DETA'.
      CHECK sy-dynnr = '1400'.
      IF gv_change = '1'.
        gv_change = '0'.
      ELSE.
        gv_change = '1'.
      ENDIF.
*      MESSAGE i000(zt03_msg) WITH 'This is pushbutton test !'.
  ENDCASE.

AT SELECTION-SCREEN OUTPUT.
  IF sy-dynnr = '1400'.

    LOOP AT SCREEN.
      IF screen-group1 = 'DET'.
        screen-active =  gv_change.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.

*    IF gv_change = '1'.
*      push_but = 'Hide'.
*    ELSE.
*      push_but = 'Show'.
*    ENDIF.

  ENDIF.




START-OF-SELECTION.

CASE gc_mark.

  WHEN bt_all.

    SELECT * FROM dv_flights INTO gs_flight
      WHERE carrid IN so_car
      AND connid IN so_con
      AND fldate IN so_fdt
      AND countryfr IN s_cofr
      AND cityfrom IN s_cifr.

        WRITE: / gs_flight-carrid,
             gs_flight-connid,
             gs_flight-fldate,
             gs_flight-countryfr,
             gs_flight-cityfrom,
             gs_flight-airpfrom,
             gs_flight-countryto,
             gs_flight-cityto,
             gs_flight-airpto,
             gs_flight-seatsmax,
             gs_flight-seatsocc.

ENDSELECT.

  WHEN bt_dome.

    SELECT * FROM dv_flights INTO gs_flight
    WHERE carrid IN so_car
    AND connid IN so_con
    AND fldate IN so_fdt
    AND countryto = dv_flights~countryfr
      AND countryfr IN s_cofr
      AND cityfrom IN s_cifr.

        WRITE: / gs_flight-carrid,
             gs_flight-connid,
             gs_flight-fldate,
             gs_flight-countryfr,
             gs_flight-cityfrom,
             gs_flight-airpfrom,
             gs_flight-countryto,
             gs_flight-cityto,
             gs_flight-airpto,
             gs_flight-seatsmax,
             gs_flight-seatsocc.

ENDSELECT.

  WHEN bt_int.

    SELECT * FROM dv_flights INTO gs_flight
    WHERE carrid IN so_car
    AND connid IN so_con
    AND fldate IN so_fdt
      AND countryfr IN s_cofr
      AND cityfrom IN s_cifr
    AND countryto <> dv_flights~countryfr.

        WRITE: / gs_flight-carrid,
             gs_flight-connid,
             gs_flight-fldate,
             gs_flight-countryfr,
             gs_flight-cityfrom,
             gs_flight-airpfrom,
             gs_flight-countryto,
             gs_flight-cityto,
             gs_flight-airpto,
             gs_flight-seatsmax,
             gs_flight-seatsocc.

ENDSELECT.

ENDCASE.
