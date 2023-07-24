*&---------------------------------------------------------------------*
*&  Include           ZEQA_EXTRAIR_LINHA_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  FORM f_select_file
*&---------------------------------------------------------------------*
FORM f_select_file  USING    p_in_file
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
* IMPLEMENT SUITABLE ERROR HANDLING HERE
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_data .
  DATA: lo_file   TYPE REF TO ZCLEQA_EXTRAIR_LINHA,
        lv_string TYPE string.

  CREATE OBJECT lo_file.

  SELECT COD_LINHA INTO TABLE @DATA(lt_cod_linha)
    FROM ZEQA_TABELA_LINH
    WHERE cod_linha IN @s_codlin.

  IF sy-subrc EQ 0.

    LOOP AT lt_cod_linha INTO DATA(lwa_codlinha).

      CALL METHOD lo_file->SET_GERAR
        EXPORTING
          IN_CODLINHA = lwa_codlinha-COD_LINHA
        IMPORTING
         OUT_LINE    = lv_string.



      CLEAR gwa_file.
      gwa_file-line = lv_string.
      APPEND gwa_file TO gt_file.

    ENDLOOP.

  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_SAVE_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_save_file .
  DATA lv_name_file TYPE string.

  lv_name_file = p_file.

  CALL FUNCTION 'GUI_DOWNLOAD'
    EXPORTING
      filename                = lv_name_file
    TABLES
      data_tab                = gt_file
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
* Implement suitable error handling here
    MESSAGE s003(ZCLEQA_MESSAGES).

  ELSEIF sy-subrc EQ 0.
    MESSAGE s001(ZCLEQA_MESSAGES).

    ENDIF.

ENDFORM.
