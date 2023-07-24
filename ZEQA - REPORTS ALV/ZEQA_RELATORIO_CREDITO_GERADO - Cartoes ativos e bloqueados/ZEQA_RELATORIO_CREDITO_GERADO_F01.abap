*&---------------------------------------------------------------------*
*&  Include           ZEQA_REPORT_CREDITOS_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_GET_DADOS
*&---------------------------------------------------------------------*
form f_get_dados .

  select * into corresponding fields of table gt_zeqa_tabela_grdr
  from zeqa_tabela_grdr
 where cpf_colab in s_cpf.

endform.
*&---------------------------------------------------------------------*
*&      Form  MONTA_DADOS
*&---------------------------------------------------------------------*
form f_monta_dados .

*  data: vl_cartao type string.
  data: vl_cartao type i.

  loop at gt_zeqa_tabela_grdr into gwa_zeqa_tabela_grdr.

    clear gwa_relatorio.

    gwa_relatorio-credito     = gwa_zeqa_tabela_grdr-credito.       "Crédito do Cartão
    gwa_relatorio-num_cartao  = gwa_zeqa_tabela_grdr-num_cartao.    "Código do cartão
    gwa_relatorio-cpf         = gwa_zeqa_tabela_grdr-cpf_colab.     "CPF
    gwa_relatorio-nome        = gwa_zeqa_tabela_grdr-nome_colab.    "Nome do Colaborador
    gwa_relatorio-dt_cred     = gwa_zeqa_tabela_grdr-dt_cred.       "Data do crédito
    gwa_relatorio-cartao      = gwa_zeqa_tabela_grdr-cart_block_at. "Status do cartão
    gwa_relatorio-cod_linha   = gwa_zeqa_tabela_grdr-cod_linha.     "Status do cartão
*
    append gwa_relatorio to gt_relatorio.
*
  endloop.

endform.
*&---------------------------------------------------------------------*
*&      Form  F_IMPRIME_RELATORIO
*&---------------------------------------------------------------------*
form f_imprime_relatorio .

  perform cabecalho.
  perform monta_layout.
  perform monta_campo.

  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
      is_layout              = ty_layout           "estrutura com detalhes do layout.
      i_callback_top_of_page = 'TOP_PAGE'          "Estrutura para montar o cabeçalho
      i_callback_program     = sy-repid            "variável do sistema (nome do programa). 'Sy-repid' = 'zcurso_alv1'
*     I_CALLBACK_USER_COMMAND = 'F_USER_COMMAND'    "Chama a função "HOTSPOT"
      i_save                 = 'A'                 "layouts podem ser salvos (aparece os botões para alteração do layout).
*     it_sort                = t_sort[]             "Efetua a quebra com o parametro determinado.
      it_fieldcat            = ty_fieldcat_col     "tabela com as colunas a serem impressas.
    tables
      t_outtab               = gt_relatorio.          "Tabela com os dados a serem impressos.

endform.
*&---------------------------------------------------------------------*
*&      Form  CABECALHO
*&---------------------------------------------------------------------*
form cabecalho .

  data: vl_data(10),
        vl_hora(10).

  clear ty_watop.
  ty_watop-typ  = 'H'.      "H = Grande, destaque | S = Pequena | A = Média com itálico
  ty_watop-info = text-j01. "Créditos Gerados

  append ty_watop to ty_top.

  clear ty_watop.

  ty_watop-typ  = 'S'.

  "Usuário
  concatenate text-j02 sy-uname
    into ty_watop-info
      separated by space.

  append ty_watop to ty_top.

  clear ty_watop.

  ty_watop-typ  = 'S'.

  write sy-datum to vl_data using edit mask '__/__/____'.
  write sy-uzeit to vl_hora using edit mask '__:__'.

  "Data/Hora
  concatenate text-j03 vl_data  vl_hora
    into ty_watop-info
      separated by space.

  append ty_watop to ty_top.

