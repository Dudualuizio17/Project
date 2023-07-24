*&---------------------------------------------------------------------*
*&  Include           ZEQA_COMPRA_TICKETS_TOP
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
* Tabela Transparente
*&---------------------------------------------------------------------*
TABLES: zeqa_tabela_grdr.
*&---------------------------------------------------------------------*
* Type
*&---------------------------------------------------------------------*
TYPES: BEGIN OF ty_upload,
         linha TYPE string,
       END OF ty_upload.

TYPES: BEGIN OF ty_arquivo,
         codfunc   TYPE zeqa_tabela_grdr-num_cartao,
         codlinha  TYPE zeqa_tabela_grdr-cod_linha,
         valcred   TYPE string,
         dtcredito TYPE zeqa_tabela_grdr-dt_cred,
       END OF ty_arquivo.
*&---------------------------------------------------------------------*
* Tabela Interna
*&---------------------------------------------------------------------*
DATA: gt_upload  TYPE TABLE OF ty_upload,
      gt_arquivo TYPE TABLE OF ty_arquivo.
*&---------------------------------------------------------------------*
* Estrutura
*&---------------------------------------------------------------------*
DATA: gwa_upload  TYPE ty_upload,
      gwa_arquivo TYPE ty_arquivo.
