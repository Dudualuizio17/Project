*&---------------------------------------------------------------------*
*&  Include           ZEQA_R_CARTAO_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_GET_DADOS
*&---------------------------------------------------------------------*
FORM f_get_dados.

  DATA lv_data_validade TYPE sy-datum.

  SELECT * INTO CORRESPONDING FIELDS OF TABLE gt_arquivo
    FROM zeqa_tabela_cad
    WHERE cnpj IN s_cnpj.


  SELECT SINGLE low INTO @DATA(lv_low)
  FROM tvarvc
  WHERE name = 'ZEQA_DIAS_VALIDADE'
AND type = 'P'.

  IF sy-subrc = 0.
    lv_data_validade = sy-datum + lv_low. "
    MESSAGE i000 WITH 'Validade Calculada:' lv_data_validade.
  ELSE.
    "Não encontrou parametro na TVARV para Validade

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SELECAO_ARQUIVO
*&---------------------------------------------------------------------*
FORM f_selecao_arquivo  USING    p_in_file
                        CHANGING p_out_file.

  CALL FUNCTION 'WS_FILENAME_GET'
    EXPORTING
      def_filename     = p_in_file
      def_path         = 'C:\'
   "  MASK             = ',*.*,*.*'
      mode             = 'S'
      title            = 'SELECÇÃO DE ARQUIVOS'
    IMPORTING
      filename         = p_out_file
*     RC               =
    EXCEPTIONS
      inv_winsys       = 1
      no_batch         = 2
      selection_cancel = 3
      selection_error  = 4
      OTHERS           = 5.
  .
  IF sy-subrc <> 0.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SAVE_FILE
*&---------------------------------------------------------------------*
FORM f_save_file.

  DATA lv_name_file TYPE string.
  lv_name_file = p_file.

  CALL FUNCTION 'GUI_DOWNLOAD'
    EXPORTING
      filename                = lv_name_file
*     write_field_separator   = abap_true
    TABLES
      data_tab                = gt_file_tratado
    EXCEPTIONS
      file_write_error        = 1
      no_batch                = 2
      gui_refuse_filetransfer = 3
      invalid_type            = 4
      no_authority            = 5
      unknown_error           = 6
      header_not_allowed      = 7
      separator_not_allowed   = 8
      filesize_not_allowed    = 9
      header_too_long         = 10
      dp_error_create         = 11
      dp_error_send           = 12
      dp_error_write          = 13
      unknown_dp_error        = 14
      access_denied           = 15
      dp_out_of_memory        = 16
      disk_full               = 17
      dp_timeout              = 18
      file_not_found          = 19
      dataprovider_exception  = 20
      control_flush_error     = 21
      OTHERS                  = 22.

  IF sy-subrc <> 0.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_IMPRIME_RELATORIO
*&---------------------------------------------------------------------*
FORM f_imprime_relatorio.

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
      t_outtab               = gt_report.          "Tabela com os dados a serem impressos.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CABECALHO
*&---------------------------------------------------------------------*
FORM cabecalho .

  DATA: txt_lines(4) TYPE c.

  DATA: vl_data(10),
        vl_validade(10).

  CLEAR ty_watop.
  ty_watop-typ  = 'H'.    "H = Grande, destaque | S = Pequena | A = Média com itálico
  ty_watop-info = TEXT-m01. "Dados dos Colaborador- Cabecalho

  APPEND ty_watop TO ty_top.

  CLEAR ty_watop.

  ty_watop-typ  = 'S'.

  "Usuário
  CONCATENATE TEXT-j01 sy-uname
    INTO ty_watop-info
      SEPARATED BY space.

  APPEND ty_watop TO ty_top.

  CLEAR ty_watop.

  ty_watop-typ  = 'S'.

  WRITE sy-datum TO vl_data USING EDIT MASK '__/__/____'.
  WRITE sy-datum  TO vl_validade USING EDIT MASK '__/__/____'.

  "Data/validade
  CONCATENATE TEXT-j02 vl_data  vl_validade
    INTO ty_watop-info
      SEPARATED BY space.

  APPEND ty_watop TO ty_top.
  CLEAR ty_watop.

  DESCRIBE TABLE gt_report LINES DATA(l_lines).
  UNPACK l_lines TO txt_lines.
  CONCATENATE TEXT-012 txt_lines INTO ty_watop SEPARATED BY space.

  APPEND ty_watop TO ty_top.
