*&---------------------------------------------------------------------*
*& Form get_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_info .
*  select *
*    from sflight
*    into CORRESPONDING FIELDS OF gt_info
*    where carrid = pa_car
*    and   connid = pa_con1
*    and   connid = pa_con2.
*
*    loop at gt_info into gs_info.
ENDFORM.
