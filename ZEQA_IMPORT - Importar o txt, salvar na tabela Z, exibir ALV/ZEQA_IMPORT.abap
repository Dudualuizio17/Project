*======================================================================
*
*                                HRST
*
*======================================================================
* Author      : Fábrica ABAP
* Analist     : Equipe A
* Date        : 06/07/2023
*----------------------------------------------------------------------
* Project     : Projeto Equipe A
* Report      : Cockpit HRST
* Finality    :
*----------------------------------------------------------------------
* Changes History
*----------------------------------------------------------------------
* Date       | Author         | Finality
*            |                |
*======================================================================*
*&---------------------------------------------------------------------*
*& Report ZEQA_IMPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zeqa_import.

INCLUDE: zeqa_import_top,
         zeqa_import_scr,
         zeqa_import_f01.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  PERFORM f_seleciona_arquivo USING p_file
                               CHANGING p_file.

START-OF-SELECTION.

  PERFORM f_upload_arq.
*  PERFORM f_imprime_report.

END-OF-SELECTION.
