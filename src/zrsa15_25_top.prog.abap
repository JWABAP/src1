*&---------------------------------------------------------------------*
*& Include ZRSA15_25_TOP                            - Report ZRSA15_25
*&---------------------------------------------------------------------*
REPORT zrsa15_25.

DATA: BEGIN OF gs_info,
        carrid     TYPE c LENGTH 3,
        connid     TYPE sflight-connid,
        fldate     TYPE sflight-fldate,
        price      TYPE sflight-price,
        currency   TYPE sflight-currency,
        seatsocc   TYPE sflight-seatsocc,
        seatsmax   TYPE sflight-seatsmax,
        seatsocc_b TYPE sflight-seatsocc_b,
        seatsmax_b TYPE sflight-seatsmax_b,
        seatsocc_f TYPE sflight-seatsocc_f,
        seatsmax_f TYPE sflight-seatsmax_f,

        cityfrom   TYPE spfli-cityfrom,
        cityto     TYPE spfli-cityto,
        END OF gs_info.

DATA gt_info LIKE TABLE OF gs_info.

PARAMETERS: pa_car  LIKE sflight-carrid,
            pa_con1 LIKE sflight-connid,
            pa_con2 LIKE sflight-connid.
