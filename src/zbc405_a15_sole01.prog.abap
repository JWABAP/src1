*&---------------------------------------------------------------------*
*& Include          ZBC405_A15_SOLE01
*&---------------------------------------------------------------------*

*START-OF-SELECTION.
*
*SELECT *
*  FROM dv_flights INTO gs_flights
*                  WHERE carrid = p_car AND
*                        connid = p_con AND
*                        fldate IN s_fldate.
*
*  WRITE: /10(5) gs_flights-carrid,    "write: / = 새로운 라인이 시작된다.
*                                      "10(5) 앞에숫자는 시작하는위치 괄호안 숫자는 차지하는공간이다.
*          16(5) gs_flights-connid,    "공간을 계산해서 넣어야한다.(앞이 10(5)니까 15보다 커야함)
*          22(10) gs_flights-fldate,
*           gs_flights-price CURRENCY gs_flights-currency, gs_flights-currency.
*
*ENDSELECT.




***page 43 solution
**INITIALIZATION.
**
**MOVE: 'AA' TO so_car-low,
**      'QF' TO so_car-high,
**      'BT' TO so_car-option,
**      'I'  TO so_car-sign.
**APPEND so_car.
**
**CLEAR so_car.
**MOVE: 'AZ' TO so_car-low,
**      'EQ' TO so_car-option,
**      'E'  TO so_Car-sign.
**APPEND so_car.
**
**START-OF-SELECTION.
**CASE gc_mark.
**  WHEN pa_all.
**    SELECT *
**      FROM dv_flights
**      INTO gs_flight
**     WHERE carrid IN so_Car
**       AND connid IN so_con
**       AND fldate IN so_fdt.
**
**      WRITE: / gs_flight-carrid,
**               gs_flight-connid,
**               gs_flight-fldate,
**               gs_flight-countryfr,
**               gs_flight-cityfrom,
**               gs_flight-airpfrom,
**               gs_flight-countryto,
**               gs_flight-cityto,
**               gs_flight-airpto,
**               gs_flight-seatsmax,
**               gs_flight-seatsocc.
**      ENDSELECT.
**
**      WHEN pa_nat.
**        SELECT *
**          FROM dv_flights
**          INTO gs_flight
**         WHERE carrid IN so_car
**           AND connid IN so_con
**           AND fldate IN so_fdt
**           AND countryto = dv_flights~countryfr.
**
**          WRITE: / gs_flight-carrid,
**               gs_flight-connid,
**               gs_flight-fldate,
**               gs_flight-countryfr,
**               gs_flight-cityfrom,
**               gs_flight-airpfrom,
**               gs_flight-countryto,
**               gs_flight-cityto,
**               gs_flight-airpto,
**               gs_flight-seatsmax,
**               gs_flight-seatsocc.
**          ENDSELECT.
**
**
**          WHEN pa_int.
**            SELECT *
**              FROM dv_flights
**              INTO gs_flight
**             WHERE carrid IN so_car
**               AND connid IN so_con
**               AND fldate IN so_fdt
**               AND countryto <> dv_flights~countryfr.
**
**              WRITE: / gs_flight-carrid,
**               gs_flight-connid,
**               gs_flight-fldate,
**               gs_flight-countryfr,
**               gs_flight-cityfrom,
**               gs_flight-airpfrom,
**               gs_flight-countryto,
**               gs_flight-cityto,
**               gs_flight-airpto,
**               gs_flight-seatsmax,
**               gs_flight-seatsocc.
**              ENDSELECT.
**ENDCASE.
