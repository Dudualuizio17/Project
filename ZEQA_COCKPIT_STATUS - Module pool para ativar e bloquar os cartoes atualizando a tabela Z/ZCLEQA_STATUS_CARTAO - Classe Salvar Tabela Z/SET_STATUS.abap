  METHOD set_status.

    DATA: gt_zeqa_tabela_grdr  TYPE TABLE OF zeqa_tabela_grdr,
          gwa_zeqa_tabela_grdr TYPE zeqa_tabela_grdr.

    SHIFT in_num_cartao LEFT DELETING LEADING '0'.

    SELECT SINGLE * INTO gwa_zeqa_tabela_grdr
      FROM zeqa_tabela_grdr
      WHERE num_cartao EQ in_num_cartao.

    IF in_status = TEXT-001.

      IF in_credito >= 4.
        MESSAGE s007(zcleqa_messages).
        gwa_zeqa_tabela_grdr-cart_block_at = TEXT-002.
        out_status = TEXT-002.
      ELSE.
        MESSAGE s008(zcleqa_messages).
      ENDIF.

    ELSEIF in_status = TEXT-002.
      MESSAGE s006(zcleqa_messages).
      gwa_zeqa_tabela_grdr-cart_block_at = TEXT-001.
      out_status = TEXT-001.

    ENDIF.

    IF sy-subrc EQ 0.

      MODIFY zeqa_tabela_grdr FROM gwa_zeqa_tabela_grdr.
      COMMIT WORK.

    ENDIF.

  ENDMETHOD.