endform.                    " CABECALHO
*&**********************************************************************
*&      Form  top_page                                                 *
*&**********************************************************************
*       Define o cabeçalho do ALV
*----------------------------------------------------------------------*
form top_page.
  call function 'REUSE_ALV_COMMENTARY_WRITE'
    exporting
      it_list_commentary = ty_top.
*      i_logo             = ''.

endform.                    "top_page
*&---------------------------------------------------------------------*
*&      Form  MONTA_LAYOUT
*&---------------------------------------------------------------------*
form monta_layout .
  ty_layout-zebra             = 'X'.                            "Zebrado
  ty_layout-colwidth_optimize = 'X'.                            "Otimizar larguras de colunas automaticamente
endform.                    " MONTA_LAYOUT
*&---------------------------------------------------------------------*
*&      Form  MONTA_CAMPO
*&---------------------------------------------------------------------*
form monta_campo .

  perform monta_coluna using  'NUM_CARTAO'  'GT_RELATORIO' text-t01     ' '  ' '  '50'  ' '  'L'  ' ' ' '.
  perform monta_coluna using  'CREDITO'     'GT_RELATORIO' text-t05     ' '  ' '  '50'  ' '  'L'  ' ' ' '.
  perform monta_coluna using  'COD_LINHA'   'GT_RELATORIO' text-t06     ' '  ' '  '50'  ' '  'L'  ' ' ' '.
  perform monta_coluna using  'CPF'         'GT_RELATORIO' text-t02     ' '  ' '  '50'  ' '  'L'  ' ' ' '.
  perform monta_coluna using  'NOME'        'GT_RELATORIO' text-t08     ' '  ' '  '50'  ' '  'L'  ' ' ' '.
  perform monta_coluna using  'DT_CRED'     'GT_RELATORIO' text-t03     ' '  ' '  '50'  ' '  'L'  ' ' ' '.
*  perform monta_coluna using  'ICON_FIELD'  'GT_RELATORIO' text-t06     ' '  ' '  '50'  ' '  'L'  ' ' ' '.
  perform monta_coluna using  'CARTAO'      'GT_RELATORIO' text-t07     ' '  ' '  '50'  ' '  'L'  ' ' ' '.

endform.                    " MONTA_CAMPO
*&---------------------------------------------------------------------*
*&       FORM MONTA_COLUNA                                             *
*----------------------------------------------------------------------*
*        Limpa todas as tabelas e variáveis.
*----------------------------------------------------------------------*
form monta_coluna using p_fieldname
                        p_tabname
                        p_texto
                        p_ref_fieldname
                        p_ref_tabname
                        p_outputlen
                        p_emphasize
                        p_just
                        p_do_sum
                        p_icon.

  add 1 to vg_nrcol.
  ty_fieldcat-col_pos       = vg_nrcol.            "Posição do campo (coluna).
  ty_fieldcat-fieldname     = p_fieldname.         "Campo da tabela interna.
  ty_fieldcat-tabname       = p_tabname.           "Tabela interna.
  ty_fieldcat-seltext_l     = p_texto.             "Nome/texto da coluna.
  ty_fieldcat-ref_fieldname = p_ref_fieldname.     "Campo de referência.
  ty_fieldcat-ref_tabname   = p_ref_tabname.       "Tabela de referência.
  ty_fieldcat-outputlen     = p_outputlen.         "Largura da coluna.
  ty_fieldcat-emphasize     = p_emphasize.         "Colore uma coluna inteira.
  ty_fieldcat-just          = p_just.              "
  ty_fieldcat-do_sum        = p_do_sum.            "Totaliza.
  ty_fieldcat-icon          = p_icon.

  append ty_fieldcat to ty_fieldcat_col.           "Insere linha na tabela interna TY_FIELDCAT_COL.

endform.                    " F_monta_coluna*&---------------------------------------------------------------------*
