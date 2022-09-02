*&---------------------------------------------------------------------*
*& Include ZC1R150006_TOP                           - Report ZC1R150006
*&---------------------------------------------------------------------*
REPORT zc1r150006 MESSAGE-ID zmcsa15.

TABLES : sflight.

DATA : BEGIN OF gs_list,
         carrid     TYPE sflight-carrid,
         connid     TYPE sflight-connid,
         fldate     TYPE sflight-fldate,
         carrname   TYPE scarr-carrname,       "클래스를 통해서 가저올것(8월30일)
         price      TYPE sflight-price,
         currency   TYPE sflight-currency,
         planetype  TYPE sflight-planetype,
         paymentsum TYPE sflight-paymentsum,
       END OF gs_list,

       gt_list LIKE TABLE OF gs_list,

       BEGIN OF gs_scarr,          "팝업 정보를 넣을 인터널테이블
         carrid   TYPE scarr-carrid,
         carrname TYPE scarr-carrname,
         currcode TYPE scarr-currcode,
         url      TYPE scarr-url,
       END OF gs_scarr,

       gt_scarr  LIKE TABLE OF gs_scarr,
       gcl_scarr TYPE REF TO zclc115_0001.    "글로벌클래스이다.


* ALV 관련
DATA : gcl_container TYPE REF TO cl_gui_docking_container,
       gcl_grid      TYPE REF TO cl_gui_alv_grid,
       gs_fcat       TYPE lvc_s_fcat,
       gt_fcat       TYPE lvc_t_fcat,
       gs_layout     TYPE lvc_s_layo,
       gs_sort       TYPE lvc_s_sort,       "서브토탈을하기위해선 정렬이 필요하다.
       gt_sort       TYPE lvc_t_sort,
       gs_variant    TYPE disvariant.

* POPUP ALV 관련
DATA: gcl_container_pop TYPE REF TO cl_gui_custom_container, "전체화면이나오는게아닌 특정 크기의 화면이필요할때 주로 커스텀컨테이너를 사용하는것이다.(팝업)
      gcl_grid_pop      TYPE REF TO cl_gui_alv_grid,
      gs_fcat_pop       TYPE lvc_s_fcat,
      gt_fcat_pop       TYPE lvc_t_fcat,
      gs_layout_pop     TYPE lvc_s_layo.


DATA : gv_okcode TYPE sy-ucomm.


DEFINE _clear.
  CLEAR &1.
  REFRESH &2.
END-OF-DEFINITION.
