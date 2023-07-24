*&---------------------------------------------------------------------*
*&  Include           ZEQA_REPORT_FUNCIONARIOS_TOP
*&---------------------------------------------------------------------*
TABLES: ZEQA_TABELA_CAD.
*&---------------------------------------------------------------------*
*** Declaração das estruturas transparentes
*&---------------------------------------------------------------------*
*tables ZEQA_TABELA_CAD.
*&---------------------------------------------------------------------*
*** Declaração dos tipos
*&---------------------------------------------------------------------*
types: begin of ty_relatorio,
        CNPJ          TYPE ZEQA_TABELA_CAD-CNPJ ,
        CPF           TYPE ZEQA_TABELA_CAD-cpf,
        NOME          TYPE ZEQA_TABELA_CAD-NOME,
        NOME_PAI      TYPE ZEQA_TABELA_CAD-NOME_PAI,
        NOME_MAE      TYPE ZEQA_TABELA_CAD-NOME_MAE,
        DEPENDENTES   TYPE ZEQA_TABELA_CAD-DEPENDENTES,
        DEPENDENTES_2 TYPE ZEQA_TABELA_CAD-DEPENDENTES_2,
        EMAIL         TYPE ZEQA_TABELA_CAD-EMAIL,
        ENDERECO      TYPE ZEQA_TABELA_CAD-ENDERECO,
        CIDADE        TYPE ZEQA_TABELA_CAD-CIDADE,
        ESTADO        TYPE ZEQA_TABELA_CAD-ESTADO,
        DT_NASCIMENTO TYPE ZEQA_TABELA_CAD-DT_NASCIMENTO,
       end of ty_relatorio.
**&---------------------------------------------------------------------*
*&  Tabela Interna
*&---------------------------------------------------------------------*
data: gt_relatorio  type table of ty_relatorio,
      gt_ZEQA_TABELA_CAD type TABLE OF ZEQA_TABELA_CAD.
*&---------------------------------------------------------------------*
*&  Work Area
*&---------------------------------------------------------------------*
data: gwa_relatorio type ty_relatorio,
      gwa_ZEQA_TABELA_CAD TYPE ZEQA_TABELA_CAD.
*&---------------------------------------------------------------------*
*&  ESTRUTURAS DO ALV                                                  *
*&---------------------------------------------------------------------*
data:  vg_nrcol(4) type c.

data: ty_layout       type slis_layout_alv,
      ty_top          type slis_t_listheader,
      ty_watop        type slis_listheader,
      ty_fieldcat_col type slis_t_fieldcat_alv,
      ty_fieldcat     type slis_fieldcat_alv,
      ty_events       type slis_t_event.

data : sch_repid type sy-repid,
       sch_dynnr type sy-dynnr,
       sch_field type dynpread-fieldname,
       sch_objec type objec,
       sch_subrc type sy-subrc,
       per_beg   type sy-datum,
       per_end   type sy-datum.

tables hrvpv6a.
