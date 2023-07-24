*======================================================================
*
*                                HRST
*
*======================================================================
* Author      : Fábrica ABAP
* Analist     : Equipe A
* Date        : 27/06/2023
*----------------------------------------------------------------------
* Project     : Projeto Revisão
* Report      : Cockpit HRST
* Finality    :
*----------------------------------------------------------------------
* Changes History
*----------------------------------------------------------------------
* Date       | Author         | Finality
*            |                |
*======================================================================
*&---------------------------------------------------------------------*
*& Report ZEQA_REPORT_CREDITOS_GERADOS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zeqa_report_creditos_gerados.

include zeqa_report_creditos_top.
include zeqa_report_creditos_scr.
include zeqa_report_creditos_f01.

start-of-selection.

  perform f_get_dados.

end-of-selection.

  perform f_monta_dados.
  perform f_imprime_relatorio.
