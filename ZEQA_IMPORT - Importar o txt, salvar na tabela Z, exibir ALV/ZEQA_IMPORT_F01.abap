*&---------------------------------------------------------------------*
*&  Include           ZEQA_IMPORT_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_SELECIONA_ARQUIVO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_FILE  text
*      <--P_P_FILE  text
*----------------------------------------------------------------------*
FORM f_seleciona_arquivo  USING    p_in_file
                          CHANGING p_out_file.

  CALL FUNCTION 'WS_FILENAME_GET'
    EXPORTING
      def_filename     = p_in_file
      def_path         = 'C:\'
*     MASK             = ' '
      mode             = 'O'
      title            = 'SELECIONAR ARQUIVOS'
    IMPORTING
      filename         = p_out_file
*     RC               =
    EXCEPTIONS
      inv_winsys       = 1
      no_batch         = 2
      selection_cancel = 3
      selection_error  = 4
      OTHERS           = 5.

  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPLOAD_ARQ
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_upload_arq .
  DATA lv_filename TYPE string.
  lv_filename = p_file.

  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename                = lv_filename
    TABLES
      data_tab                = gt_upload
    EXCEPTIONS
      file_open_error         = 1
      file_read_error         = 2
      no_batch                = 3
      gui_refuse_filetransfer = 4
      invalid_type            = 5
      no_authority            = 6
      unknown_error           = 7
      bad_data_format         = 8
      header_not_allowed      = 9
      separator_not_allowed   = 10
      header_too_long         = 11
      unknown_dp_error        = 12
      access_denied           = 13
      dp_out_of_memory        = 14
      disk_full               = 15
      dp_timeout              = 16
      OTHERS                  = 17.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ELSEIF sy-subrc EQ 0.
    PERFORM f_grava_tabela.
  ENDIF.



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GRAVA_TABELA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_grava_tabela .

  DATA: lv_msg  TYPE i,
        lo_save TYPE REF TO zeqa_salvar_z. "zeqa_salvar_z.

  IF gt_upload[] IS NOT INITIAL.
    REFRESH gt_arquivo.
    LOOP AT gt_upload INTO DATA(gwa_upload).
      CLEAR gwa_arquivo.
      IF gwa_upload-linha IS NOT INITIAL.

        SPLIT gwa_upload-linha AT ';' INTO   gwa_arquivo-cnpj
                                             gwa_arquivo-cpf
                                             gwa_arquivo-nome
                                             gwa_arquivo-nome_pai
                                             gwa_arquivo-nome_mae
                                             gwa_arquivo-email
                                             gwa_arquivo-endereco
                                             gwa_arquivo-cidade
                                             gwa_arquivo-estado
                                             gwa_arquivo-dt_nascimento
                                             gwa_arquivo-dependentes
                                             gwa_arquivo-dependentes_2.
        IF gwa_arquivo IS NOT INITIAL.
          APPEND gwa_arquivo TO gt_arquivo.
        ENDIF.
      ENDIF.


*Classe para Gravar na Tabela Z
    ENDLOOP.
    LOOP AT gt_arquivo INTO DATA(lwa_arquivo).
      CREATE OBJECT lo_save.
      CALL METHOD lo_save->save_in_table
        EXPORTING
          in_cnpj          = lwa_arquivo-cnpj
          in_cpf           = lwa_arquivo-cpf
          in_nome          = lwa_arquivo-nome
          in_nome_pai      = lwa_arquivo-nome_pai
          in_nome_mae      = lwa_arquivo-nome_mae
          in_email         = lwa_arquivo-email
          in_endereco      = lwa_arquivo-endereco
          in_cidade        = lwa_arquivo-cidade
          in_estado        = lwa_arquivo-estado
          in_dt_nascimento = lwa_arquivo-dt_nascimento
          in_dependentes   = lwa_arquivo-dependentes
          in_dependentes_2 = lwa_arquivo-dependentes_2
        IMPORTING
          out_msg          = lv_msg.
    ENDLOOP.


  ENDIF.

  IF lv_msg EQ 1.
    MESSAGE s000(zcleqa_messages).

  ELSE.

    MESSAGE s001(zcleqa_messages).

  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_IMPRIME_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_imprime_alv .


  PERFORM cabecalho.
  PERFORM monta_layout.
  PERFORM monta_campo.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      is_layout              = ty_layout           "Estrutura com detalhes do layout.
      i_callback_top_of_page = 'TOP_PAGE'          "Estrutura para montar o cabeçalho
      i_callback_program     = sy-repid            "variável do sistema (nome do programa). 'Sy-repid' = 'zcurso_alv1'
