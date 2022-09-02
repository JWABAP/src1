*&---------------------------------------------------------------------*
*& Include ZC1R150001_TOP                           - Report ZC1R150001
*&---------------------------------------------------------------------*
REPORT zc1r150001 MESSAGE-ID zmcsa15.

TABLES : sflight.

DATA : BEGIN OF gs_data,
         carrid    TYPE sflight-carrid,
         connid    TYPE sflight-connid,
         fldate    TYPE sflight-fldate,
         price     TYPE sflight-price,
         currency  TYPE sflight-currency,
         planetype TYPE sflight-planetype,
       END OF gs_data,

       gt_data LIKE TABLE OF gs_data.

* ALV 관련
DATA : gcl_container TYPE REF TO cl_gui_docking_container,
       gcl_grid      TYPE REF TO cl_gui_alv_grid,
       gs_fcat       TYPE lvc_s_fcat,
       gt_fcat       TYPE lvc_t_fcat,
       gs_layout     TYPE lvc_s_layo,
       gs_variant    TYPE disvariant.

DATA : gv_okcode TYPE sy-ucomm.


*TABLES: sflight.
*
*
*"데이터를 담을 인터널테이블 생성
*DATA: BEGIN OF gs_data,
*        carrid    TYPE sflight-carrid,
*        connid    TYPE sflight-carrid,
*        fldate    TYPE sflight-carrid,
*        price     TYPE sflight-carrid,
*        currency  TYPE sflight-carrid,
*        planetype  TYPE sflight-carrid,
*      END OF gs_data,
*      gt_data LIKE TABLE OF gs_data.
*
**---ALV관련
*DATA: gcl_container TYPE REF TO cl_gui_docking_container,         "클래스는 gcl,go등등의 네이밍이 있다.
*      gcl_grid      TYPE REF TO cl_gui_alv_grid,                      "ALV전용 = docking을 사용한다.
*      gs_fcat       TYPE lvc_s_fcat,
*      gt_fcat       TYPE lvc_t_fcat,                              "테이블타입은 참조하는순간 자신이 인터널테이블이된다.
*      gs_layout     TYPE lvc_s_layo.
*
*data: gv_okcode type sy-ucomm.
