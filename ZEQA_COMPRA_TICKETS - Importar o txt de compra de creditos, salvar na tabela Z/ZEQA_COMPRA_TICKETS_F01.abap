*----------------------------------------------------------------------*
***INCLUDE ZEQA_COMPRA_TICKETS_F01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_SELECIONA_ARQUIVO
*&---------------------------------------------------------------------*
FORM f_seleciona_arquivo  USING    p_in_file
                          CHANGING p_out_file.

  CALL FUNCTION 'WS_FILENAME_GET'
    EXPORTING
      def_filename     = p_in_file
      def_path         = 'C:\'
      mask             = ' '
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
    MESSAGE e010(zcleqa_messages).
  ELSE.
    MESSAGE s011(zcleqa_messages).
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
      filename = lv_filename
    TABLES
      data_tab = gt_upload.
  IF sy-subrc <> 0.
    MESSAGE e002(zcleqa_messages).
  ELSE.
    MESSAGE s000(zcleqa_messages).
    PERFORM get_dados.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DADOS
*&---------------------------------------------------------------------*
FORM get_dados.

  DATA: lo_salva_tabela TYPE REF TO zcleqa_salvar_credito.

  IF gt_upload[] IS NOT INITIAL.
    REFRESH gt_arquivo.
    LOOP AT gt_upload INTO DATA(gwa_upload).
      CLEAR gwa_arquivo.
      SPLIT gwa_upload-linha AT ';' INTO gwa_arquivo-codfunc
                                         gwa_arquivo-codlinha
                                         gwa_arquivo-valcred
                                         gwa_arquivo-dtcredito.
      IF gwa_arquivo IS NOT INITIAL.
        APPEND gwa_arquivo TO gt_arquivo.

      ENDIF.
    ENDLOOP.
    LOOP AT gt_arquivo INTO DATA(lwa_arquivo).

      DATA lv_num TYPE betrg.
      DATA erro TYPE REF TO cx_sy_conversion_error.

      TRY .

          CALL FUNCTION 'HRCM_STRING_TO_AMOUNT_CONVERT'
            EXPORTING
              string              = lwa_arquivo-valcred
              decimal_separator   = '.'
              thousands_separator = ','
              waers               = 'BRL '
            IMPORTING
              betrg               = lv_num.

*      IF sy-subrc <> 0.
* *Implement suitable error handling here
*      ENDIF.

        CATCH cx_sy_conversion_error INTO erro .
          MESSAGE 'Varmengo' TYPE 'I'.

      ENDTRY.

      CREATE OBJECT lo_salva_tabela.
      CALL METHOD lo_salva_tabela->salva_tabela
        EXPORTING
          in_num_cartao = lwa_arquivo-codfunc
          in_cod_linha  = lwa_arquivo-codlinha
          in_credito    = lv_num
          in_dt_cred    = lwa_arquivo-dtcredito.
*  IMPORTING
*         out_msg       =
    ENDLOOP.
  ENDIF.

ENDFORM.
