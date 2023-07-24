*&---------------------------------------------------------------------*
*&  Include           ZEQA_REPORT_FUNCIONARIOS_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_GET_DADOS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_dados.

  SELECT * INTO CORRESPONDING FIELDS OF TABLE gt_zeqa_tabela_cad
    FROM zeqa_tabela_cad

    WHERE cnpj in s_cnpj.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_MONTA_DADOS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_monta_dados .

  LOOP AT gt_zeqa_tabela_cad INTO gwa_zeqa_tabela_cad.
    CLEAR gwa_relatorio.
    gwa_relatorio-cnpj = gwa_zeqa_tabela_cad-cnpj.
    gwa_relatorio-cpf = gwa_zeqa_tabela_cad-cpf.
    gwa_relatorio-nome = gwa_zeqa_tabela_cad-nome.
    gwa_relatorio-nome_pai = gwa_zeqa_tabela_cad-nome_pai.
    gwa_relatorio-nome_mae = gwa_zeqa_tabela_cad-nome_mae.
    gwa_relatorio-email = gwa_zeqa_tabela_cad-email.
    gwa_relatorio-endereco = gwa_zeqa_tabela_cad-endereco.
    gwa_relatorio-cidade = gwa_zeqa_tabela_cad-cidade.
    gwa_relatorio-estado = gwa_zeqa_tabela_cad-estado.
    gwa_relatorio-dt_nascimento = gwa_zeqa_tabela_cad-dt_nascimento.
    gwa_relatorio-dependentes = gwa_zeqa_tabela_cad-dependentes.
    gwa_relatorio-dependentes_2 = gwa_zeqa_tabela_cad-dependentes_2.
*
    APPEND gwa_relatorio TO gt_relatorio.
  ENDLOOP.


ENDFORM.



*&---------------------------------------------------------------------*
*&      Form  F_IMPRIME_RELATORIO
*&---------------------------------------------------------------------*
FORM f_imprime_relatorio .

  PERFORM cabecalho.
  PERFORM monta_layout.
  PERFORM monta_campo.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      is_layout              = ty_layout           "estrutura com detalhes do layout.
      i_callback_top_of_page = 'TOP_PAGE'          "Estrutura para montar o cabeçalho
      i_callback_program     = sy-repid            "variável do sistema (nome do programa). 'Sy-repid' = 'zcurso_alv1'
*     I_CALLBACK_USER_COMMAND = 'F_USER_COMMAND'    "Chama a função "HOTSPOT"
      i_save                 = 'A'                 "layouts podem ser salvos (aparece os botões para alteração do layout).
*     it_sort                = t_sort[]             "Efetua a quebra com o parametro determinado.
      it_fieldcat            = ty_fieldcat_col     "tabela com as colunas a serem impressas.
    TABLES
      t_outtab               = gt_relatorio.          "Tabela com os dados a serem impressos.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CABECALHO
*&---------------------------------------------------------------------*
FORM cabecalho .

  DATA: vl_data(10),
        vl_hora(10).

  CLEAR ty_watop.
  ty_watop-typ  = 'H'.       "H = Grande, destaque | S = Pequena | A = Média com itálico
  ty_watop-info = TEXT-j01.  "Funcionários

  APPEND ty_watop TO ty_top.

  CLEAR ty_watop.

  ty_watop-typ  = 'S'.

  "Usuário
  CONCATENATE TEXT-j02 sy-uname
    INTO ty_watop-info
      SEPARATED BY space.

  APPEND ty_watop TO ty_top.

  CLEAR ty_watop.

  ty_watop-typ  = 'S'.

  WRITE sy-datum TO vl_data USING EDIT MASK '__/__/____'.
  WRITE sy-uzeit TO vl_hora USING EDIT MASK '__:__'.

  "Data/Hora
  CONCATENATE TEXT-j03 vl_data  vl_hora
    INTO ty_watop-info
      SEPARATED BY space.

  APPEND ty_watop TO ty_top.

