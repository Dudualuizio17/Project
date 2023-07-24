*&---------------------------------------------------------------------*
*&  Include           ZEQA_R_CARTAO_TOP
*&---------------------------------------------------------------------*
tables: zeqa_cartoes, zeqa_tabela_linh, zeqa_tabela_cad, zeqa_colaborador, zeqa_dependentes.
*&---------------------------------------------------------------------*
*** Declaração dos tipos
*&---------------------------------------------------------------------*
types: begin of ty_arquivo,
         credito       type zeqa_cartoes-credito,
         cod_cartao    type zeqa_cartoes-cod_cartao,
         cpf_colab     type zeqa_cartoes-cpf,
         data_emissao  type zeqa_cartoes-data_emissao,
         data_validade type zeqa_cartoes-data_validade,
         usuario_ativo type zeqa_cartoes-ativo,
       end of ty_arquivo.

types: begin of ty_report,
         cnpj          type zeqa_tabela_cad-cnpj,
         cod_cartao    type zeqa_cartoes-cod_cartao,
         cpf           type zeqa_cartoes-cpf,
         nome          type zeqa_tabela_cad-nome,
         data_emissao  type zeqa_cartoes-data_emissao,
         data_validade type zeqa_cartoes-data_validade,
         credito       type zeqa_cartoes-credito,
         mensagem      type char50,
       end of ty_report.

types: begin of ty_upload,
         cod_cartao type string,
       end of ty_upload.

types: begin of ty_file_fmt,
         credito    type  zeqa_cartoes-credito,
         cod_cartao type  zeqa_cartoes-cod_cartao,
       end of ty_file_fmt.

types: begin of ty_file_tratado,
         linha(200) type c,
       end of ty_file_tratado.
*&---------------------------------------------------------------------*
*** Declaração das tabelas internas
*&---------------------------------------------------------------------*
data gt_arquivo      type table of ty_arquivo.
data gt_report       type table of ty_report.
data gt_upload       type table of ty_upload.
data gt_file_fmt     type table of ty_file_fmt.
data gt_file_tratado type table of ty_file_tratado.
data gt_file(150) type c.
*&---------------------------------------------------------------------*
*** Declaração das work areas globais
*&---------------------------------------------------------------------*
data gwa_arquivo type ty_arquivo.
data gwa_report type ty_report.
data gwa_upload type ty_upload.
data gwa_file_fmt type ty_file_fmt.
data gwa_file_tratado type ty_file_tratado.
*&---------------------------------------------------------------------*
*Alv Structures                                                        *
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
