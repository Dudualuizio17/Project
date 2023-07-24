  METHOD save_in_table.

    DATA: gt_zeqa_tabela_cad TYPE TABLE OF zeqa_tabela_cad.
    DATA gwa_zeqa_tabela_cad TYPE zeqa_tabela_cad.

*    SELECT SINGLE cpf INTO @gwa_zeqa_tabela_cad
*      FROM zeqa_tabela_cad
*     WHERE cpf EQ @in_cpf.

    IF sy-subrc EQ 0.

      gwa_zeqa_tabela_cad-cnpj          = in_cnpj.
      gwa_zeqa_tabela_cad-cpf           = in_cpf.
      gwa_zeqa_tabela_cad-nome          = in_nome.
      gwa_zeqa_tabela_cad-nome_pai      = in_nome_pai.
      gwa_zeqa_tabela_cad-nome_mae      = in_nome_mae.
      gwa_zeqa_tabela_cad-email         = in_email.
      gwa_zeqa_tabela_cad-endereco      = in_endereco.
      gwa_zeqa_tabela_cad-estado        = in_estado.
      gwa_zeqa_tabela_cad-cidade        = in_cidade.
      gwa_zeqa_tabela_cad-dt_nascimento = in_dt_nascimento.
      gwa_zeqa_tabela_cad-dependentes   = in_dependentes.
      gwa_zeqa_tabela_cad-dependentes_2 = in_dependentes_2.

     APPEND gwa_zeqa_tabela_cad to gt_zeqa_tabela_cad.

      MODIFY zeqa_tabela_cad FROM TABLE gt_zeqa_tabela_cad.
      COMMIT WORK.

      out_msg = 1.

    ELSE.
      out_msg = 0.
    ENDIF.

  ENDMETHOD.
