*&---------------------------------------------------------------------*
*&  Include           ZEQA_REPORT_FUNCIONARIOS_SCR
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
*  parameters: p_cnpj type ZEQA_TABELA_CAD-CNPJ MATCHCODE OBJECT XXX.
*  select-options: s_CPFNR for ZEQA_TABELA_CAD-CNPJ no INTERVALS.
   SELECT-OPTIONS: s_cnpj FOR ZEQA_TABELA_CAD-CNPJ NO INTERVALS NO-EXTENSION MATCHCODE OBJECT ZSHEQA_ALV_FUNCIONARIOS.

SELECTION-SCREEN END OF BLOCK B1.
