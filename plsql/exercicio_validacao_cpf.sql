SET SERVEROUT ON

ACCEPT P_CPF PROMPT 'Informe um CPF a ser validado'

DECLARE
  v_cpf VARCHAR2(15) := '&P_CPF';
  v_soma NUMBER(3);
  v_count NUMBER(2) := 9;
  
  v_e_tamanho EXCEPTION;
  v_e_digito EXCEPTION;
BEGIN
  IF LENGTH(v_cpf) <> 11 THEN
    RAISE v_e_tamanho;
  END IF;
  
  FOR v_num_digito IN 0..1 LOOP
    v_soma := 0;
    FOR v_i IN 1..v_count LOOP
      v_soma := v_soma + (SUBSTR(v_cpf, v_i + v_num_digito, 1) * v_i);
    END LOOP;
    IF MOD(v_soma, 11) <> SUBSTR(v_cpf, v_count + v_num_digito + 1, 1) THEN
      RAISE v_e_digito;
    END IF;
  END LOOP;
  
  dbms_output.put_line('CPF válido');
EXCEPTION
  WHEN v_e_tamanho THEN
    dbms_output.put_line('O tamanho do CPF deve ser de 11 dígitos');
  WHEN v_e_digito THEN
    dbms_output.put_line('Dígito do CPF é inválido');
  WHEN OTHERS THEN
    dbms_output.put_line('Ocorreu um erro ao validar o CPF: ' || SQLERRM);
END;
