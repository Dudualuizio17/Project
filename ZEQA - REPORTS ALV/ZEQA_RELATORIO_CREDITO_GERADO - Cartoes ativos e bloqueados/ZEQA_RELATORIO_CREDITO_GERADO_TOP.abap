*&---------------------------------------------------------------------*
*&  Include           ZEQA_REPORT_CREDITOS_TOP
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*** Tabela Transparente
*&---------------------------------------------------------------------*
tables zeqa_tabela_grdr.
*&---------------------------------------------------------------------*
*** Declaração dos tipos
*&---------------------------------------------------------------------*
types: begin of ty_relatorio,
         credito    type zeqa_tabela_grdr-credito,
         num_cartao type zeqa_tabela_grdr-num_cartao,
         cpf        type zeqa_tabela_grdr-cpf_colab,
         nome       type zeqa_tabela_grdr-nome_colab,
         dt_cred    type zeqa_tabela_grdr-dt_cred,
         cartao     type zeqa_tabela_grdr-cart_block_at,
         status     type c length 50,
         icon_field type icons-text,
         cod_linha  type zeqa_tabela_grdr-cod_linha,
       end of ty_relatorio.
**&---------------------------------------------------------------------*
*&  Tabela Interna
*&---------------------------------------------------------------------*
data: gt_zeqa_tabela_grdr type table of zeqa_tabela_grdr,
      gt_relatorio        type table of ty_relatorio,
      gt_dd07v            type table of dd07v.
*&---------------------------------------------------------------------*
*&  Work Area
*&---------------------------------------------------------------------*
data: gwa_zeqa_tabela_grdr type zeqa_tabela_grdr,
      gwa_relatorio        type ty_relatorio,
      gwa_dd07v            type dd07v.
*&---------------------------------------------------------------------*
*&  Constante
*&---------------------------------------------------------------------*
constants: gc_icon_red    type string value '@0A@',
           gc_icon_green  type string value '@08@',
           gc_icon_yellow type string value '@09@'.
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
