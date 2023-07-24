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
* 07/07/2023   | Equipe A       | Report Compras de Tickets
*======================================================================*
*&---------------------------------------------------------------------*
*& Report ZEQA_COMPRA_TICKETS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEQA_COMPRA_TICKETS.

include: zeqa_compra_tickets_top,
         zeqa_compra_tickets_scr,
         zeqa_compra_tickets_f01.

at selection-screen on value-request for p_file.
  perform f_seleciona_arquivo using p_file
                                changing p_file.

start-of-selection.
  perform f_upload_arq.
