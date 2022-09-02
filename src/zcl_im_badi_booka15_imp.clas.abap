class ZCL_IM_BADI_BOOKA15_IMP definition
  public
  final
  create public .

public section.

  interfaces IF_EX_BADI_BOOK15 .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_BADI_BOOKA15_IMP IMPLEMENTATION.


  METHOD if_ex_badi_book15~change_vline.
    c_pos = c_pos + 25.
  ENDMETHOD.


  METHOD if_ex_badi_book15~output.
    DATA: name TYPE s_custname.

    SELECT SINGLE name
      FROM scustom
      INTO name
     WHERE id = i_booking-customid.
      WRITE : name.

  ENDMETHOD.
ENDCLASS.
