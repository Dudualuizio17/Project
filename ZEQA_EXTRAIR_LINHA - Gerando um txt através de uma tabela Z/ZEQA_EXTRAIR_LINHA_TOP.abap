*&---------------------------------------------------------------------*
*&  Include           ZEQA_EXTRAIR_LINHA_TOP
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
* Tabela Transparente
*&---------------------------------------------------------------------*
TABLES ZEQA_TABELA_LINH.
*&---------------------------------------------------------------------*
*** Declaration of types
*&---------------------------------------------------------------------*
types: begin of ty_file,
        line type string,
       end of ty_file.
*&---------------------------------------------------------------------*
*** Declaration of global Internal Tables
*&---------------------------------------------------------------------*
DATA gt_file    TYPE TABLE OF ty_file.
*&---------------------------------------------------------------------*
*** Declaration of global work areas
*&---------------------------------------------------------------------*
data gwa_file TYPE ty_file.
