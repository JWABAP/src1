class ZCL_BC_425_NBD_PX15 definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_BC425_15_PX_BADI .
protected section.
private section.
ENDCLASS.



CLASS ZCL_BC_425_NBD_PX15 IMPLEMENTATION.


  METHOD if_ex_bc425_15_px_badi~write_additional_cols.

      WRITE: i_wa_spfli-distance UNIT i_wa_spfli-distid, i_wa_spfli-distid.

  ENDMETHOD.
ENDCLASS.
