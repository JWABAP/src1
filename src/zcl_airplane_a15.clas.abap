class ZCL_AIRPLANE_A15 definition
  public
  final
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !IV_NAME type STRING
      !IV_PLANETYPE type SAPLANE-PLANETYPE
    exceptions
      WRONG_PLANETYPE .
  methods DISPLAY_ATTRIBUTES .
  class-methods CLASS_CONSTRUCTOR .
  class-methods DISPLAY_N_O_AIRPLANES .
protected section.
private section.

  constants C_POS_1 type I value 30 ##NO_TEXT.
  data MV_NAME type STRING .
  data MV_PLANETYPE type SAPLANE-PLANETYPE .
  data MV_WEIGHT type SAPLANE-WEIGHT .
  data MV_TANKCAP type SAPLANE-TANKCAP .
  class-data GV_N_O_AIRPLANES type I .
  class-data MT_PLANETYPES type TY_PLANETYPES .
ENDCLASS.



CLASS ZCL_AIRPLANE_A15 IMPLEMENTATION.


  METHOD class_constructor.
    SELECT *
      INTO TABLE mt_planetypes
      FROM saplane.

  ENDMETHOD.


  METHOD constructor.

    mv_name = iv_name.
    mv_planetype = iv_planetype.

    DATA: ls_planetype TYPE saplane.

    READ TABLE mt_planetypes
    INTO ls_planetype WITH KEY planetype = iv_planetype.


    "있으면 데이터 누적하기
    IF sy-subrc EQ 0.
          gv_n_o_airplanes = gv_n_o_airplanes + 1.
          mv_weight = ls_planetype-weight.
          mv_tankcap = ls_planetype-tankcap.
    ELSE.
      RAISE wrong_planetype.                    "없으면 이벤트 발생

    ENDIF.


  ENDMETHOD.


  method DISPLAY_ATTRIBUTES.
    WRITE: / icon_ws_plane AS ICON,
    / 'Name of Airplane' , AT c_pos_1 mv_name,
    / 'Type of Airplane:', AT c_pos_1 mv_planetype,
    / 'Weight/Tank capacity'           , AT c_pos_1 mv_weight, mv_tankcap.
  endmethod.


  method DISPLAY_N_O_AIRPLANES.
    WRITE: / 'Number of airplanes:',AT c_pos_1 gv_n_o_airplanes.

  endmethod.
ENDCLASS.
