*&---------------------------------------------------------------------*
*&  Include           ZEQA_IMPORT_TOP
*&---------------------------------------------------------------------*
TABLES: zeqa_tabela_cad.

*&---------------------------------------------------------------------*
*&  Types
*&---------------------------------------------------------------------*
TYPES: BEGIN OF ty_upload,
         linha TYPE string,
       END OF ty_upload.


TYPES: BEGIN OF ty_arquivo,
         cnpj          TYPE zeqa_tabela_cad-cnpj,
         cpf           TYPE zeqa_tabela_cad-cpf,
         nome          TYPE zeqa_tabela_cad-nome,
         nome_pai      TYPE zeqa_tabela_cad-nome_pai,
         nome_mae      TYPE zeqa_tabela_cad-nome_mae,
         email         TYPE zeqa_tabela_cad-email,
         endereco      TYPE zeqa_tabela_cad-endereco,
         cidade        TYPE zeqa_tabela_cad-cidade,
         estado        TYPE zeqa_tabela_cad-estado,
         dt_nascimento TYPE zeqa_tabela_cad-dt_nascimento,
         dependentes   TYPE zeqa_tabela_cad-dependentes,
         dependentes_2 TYPE zeqa_tabela_cad-dependentes_2,
       END OF ty_arquivo.

TYPES: BEGIN OF ty_report,
         cnpj          TYPE zeqa_tabela_cad-cnpj,
         cpf           TYPE zeqa_tabela_cad-cpf,
         nome          TYPE zeqa_tabela_cad-nome,
         nome_pai      TYPE zeqa_tabela_cad-nome_pai,
         nome_mae      TYPE zeqa_tabela_cad-nome_mae,
         email         TYPE zeqa_tabela_cad-email,
         endereco      TYPE zeqa_tabela_cad-endereco,
         cidade        TYPE zeqa_tabela_cad-cidade,
         estado        TYPE zeqa_tabela_cad-estado,
         dt_nascimento TYPE zeqa_tabela_cad-dt_nascimento,
         dependentes   TYPE zeqa_tabela_cad-dependentes,
         dependentes_2 TYPE zeqa_tabela_cad-dependentes_2,
       END OF ty_report.

*&---------------------------------------------------------------------*
*&  Global Tables
*&---------------------------------------------------------------------*
DATA: gt_upload  TYPE TABLE OF ty_upload,
      gt_report  TYPE TABLE OF ty_report,
      gt_arquivo TYPE TABLE OF ty_arquivo.
*&---------------------------------------------------------------------*
*&  Work Areas
*&---------------------------------------------------------------------*
DATA:
  gwa_report  TYPE ty_report,
  gwa_arquivo TYPE ty_arquivo.

*&---------------------------------------------------------------------*
*&  ALV estruturas
*&---------------------------------------------------------------------*
  data:       vg_nrcol(4) TYPE c.

DATA: ty_layout       TYPE slis_layout_alv,
      ty_top          TYPE slis_t_listheader,
      ty_watop        TYPE slis_listheader,
      ty_fieldcat_col TYPE slis_t_fieldcat_alv,
      ty_fieldcat     TYPE slis_fieldcat_alv,
      ty_events       TYPE slis_t_event.

DATA : sch_repid TYPE sy-repid,
       sch_dynnr TYPE sy-dynnr,
       sch_field TYPE dynpread-fieldname,
       sch_objec TYPE objec,
       sch_subrc TYPE sy-subrc,
       per_beg   TYPE sy-datum,
       per_end   TYPE sy-datum.

TABLES hrvpv6a.