ENDFORM.                    " CABECALHO
*&**********************************************************************
*&      Form  top_page                                                 *
*&**********************************************************************
*       Define o cabeçalho do ALV
*----------------------------------------------------------------------*
FORM top_page.
  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = ty_top.
*      i_logo             = ''.

ENDFORM.                    "top_page
*&---------------------------------------------------------------------*
*&      Form  MONTA_LAYOUT
*&---------------------------------------------------------------------*
FORM monta_layout .
  ty_layout-zebra             = 'X'.                            "Zebrado
  ty_layout-colwidth_optimize = 'X'.                            "Otimizar larguras de colunas automaticamente
ENDFORM.                    " MONTA_LAYOUT
*&---------------------------------------------------------------------*
*&      Form  MONTA_CAMPO
*&---------------------------------------------------------------------*
FORM monta_campo .

  PERFORM monta_coluna USING  'CNPJ'           'GT_RELATORIO' TEXT-t01     ' '  ' '  '50'  ' '  'L'  ' ' ' '.
  PERFORM monta_coluna USING  'CPF'            'GT_RELATORIO' TEXT-t02     ' '  ' '  '50'  ' '  'L'  ' ' ' '.
  PERFORM monta_coluna USING  'NOME'           'GT_RELATORIO' TEXT-t03     ' '  ' '  '80'  ' '  'L'  ' ' ' '.
  PERFORM monta_coluna USING  'NOME_PAI'       'GT_RELATORIO' TEXT-t04     ' '  ' '  '80'  ' '  'L'  ' ' ' '.
  PERFORM monta_coluna USING  'NOME_MAE'       'GT_RELATORIO' TEXT-t05     ' '  ' '  '80'  ' '  'L'  ' ' ' '.
  PERFORM monta_coluna USING  'EMAIL'          'GT_RELATORIO' TEXT-t06     ' '  ' '  '80'  ' '  'L'  ' ' ' '.
  PERFORM monta_coluna USING  'DEPENDENTES'    'GT_RELATORIO' TEXT-t12     ' '  ' '  '80'  ' '  'L'  ' ' ' '.
  PERFORM monta_coluna USING  'DEPENDENTES_2'  'GT_RELATORIO' TEXT-t11     ' '  ' '  '80'  ' '  'L'  ' ' ' '.
  PERFORM monta_coluna USING  'ENDERECO'       'GT_RELATORIO' TEXT-t07     ' '  ' '  '80'  ' '  'L'  ' ' ' '.
  PERFORM monta_coluna USING  'CIDADE'         'GT_RELATORIO' TEXT-t08     ' '  ' '  '80'  ' '  'L'  ' ' ' '.
  PERFORM monta_coluna USING  'ESTADO'         'GT_RELATORIO' TEXT-t09     ' '  ' '  '80'  ' '  'L'  ' ' ' '.
  PERFORM monta_coluna USING  'DT_NASCIMENTO'  'GT_RELATORIO' TEXT-t10     ' '  ' '  '80'  ' '  'L'  ' ' ' '.

ENDFORM.                    " MONTA_CAMPO
*&---------------------------------------------------------------------*
*&       FORM MONTA_COLUNA                                             *
*----------------------------------------------------------------------*
*        Limpa todas as tabelas e variáveis.
*----------------------------------------------------------------------*
FORM monta_coluna USING p_fieldname
                        p_tabname
                        p_texto
                        p_ref_fieldname
                        p_ref_tabname
                        p_outputlen
                        p_emphasize
                        p_just
                        p_do_sum
                        p_icon.

  ADD 1 TO vg_nrcol.
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

  APPEND ty_fieldcat TO ty_fieldcat_col.           "Insere linha na tabela interna TY_FIELDCAT_COL.

ENDFORM.                    " F_monta_coluna*&---------------------------------------------------------------------*
