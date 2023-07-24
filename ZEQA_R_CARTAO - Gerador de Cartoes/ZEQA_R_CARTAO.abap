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
* 07/07/2023   | Equipe A       | Report de Cartão
*======================================================================*
*&---------------------------------------------------------------------*
*& Report ZEQA_R_CARTAO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zeqa_r_cartao message-id zeqa.

include zeqa_r_cartao_top.
include zeqa_r_cartao_scr.
include zeqa_r_cartao_f01.

at selection-screen on value-request for p_file.

  perform f_selecao_arquivo using p_file
                        changing p_file.

start-of-selection.

  perform f_busca_dados.

end-of-selection.

  perform f_save_file.
  perform f_imprime_relatorio.
