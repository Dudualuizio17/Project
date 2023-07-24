*======================================================================
*
*                                HRST
*
*======================================================================
* Author      : Fábrica ABAP
* Analist     : Equipe A
* Date        : 03/07/2023
*----------------------------------------------------------------------
* Project     : Projeto
* Report      : Cockpit HRST
* Finality    :
*----------------------------------------------------------------------
* Changes History
*----------------------------------------------------------------------
* Date         | Author         | Finality
* 07/07/2023   | Equipe A       | Extrair Linha
*======================================================================*
*&---------------------------------------------------------------------*
*& Report ZEQA_EXTRAIR_LINHA
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEQA_EXTRAIR_LINHA.

INCLUDE ZEQA_EXTRAIR_LINHA_TOP.
INCLUDE ZEQA_EXTRAIR_LINHA_SCR.
INCLUDE ZEQA_EXTRAIR_LINHA_F01.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  PERFORM f_select_file USING p_file
                         CHANGING p_file.

START-OF-SELECTION.

  PERFORM f_get_data.
  PERFORM f_save_file.

END-OF-SELECTION.
