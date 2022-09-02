*&---------------------------------------------------------------------*
*& Include          MZSA1550_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.

    WHEN 'SEARCH'.
      "get Airline,Inflight Meal,Type of dish
      SELECT SINGLE carrid mealnumber mealtype
        FROM smeal
        INTO zssa1551                     "CORRESPONDING FIELDS OF
        WHERE carrid = zssa15_ven-carrid
        AND mealnumber = zssa15_ven-mealnumber.

      "get Meal name
      SELECT SINGLE text
        FROM smealt
        INTO zssa1551-text
        WHERE carrid = zssa15_ven-carrid
         AND  mealnumber = zssa15_ven-mealnumber.

      "get Meal price
      SELECT SINGLE price
        FROM  ztsa15ven
        INTO zssa1551-price
        WHERE carrid = zssa15_ven-carrid
         AND  mealno = zssa15_ven-mealnumber.

      "get vendor
        SELECT SINGLE *
        FROM ztsa15ven
        INTO CORRESPONDING FIELDS OF zssa1552
        WHERE carrid = zssa15_ven-carrid
        AND mealno = zssa15_ven-mealnumber.

      "get Country Text
        SELECT SINGLE landX50
        FROM t005t
        INTO zssa1552-landx50
        WHERE land1 = zssa1552-land1
          AND spras = sy-langu.


   ENDCASE.


ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.
  CASE ok_code.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'CANC'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
