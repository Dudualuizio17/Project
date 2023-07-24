  METHOD salva_tabela.
    DATA gt_zeqa_cartoes TYPE TABLE OF zeqa_cartoes.
    DATA gt_zeqa_tabela_grdr TYPE TABLE OF zeqa_tabela_grdr.
    DATA gt_zeqa_tabela_cad TYPE TABLE OF zeqa_tabela_cad.

    DATA gwa_zeqa_tabela_cad TYPE zeqa_tabela_cad.
    DATA gwa_zeqa_tabela_grdr TYPE zeqa_tabela_grdr.
    DATA gwa_zeqa_cartoes TYPE zeqa_cartoes.

    DATA lv_cpf TYPE zeqa_tabela_grdr-cpf_colab.
    DATA lv_nome TYPE zeqa_tabela_cad-nome.


    SELECT * INTO TABLE @DATA(gt_cpf)
      FROM zeqa_cartoes.


    IF  sy-subrc EQ 0.
      LOOP AT gt_cpf INTO DATA(gwa_cpf).
        SHIFT gwa_cpf-cod_cartao LEFT DELETING LEADING '0'.
        SHIFT in_num_cartao LEFT DELETING LEADING '0'.
        IF gwa_cpf-cod_cartao EQ in_num_cartao.
          lv_cpf = gwa_cpf-cpf.

        ENDIF.

      ENDLOOP.
    ENDIF.

    SELECT * INTO TABLE @DATA(gt_nome)
          FROM zeqa_tabela_cad.

    IF sy-subrc EQ 0.
      LOOP AT gt_nome INTO DATA(gwa_nome).
        IF gwa_nome-cpf EQ lv_cpf.
          lv_nome = gwa_nome-nome.

        ENDIF.
      ENDLOOP.
    ENDIF.


    gwa_zeqa_tabela_grdr-nome_colab       = lv_nome.
    gwa_zeqa_tabela_grdr-cpf_colab        = lv_cpf.
    gwa_zeqa_tabela_grdr-num_cartao       = in_num_cartao.
    gwa_zeqa_tabela_grdr-cod_linha        = in_cod_linha.
    gwa_zeqa_tabela_grdr-credito          = in_credito.
    gwa_zeqa_tabela_grdr-dt_cred          = in_dt_cred.
    gwa_zeqa_tabela_grdr-cart_block_at    = TEXT-e01.


    APPEND gwa_zeqa_tabela_grdr TO gt_zeqa_tabela_grdr.

    MODIFY zeqa_tabela_grdr FROM TABLE gt_zeqa_tabela_grdr .
    COMMIT WORK.

  ENDMETHOD.
