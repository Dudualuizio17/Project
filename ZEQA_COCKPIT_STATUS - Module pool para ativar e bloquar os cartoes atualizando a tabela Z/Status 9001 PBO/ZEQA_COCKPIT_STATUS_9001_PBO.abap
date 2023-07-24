*----------------------------------------------------------------------*
***INCLUDE ZEQA_COCKPIT_STATUS_STATUS_O01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_9001  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_9001 OUTPUT.
  SET PF-STATUS 'FSTATUS'.
  SET TITLEBAR 'cockpit de status do cartao'.

  DATA lv_count TYPE i VALUE 0.

  IF lv_count = 0.
    DATA: lv_id     TYPE vrm_id,
          lt_values TYPE vrm_values,
          ls_values LIKE LINE OF lt_values.

    SELECT * FROM zeqa_tabela_grdr INTO TABLE @DATA(lt_emp).

    IF sy-subrc IS INITIAL.

      LOOP AT lt_emp INTO DATA(ls_emp).

        ls_values-key = ls_emp-num_cartao.
        ls_values-text = ls_emp-cpf_colab.

        APPEND ls_values TO lt_values.
        CLEAR ls_values.

      ENDLOOP.

    ENDIF.

    lv_id = 'ZEQA_TABELA_GRDR-NUM_CARTAO'.

    CALL FUNCTION 'VRM_SET_VALUES'
      EXPORTING
        id              = lv_id
        values          = lt_values
      EXCEPTIONS
        id_illegal_name = 1
        OTHERS          = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

    lv_count = 1.
  ENDIF.

ENDMODULE.
