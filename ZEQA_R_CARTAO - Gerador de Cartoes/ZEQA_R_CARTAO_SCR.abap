*&---------------------------------------------------------------------*
*&  Include           ZEQA_R_CARTAO_SCR
*&---------------------------------------------------------------------*
*SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
*  Selection-screen: skip 1.
*PARAMETERS: rb_man RADIOBUTTON GROUP r1 DEFAULT 'X'.
*SELECT-OPTIONS: s_cartao FOR zeqa_cartoes-cod_cartao NO INTERVALS.
**SELECTION-SCREEN END OF BLOCK b1.
*
**SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.]
*Selection-screen: skip 1.
*PARAMETERS: rb_up RADIOBUTTON GROUP r1.
*
*PARAMETERS: p_adc  TYPE c AS CHECKBOX.
**SELECTION-SCREEN END OF BLOCK b3.
*
*"criação manual de cartão
*"criação automatica de cartão
*"dowload de dados
**SELECTION-SCREEN BEGIN OF BLOCK b4 WITH FRAME TITLE TEXT-004.
*Selection-screen: skip 1.
*PARAMETERS: rb_dwn RADIOBUTTON GROUP r1.
*
*SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: S_cnpj FOR ZEQA_TABELA_CAD-CNPJ NO INTERVALS NO-EXTENSION MATCHCODE OBJECT ZSHEQA_ALV_FUNCIONARIOS.
*PARAMETERS: p_cnpj TYPE zeqa_tabela_cad-cnpj OBLIGATORY.
PARAMETERS: p_file TYPE rlgrap-filename.
SELECTION-SCREEN END OF BLOCK b1.