*     I_CALLBACK_USER_COMMAND = 'F_USER_COMMAND'    "Chama a função "HOTSPOT"
      i_save                 = 'A'                 "layouts podem ser salvos (aparece os botões para alteração do layout).
*     it_sort                = t_sort[]             "Efetua a quebra com o parametro determinado.
      it_fieldcat            = ty_fieldcat_col     "tabela com as colunas a serem impressas.
    TABLES
      t_outtab               = gt_arquivo.          "Tabela com os dados a serem impressos.

ENDFORM.

*&---------------------------------------------------------------------*
*&      FORM  CABECALHO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM cabecalho .

  DATA: vl_data(10),
        vl_hora(10).

  CLEAR ty_watop.
  ty_watop-typ  = 'H'.    "H = Grande, destaque | S = Pequena | A = Média com itálico
  ty_watop-info = TEXT-m01.

  APPEND ty_watop TO ty_top.

  CLEAR ty_watop.

  ty_watop-typ  = 'S'.
  CONCATENATE TEXT-m02 sy-uname
    INTO ty_watop-info
      SEPARATED BY space.

  APPEND ty_watop TO ty_top.

  CLEAR ty_watop.

  ty_watop-typ  = 'S'.

  WRITE sy-datum TO vl_data USING EDIT MASK '__/__/____'.
  WRITE sy-uzeit TO vl_hora USING EDIT MASK '__:__'.

  CONCATENATE TEXT-m03 vl_data  vl_hora
    INTO ty_watop-info
      SEPARATED BY space.

  APPEND ty_watop TO ty_top.

ENDFORM.                    " f_header

*&**********************************************************************
*&      FORM TOP_PAGE                                              *
*&**********************************************************************
*       Defines the header of the ALV
*----------------------------------------------------------------------*
FORM top_page.
  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = ty_top.
*      I_LOGO             = ''.

ENDFORM.                    "top_page

*&---------------------------------------------------------------------*
*&      FORM  MONTA_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM monta_layout .
  ty_layout-zebra             = 'X'.                            "Zebrado
  ty_layout-colwidth_optimize = 'X'.                            "Otimizar larguras de colunas automaticamente
ENDFORM.                    " MONTA_LAYOUT

*&---------------------------------------------------------------------*
*&      FORM  monta_campo
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM monta_campo .
  "CLEAR IT_HRP1000.

  PERFORM monta_coluna USING  'CNPJ'          'gt_arquivo' TEXT-t01      ' '  ' '  '12'  ' '  'L'  ' ' ' '.
  PERFORM monta_coluna USING  'CPF'           'gt_arquivo' TEXT-t02      ' '  ' '  '80'  ' '  'L'  ' ' ' '.
  PERFORM monta_coluna USING  'NOME'          'gt_arquivo' TEXT-t03      ' '  ' '  '20'  ' '  'L'  ' ' ' '.
  PERFORM monta_coluna USING  'NOME_PAI'      'gt_arquivo' TEXT-t04      ' '  ' '  '20'  ' '  'L'  ' ' ' '.
  PERFORM monta_coluna USING  'NOME_MAE'      'gt_arquivo' TEXT-t10      ' '  ' '  '20'  ' '  'L'  ' ' ' '.
  PERFORM monta_coluna USING  'EMAIL'         'gt_arquivo' TEXT-t05      ' '  ' '  '20'  ' '  'L'  ' ' ' '.
  PERFORM monta_coluna USING  'ENDERECO'      'gt_arquivo' TEXT-t06      ' '  ' '  '20'  ' '  'L'  ' ' ' '.
  PERFORM monta_coluna USING  'CIDADE'        'gt_arquivo' TEXT-t07      ' '  ' '  '20'  ' '  'L'  ' ' ' '.
  PERFORM monta_coluna USING  'ESTADO'        'gt_arquivo' TEXT-t08      ' '  ' '  '20'  ' '  'L'  ' ' ' '.
  PERFORM monta_coluna USING  'DT_NASCIMENTO' 'gt_arquivo' TEXT-t09      ' '  ' '  '20'  ' '  'L'  ' ' ' '.
  PERFORM monta_coluna USING  'DEPENDENTES'   'gt_arquivo' TEXT-t11      ' '  ' '  '20'  ' '  'L'  ' ' ' '.
  PERFORM monta_coluna USING  'DEPENDENTES_2' 'gt_arquivo' TEXT-t11      ' '  ' '  '20'  ' '  'L'  ' ' ' '.

