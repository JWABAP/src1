*&---------------------------------------------------------------------*
*& Include          ZC1R150001_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  EXIT_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_0100 INPUT.

  CALL METHOD : gcl_grid->free( ), gcl_container->free( ).

  FREE : gcl_grid, gcl_container.

  LEAVE TO SCREEN 0.

ENDMODULE.
