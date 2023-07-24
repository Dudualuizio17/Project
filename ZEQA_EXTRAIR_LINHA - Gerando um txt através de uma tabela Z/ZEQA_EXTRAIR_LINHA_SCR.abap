*&---------------------------------------------------------------------*
*&  Include           ZEQA_EXTRAIR_LINHA_SCR
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: s_codlin FOR ZEQA_TABELA_LINH-COD_LINHA NO INTERVALS MATCHCODE OBJECT ZSHEQA_CODLINHA.
PARAMETERS: p_file TYPE rlgrap-filename OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1.
