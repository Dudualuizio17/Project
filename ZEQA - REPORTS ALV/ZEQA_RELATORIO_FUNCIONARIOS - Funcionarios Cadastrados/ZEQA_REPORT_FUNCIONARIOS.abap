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
* 07/07/2023   | Equipe A       | Report dos Funcionários
*======================================================================*
*&---------------------------------------------------------------------*
*& Report ZEQA_REPORT_FUNCIONARIOS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEQA_REPORT_FUNCIONARIOS.

  include ZEQA_REPORT_FUNCIONARIOS_TOP.
  include ZEQA_REPORT_FUNCIONARIOS_SCR.
  include ZEQA_REPORT_FUNCIONARIOS_F01.

START-OF-SELECTION.
PERFORM f_get_dados.
END-OF-SELECTION.
  perform f_monta_dados.
  PERFORM F_IMPRIME_RELATORIO.
