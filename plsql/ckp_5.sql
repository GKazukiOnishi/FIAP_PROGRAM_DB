/*
RM 87182 – GABRIEL KAZUKI ONISHI
RM 2 – NOME 2
RM 3 – NOME 3
RM 4 - NOME 4
RM 4 - NOME 4
*/

CREATE OR REPLACE FUNCTION f_ckp_5_testa_boolean(p_bool BOOLEAN)
  RETURN VARCHAR2 IS
BEGIN
  IF p_bool THEN
    RETURN 'S';
  END IF;
  RETURN 'N';
END f_ckp_5_testa_boolean;
/

CREATE OR REPLACE FUNCTION f_ckp_5_valida_cpf(p_cpf VARCHAR2)
  RETURN BOOLEAN IS
  v_soma NUMBER(3);
  v_count NUMBER(2) := 9;
  
  v_e_tamanho EXCEPTION;
  v_e_digito EXCEPTION;
BEGIN
  IF LENGTH(p_cpf) <> 11 THEN
    RAISE v_e_tamanho;
  END IF;
  
  FOR v_num_digito IN 0..1 LOOP
    v_soma := 0;
    FOR v_i IN 1..v_count LOOP
      v_soma := v_soma + (SUBSTR(p_cpf, v_i + v_num_digito, 1) * v_i);
    END LOOP;
    IF MOD(v_soma, 11) <> SUBSTR(p_cpf, v_count + v_num_digito + 1, 1) THEN
      RAISE v_e_digito;
    END IF;
  END LOOP;
  
  dbms_output.put_line('CPF válido');
  RETURN TRUE;
EXCEPTION
  WHEN v_e_tamanho THEN
    dbms_output.put_line('O tamanho do CPF deve ser de 11 dígitos');
    RETURN FALSE;
  WHEN v_e_digito THEN
    dbms_output.put_line('Dígito do CPF é inválido');
    RETURN FALSE;
  WHEN OTHERS THEN
    dbms_output.put_line('Ocorreu um erro ao validar o CPF: ' || SQLERRM);
    RETURN FALSE;
END f_ckp_5_valida_cpf;
/

CREATE OR REPLACE FUNCTION f_ckp_5_valida_rg(p_rg VARCHAR2)
  RETURN BOOLEAN IS
  v_multiplicador NUMBER(1) := 9;
  v_soma NUMBER(3) := 0;
  v_digito_calculado VARCHAR2(2);
BEGIN
  FOR v_i IN 1..8 LOOP
    v_soma := v_soma + (SUBSTR(p_rg, v_i, 1) * v_multiplicador);
    v_multiplicador := v_multiplicador - 1;
  END LOOP;
  v_digito_calculado := MOD(v_soma, 11);
  
  IF v_digito_calculado = '10' THEN
    v_digito_calculado := 'X';
  END IF;
  
  IF v_digito_calculado = SUBSTR(p_rg, 9, 1) THEN
    RETURN TRUE;
  END IF;
  RETURN FALSE;
END f_ckp_5_valida_rg;
/

CREATE OR REPLACE FUNCTION f_ckp_5_valida_cartao(p_cartao VARCHAR2)
  RETURN BOOLEAN IS
  v_multiplicador NUMBER(1) := 2;
  v_resultado_mult NUMBER(2);
  v_soma NUMBER(3) := 0;
  v_alt_mult NUMBER(1) := 1;
  
  v_ultimo_digito_soma NUMBER(1);
  v_digito_calculado NUMBER(1);
BEGIN
  FOR v_i IN REVERSE 1..(LENGTH(p_cartao)-1) LOOP
    v_resultado_mult := SUBSTR(p_cartao, v_i, 1) * v_multiplicador;
    IF v_resultado_mult > 9 THEN
      v_resultado_mult := v_resultado_mult - 9;
    END IF;
    v_soma := v_soma + v_resultado_mult;
    
    IF v_multiplicador = 2 THEN
      v_multiplicador := 1;
    ELSE
      v_multiplicador := 2;
    END IF;
  END LOOP;
  
  v_ultimo_digito_soma := SUBSTR(v_soma, LENGTH(v_soma), 1);
  IF v_ultimo_digito_soma = 0 THEN
    v_digito_calculado := 0;
  ELSE
    v_digito_calculado := 10 - v_ultimo_digito_soma;
  END IF;
  
  RETURN v_digito_calculado = SUBSTR(p_cartao, LENGTH(p_cartao), 1);
END f_ckp_5_valida_cartao;
/

CREATE OR REPLACE FUNCTION f_ckp_5_valida_cnpj(p_cnpj VARCHAR2)
  RETURN BOOLEAN IS
  v_multiplicador NUMBER(1) := 9;
  v_soma NUMBER(3) := 0;
BEGIN
  FOR v_digito IN 0..1 LOOP
    FOR v_i IN REVERSE 1..(LENGTH(p_cnpj) - 2 + v_digito) LOOP
      dbms_output.put_line(SUBSTR(p_cnpj, v_i, 1));
      v_soma := v_soma + (SUBSTR(p_cnpj, v_i, 1) * v_multiplicador);
      
      v_multiplicador := v_multiplicador - 1;
      IF v_multiplicador = 1 THEN
        v_multiplicador := 9;
      END IF;
    END LOOP;
    
    dbms_output.put_line('A  ' || MOD(v_soma, 11));
    IF SUBSTR(p_cnpj, (LENGTH(p_cnpj) - 1 + v_digito), 1) <> MOD(v_soma, 11) THEN
      RETURN FALSE;
    END IF;
    
    v_soma := 0;
  END LOOP;
  RETURN TRUE;
END f_ckp_5_valida_cnpj;
/

-- ******* TESTES *******

SET SERVEROUT ON

BEGIN
    dbms_output.put_line('Teste CPF ' || '51841612871' || ' ' || f_ckp_5_testa_boolean(f_ckp_5_valida_cpf('51841612871')));
    dbms_output.put_line('Teste CPF ' || '44176313870' || ' ' || f_ckp_5_testa_boolean(f_ckp_5_valida_cpf('44176313870')));
    
    dbms_output.put_line('Teste RG ' || '583595418' || ' ' || f_ckp_5_testa_boolean(f_ckp_5_valida_rg('583595418')));
    dbms_output.put_line('Teste RG ' || '583595419' || ' ' || f_ckp_5_testa_boolean(f_ckp_5_valida_rg('583595419')));
    dbms_output.put_line('Teste RG ' || '55358943X' || ' ' || f_ckp_5_testa_boolean(f_ckp_5_valida_rg('55358943X')));
    
    dbms_output.put_line('Teste Cartão ' || '30111198763335' || ' ' || f_ckp_5_testa_boolean(f_ckp_5_valida_cartao('30111198763335')));
    dbms_output.put_line('Teste Cartão ' || '3412123412341238' || ' ' || f_ckp_5_testa_boolean(f_ckp_5_valida_cartao('3412123412341238')));
    
    dbms_output.put_line('Teste CNPJ ' || '18781203000128' || ' ' || f_ckp_5_testa_boolean(f_ckp_5_valida_cnpj('18781203000128')));
END;
/

IF v_dig2 = 10 THEN v_dig2 := 0

IF v_dig2 = 0 AND (v_estado = 01 OR v_estado = 02) THEN v_dig2 := 1

252510340281
252510340388

SET SERVEROUT OFF

-- ******* GRANTS *******

--GRANT EXECUTE ON CPF TO PF0645;