*&---------------------------------------------------------------------*
*& Report ZRSA15_05
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa15_05.

WRITE 'Last Name'(t01).
WRITE 'New Name'(t02).

*WRITE TEXT-t01.       "Last Name
*WRITE TEXT-t01.       "Last Name


*DATA gv_ecode type c LENGTH 4 value 'SYNC'.
*CONSTANTS gc_ecode TYPE c LENGTH 4 VALUE 'SYNC'.
*
*WRITE gc_ecode.
*
*gc_ecode = 'TEST'.



*TYPES t_name TYPE c LENGTH 10.
*
*DATA gv_name TYPE t_name.
*DATA gv_cname TYPE t_name.

*DATA: gv_name TYPE c LENGTH 20,
*      gv_cname Like gv_name.




*data gv_p type p.
*
*write gv_p.

*DATA: gv_n1 TYPE n,
*      gv_n2 TYPE n LENGTH 2,
*      gv_i TYPE i.
*
*WRITE: gv_n1, gv_n2, gv_i.

*DATA: gv_d1 TYPE c LENGTH 1,
*      gv_c2(1) TYPE c,
*      gv_c3 TYPE c,
*      gv_c4.

*data gv_d1 type d.
*data gv_d2 type sy-datum/
*WRITE: gv_d1, gv_d2.