ENDFORM.                    "monta_campo

*&---------------------------------------------------------------------*
*&       FORM monta_coluna                                             *
*----------------------------------------------------------------------*
*        Clears all tables and variables.
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
  ty_fieldcat-col_pos       = vg_nrcol.            "POSIÇÃO DO CAMPO (COLUNA).
  ty_fieldcat-fieldname     = p_fieldname.         "CAMPO DA TABELA INTERNA.
  ty_fieldcat-tabname       = p_tabname.           "TABELA INTERNA.
  ty_fieldcat-seltext_l     = p_texto.             "NOME/TEXTO DA COLUNA.
  ty_fieldcat-ref_fieldname = p_ref_fieldname.     "CAMPO DE REFERÊNCIA.
  ty_fieldcat-ref_tabname   = p_ref_tabname.       "TABELA DE REFERÊNCIA.
  ty_fieldcat-outputlen     = p_outputlen.         "LARGURA DA COLUNA.
  ty_fieldcat-emphasize     = p_emphasize.         "COLORE UMA COLUNA INTEIRA.
  ty_fieldcat-just          = p_just.              "
  ty_fieldcat-do_sum        = p_do_sum.            "TOTALIZA.
  ty_fieldcat-icon          = p_icon.

  APPEND ty_fieldcat TO ty_fieldcat_col.           "Insere linha na tabela interna TY_FIELDCAT_COL.

ENDFORM.                    "Monta_coluna

*&---------------------------------------------------------------------*
*&      Form  F_PRINT_REPORT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*FORM f_imprime_report.
*  DATA lwa_zeqa_tabela_cad TYPE zeqa_tabela_cad.
*
*  SELECT * INTO TABLE @DATA(lt_zeqa_tabela_cad)
*    FROM zeqa_tabela_cad.
*
*  IF sy-subrc EQ 0.
*
*    LOOP AT lt_zeqa_tabela_cad INTO lwa_zeqa_tabela_cad.
*
*      CLEAR gwa_report.
*
*      gwa_report-cnpj           = lwa_zeqa_tabela_cad-cnpj.
*      gwa_report-cpf            = lwa_zeqa_tabela_cad-cpf .
*      gwa_report-nome           = lwa_zeqa_tabela_cad-nome.
*      gwa_report-nome_pai       = lwa_zeqa_tabela_cad-nome_pai.
*      gwa_report-nome_mae       = lwa_zeqa_tabela_cad-nome_mae.
*      gwa_report-email          = lwa_zeqa_tabela_cad-email.
*      gwa_report-endereco       = lwa_zeqa_tabela_cad-endereco.
*      gwa_report-cidade         = lwa_zeqa_tabela_cad-cidade.
*      gwa_report-estado         = lwa_zeqa_tabela_cad-estado.
*      gwa_report-dt_nascimento  = lwa_zeqa_tabela_cad-dt_nascimento.
*      gwa_report-dependentes    = lwa_zeqa_tabela_cad-dependentes.
*      gwa_report-dependentes_2  = lwa_zeqa_tabela_cad-dependentes_2.
*
*      APPEND gwa_report TO gt_report.
*
*    ENDLOOP.
*
*    PERFORM f_imprime_alv.
*
*  ENDIF.
*
*ENDFORM.
