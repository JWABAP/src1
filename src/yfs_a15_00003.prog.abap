*&---------------------------------------------------------------------*
*& Report YTEST0001_2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT yfs_a15_00003.


*-- field symbol assign을 하면 CAST를 이용해 모든 타입을 FS 에  assign 가능
*--


*-- 타입이 정해진 필드 심볼과 데이타 오브젝트 타입이 다른경우 casting 구문을 사용해 assign.
TYPES : BEGIN OF t_line,
          field1 TYPE char3,
          field2 TYPE char5,
          field3 TYPE char10.
TYPES : END OF t_line.

DATA : gv_adr(18) VALUE 'KOR Seoul DMC'.

data : gs_line type t_line.

FIELD-SYMBOLS : <fs> TYPE t_line.
FIELD-SYMBOLS : <fs1> TYPE any.


ASSIGN gv_adr TO <fs> CASTING.    "implicit casting (묵시적 형변환)

ASSIGN gv_adr TO <fs1> CASTING TYPE t_line.  "explicit casting

*assign gv_adr to <fs> .     " 이 구믄은 에러.

WRITE : <fs>-field1, <fs>-field2, <fs>-field3.


*-- field symbol을 구조체에 할당하여 사용하는구문.

assign gs_line to <fs>.
WRITE : <fs>-field1, <fs>-field2, <fs>-field3.
