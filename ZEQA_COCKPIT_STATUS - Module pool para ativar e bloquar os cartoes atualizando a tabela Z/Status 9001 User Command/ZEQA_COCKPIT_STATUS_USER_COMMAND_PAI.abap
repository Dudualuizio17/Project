*----------------------------------------------------------------------*
***INCLUDE ZEQA_COCKPIT_STATUS_I01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9001  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_9001 INPUT.

  DATA: lo_status TYPE REF TO zcleqa_status_cartao.

  CASE sy-ucomm.
    WHEN 'FFIND'.
      CLEAR: gwa_zeqa_tabela_grdr-num_cartao,
             gwa_zeqa_tabela_grdr-credito,
             gwa_zeqa_tabela_grdr-cart_block_at.

      SHIFT zeqa_tabela_grdr-num_cartao LEFT DELETING LEADING '0'.

      SELECT SINGLE * INTO gwa_zeqa_tabela_grdr
        FROM zeqa_tabela_grdr
        WHERE num_cartao EQ zeqa_tabela_grdr-num_cartao.

    WHEN 'FATIVA'.
      IF gwa_zeqa_tabela_grdr-cart_block_at = TEXT-001.

        CREATE OBJECT lo_status.

        CALL METHOD lo_status->set_status
          EXPORTING
            in_credito = gwa_zeqa_tabela_grdr-credito
            in_status  = gwa_zeqa_tabela_grdr-cart_block_at
            in_num_cartao = zeqa_tabela_grdr-num_cartao
          IMPORTING
            out_status = gwa_zeqa_tabela_grdr-cart_block_at.

      ELSE.
        MESSAGE s012(zcleqa_messages).

      ENDIF.

    WHEN 'FBLOCK'.
      IF gwa_zeqa_tabela_grdr-cart_block_at = TEXT-002.

        CREATE OBJECT lo_status.

        CALL METHOD lo_status->set_status
          EXPORTING
            in_credito = gwa_zeqa_tabela_grdr-credito
            in_status  = gwa_zeqa_tabela_grdr-cart_block_at
            in_num_cartao = zeqa_tabela_grdr-num_cartao
          IMPORTING
            out_status = gwa_zeqa_tabela_grdr-cart_block_at.

      ELSE.
        MESSAGE s013(zcleqa_messages).

      ENDIF.

    WHEN 'ENTE' OR 'CANCEL' OR 'BACK'.
      LEAVE TO SCREEN 0.
  ENDCASE.

ENDMODULE.