ENDFORM.
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

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  MONTA_LAYOUT
*&---------------------------------------------------------------------*
FORM monta_layout .
  ty_layout-zebra             = 'X'.                            "Zebrado
  ty_layout-colwidth_optimize = 'X'.                            "Otimizar larguras de colunas automaticamente
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  MONTA_CAMPO
*&---------------------------------------------------------------------*
FORM monta_campo .

  PERFORM monta_coluna USING  'CNPJ'            'GT_REPORT' TEXT-r01      ' '  ' '  '12'  ' '  'L'  ' ' ' '.
  PERFORM monta_coluna USING  'COD_CARTAO'      'GT_REPORT' TEXT-r02      ' '  ' '  '10'  ' '  'L'  ' ' ' '.
  PERFORM monta_coluna USING  'CPF'             'GT_REPORT' TEXT-r03      ' '  ' '  '80'  ' '  'L'  ' ' ' '.
  PERFORM monta_coluna USING  'NOME'            'GT_REPORT' TEXT-r04      ' '  ' '  '80'  ' '  'L'  ' ' ' '.
  PERFORM monta_coluna USING  'DATA_EMISSAO'    'GT_REPORT' TEXT-r05      ' '  ' '  '10'  ' '  'L'  ' ' ' '.
  PERFORM monta_coluna USING  'DATA_VALIDADE'   'GT_REPORT' TEXT-r06      ' '  ' '  '50'  ' '  'L'  ' ' ' '.
  PERFORM monta_coluna USING  'CREDITO'         'GT_REPORT' TEXT-r07      ' '  ' '  '50'  ' '  'L'  ' ' ' '.
  PERFORM monta_coluna USING  'MENSAGEM'        'GT_REPORT' TEXT-r08      ' '  ' '  '50'  ' '  'L'  ' ' ' '.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  MONTA_COLUNA
*&---------------------------------------------------------------------*
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

  APPEND ty_fieldcat TO ty_fieldcat_col.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUSCA_DADOS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_busca_dados.

  DATA: gt_cad     TYPE STANDARD TABLE OF zeqa_tabela_cad,
        gt_cartoes TYPE STANDARD TABLE OF zeqa_cartoes,
        gt_novo    TYPE STANDARD TABLE OF zeqa_cartoes,
        gwa_cartao TYPE zeqa_cartoes.

  DATA: gv_criado TYPE i.
  DATA: gv_existe TYPE i.

  SELECT *  INTO TABLE gt_cad
  FROM zeqa_tabela_cad
  WHERE  cnpj IN  s_cnpj
*    and  ativo = abap_true
    AND cpf NE space. "NE = diferente NOT EQUAL / EQ ( = )

  IF sy-subrc <> 0.
    MESSAGE e000 WITH TEXT-e01.
  ENDIF.

  SORT gt_cad BY cpf.
  "calcular data de validade

  SELECT * INTO TABLE gt_cartoes
    FROM zeqa_cartoes
    FOR ALL ENTRIES IN gt_cad
    WHERE cpf = gt_cad-cpf
AND data_validade GE sy-datum
    AND ativo EQ abap_true.

  SORT gt_cartoes BY cpf.

  DATA lv_data_validade TYPE sy-datum.


  SELECT SINGLE low INTO @DATA(lv_low)
  FROM tvarvc
  WHERE name = 'ZEQA_DIAS_VALIDADE'
AND type = 'P'.

  IF sy-subrc = 0.
    lv_data_validade = sy-datum + lv_low. "

  ELSE.
    MESSAGE e002.
  ENDIF.


  SELECT MAX( cod_cartao )
FROM zeqa_cartoes
INTO @DATA(lv_numero) .

  CLEAR gt_file_tratado[].

*  APPEND gwa_file_tratado TO gt_file_tratado.
  CLEAR: gwa_report, gwa_file_tratado.

  LOOP AT gt_cad INTO DATA(ls_cad).

    READ TABLE gt_cartoes INTO DATA(ls_cartoes) WITH KEY cpf = ls_cad-cpf.
    IF sy-subrc = 0.
*      ADD 1 TO gv_existe.
      MOVE-CORRESPONDING ls_cartoes TO gwa_report.
      gwa_report-cnpj = ls_cad-cnpj.
      gwa_report-nome = ls_cad-nome.
      gwa_report-mensagem = TEXT-010. "Cartão Existente

      CONCATENATE gwa_report-cod_cartao gwa_report-cpf gwa_report-nome gwa_report-data_emissao gwa_report-data_validade INTO gwa_file_tratado-linha SEPARATED BY ';'.
      APPEND gwa_file_tratado TO gt_file_tratado.


      APPEND gwa_report TO gt_report.
      CLEAR: gwa_report, gwa_file_tratado.

      CONTINUE.

    ENDIF.

    "CRIAR CARTÃO NOVO
    ADD 1 TO lv_numero.
    gwa_cartao-cod_cartao = lv_numero.
    gwa_cartao-cpf = ls_cad-cpf.
    gwa_cartao-data_emissao = sy-datum.
    gwa_cartao-data_validade = lv_data_validade.
    gwa_cartao-ativo = abap_true.
    gwa_report-cnpj = ls_cad-cnpj.
    gwa_report-nome = ls_cad-nome.

    CONCATENATE gwa_cartao-cod_cartao gwa_cartao-cpf gwa_report-nome gwa_cartao-data_emissao gwa_cartao-data_validade INTO gwa_file_tratado-linha SEPARATED BY ';'.
    APPEND gwa_file_tratado TO gt_file_tratado.


    APPEND gwa_cartao TO gt_novo.
    CLEAR gwa_cartao.

    MOVE-CORRESPONDING ls_cartoes TO gwa_report.
    gwa_report-mensagem = TEXT-011. "Cartão Criado com Sucesso
    APPEND gwa_report TO gt_report.

    CLEAR: gwa_report, gwa_file_tratado.

  ENDLOOP.

  IF gt_novo[] IS NOT INITIAL.
    INSERT  zeqa_cartoes FROM TABLE gt_novo.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DOWNLOAD_ARQUIVO
*&---------------------------------------------------------------------*
FORM f_download_arquivo .

ENDFORM.
