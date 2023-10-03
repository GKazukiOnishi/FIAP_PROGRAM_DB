/*
RM 87182 – Gabriel Kazuki Onishi
RM 88332 - Breno de Souza Silva
RM 87221 - Davi Yamane Eugenio
RM 87843 - Gustavo Costa Pereira
RM 88000 - Vitor Ramos Santos de Faria
*/

CREATE OR REPLACE FUNCTION f_ckp_5_valida_cpf(p_cpf VARCHAR2)
  RETURN VARCHAR2 IS
  /*
    RM 87182 – Gabriel Kazuki Onishi
    RM 88332 - Breno de Souza Silva
    RM 87221 - Davi Yamane Eugenio
    RM 87843 - Gustavo Costa Pereira
    RM 88000 - Vitor Ramos Santos de Faria
  */
  
  v_soma NUMBER(3);
  v_count NUMBER(2) := 9;
  v_digito_calculado NUMBER(2);
  
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
    
    v_digito_calculado := MOD(v_soma, 11);
    IF v_digito_calculado = 10 THEN
      v_digito_calculado := 0;
    END IF;
    
    IF v_digito_calculado <> SUBSTR(p_cpf, v_count + v_num_digito + 1, 1) THEN
      RAISE v_e_digito;
    END IF;
  END LOOP;
  
  RETURN 'CPF Válido';
EXCEPTION
  WHEN v_e_tamanho THEN
    RETURN 'O tamanho do CPF deve ser de 11 dígitos';
  WHEN v_e_digito THEN
    RETURN 'Dígito do CPF é inválido';
  WHEN OTHERS THEN
    RETURN 'Ocorreu um erro ao validar o CPF: ' || SQLERRM;
END f_ckp_5_valida_cpf;
/

CREATE OR REPLACE FUNCTION f_ckp_5_valida_rg(p_rg VARCHAR2)
  RETURN VARCHAR2 IS
  /*
    RM 87182 – Gabriel Kazuki Onishi
    RM 88332 - Breno de Souza Silva
    RM 87221 - Davi Yamane Eugenio
    RM 87843 - Gustavo Costa Pereira
    RM 88000 - Vitor Ramos Santos de Faria
  */
  
  v_multiplicador NUMBER(1) := 9;
  v_soma NUMBER(3) := 0;
  v_digito_calculado VARCHAR2(2);
  
  v_e_tamanho EXCEPTION;
BEGIN
  IF LENGTH(p_rg) <> 9 THEN
    RAISE v_e_tamanho;
  END IF;

  FOR v_i IN 1..8 LOOP
    v_soma := v_soma + (SUBSTR(p_rg, v_i, 1) * v_multiplicador);
    v_multiplicador := v_multiplicador - 1;
  END LOOP;
  v_digito_calculado := MOD(v_soma, 11);
  
  IF v_digito_calculado = '10' THEN
    v_digito_calculado := 'X';
  END IF;
  
  IF v_digito_calculado = SUBSTR(p_rg, 9, 1) THEN
    RETURN 'RG Válido';
  END IF;
  RETURN 'RG Inválido';
EXCEPTION
  WHEN v_e_tamanho THEN
    RETURN 'O tamanho do RG deve ser de 9 dígitos';
  WHEN OTHERS THEN
    RETURN 'Ocorreu um erro ao validar o RG: ' || SQLERRM;
END f_ckp_5_valida_rg;
/

CREATE OR REPLACE FUNCTION f_ckp_5_valida_cartao(p_cartao VARCHAR2)
  RETURN VARCHAR2 IS
  /*
    RM 87182 – Gabriel Kazuki Onishi
    RM 88332 - Breno de Souza Silva
    RM 87221 - Davi Yamane Eugenio
    RM 87843 - Gustavo Costa Pereira
    RM 88000 - Vitor Ramos Santos de Faria
  */
  
  v_multiplicador NUMBER(1) := 2;
  v_resultado_mult NUMBER(2);
  v_soma NUMBER(4) := 0;
  v_alt_mult NUMBER(1) := 1;
  
  v_ultimo_digito_soma NUMBER(1);
  v_digito_calculado NUMBER(1);
  
  v_e_tamanho EXCEPTION;
BEGIN
  IF LENGTH(p_cartao) > 19 OR LENGTH(p_cartao) < 14 THEN
    RAISE v_e_tamanho;
  END IF;
  
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
  
  IF v_digito_calculado = SUBSTR(p_cartao, LENGTH(p_cartao), 1) THEN
    RETURN 'Cartão de Crédito Válido';
  END IF;
  RETURN 'Cartão de Crédito Inválido';
EXCEPTION
  WHEN v_e_tamanho THEN
    RETURN 'O tamanho do cartão de crédito deve ser de 14 a 19 dígitos';
  WHEN OTHERS THEN
    RETURN 'Ocorreu um erro ao validar o cartão de crédito: ' || SQLERRM;
END f_ckp_5_valida_cartao;
/

CREATE OR REPLACE FUNCTION f_ckp_5_valida_cnpj(p_cnpj VARCHAR2)
  RETURN VARCHAR2 IS
  /*
    RM 87182 – Gabriel Kazuki Onishi
    RM 88332 - Breno de Souza Silva
    RM 87221 - Davi Yamane Eugenio
    RM 87843 - Gustavo Costa Pereira
    RM 88000 - Vitor Ramos Santos de Faria
  */
  
  v_multiplicador NUMBER(1) := 9;
  v_soma NUMBER(3) := 0;
  
  v_e_tamanho EXCEPTION;
BEGIN
  IF LENGTH(p_cnpj) <> 14 THEN
    RAISE v_e_tamanho;
  END IF;
  
  FOR v_digito IN 0..1 LOOP
    FOR v_i IN REVERSE 1..(LENGTH(p_cnpj) - 2 + v_digito) LOOP
      v_soma := v_soma + (SUBSTR(p_cnpj, v_i, 1) * v_multiplicador);

      v_multiplicador := v_multiplicador - 1;
      IF v_multiplicador = 1 THEN
        v_multiplicador := 9;
      END IF;
    END LOOP;
    
    IF SUBSTR(p_cnpj, (LENGTH(p_cnpj) - 1 + v_digito), 1) <> MOD(v_soma, 11) THEN
      RETURN 'CNPJ Inválido';
    END IF;
    
    v_multiplicador := 9;
    v_soma := 0;
  END LOOP;
  
  RETURN 'CNPJ Válido';
EXCEPTION
  WHEN v_e_tamanho THEN
    RETURN 'O tamanho do CNPJ deve ser de 14 dígitos';
  WHEN OTHERS THEN
    RETURN 'Ocorreu um erro ao validar o CNPJ: ' || SQLERRM;
END f_ckp_5_valida_cnpj;
/

CREATE OR REPLACE FUNCTION f_ckp_5_valida_titulo_eleitoral(p_titulo VARCHAR2)
  RETURN VARCHAR2 IS
  /*
    RM 87182 – Gabriel Kazuki Onishi
    RM 88332 - Breno de Souza Silva
    RM 87221 - Davi Yamane Eugenio
    RM 87843 - Gustavo Costa Pereira
    RM 88000 - Vitor Ramos Santos de Faria
  */
  
  v_sequencial_aux VARCHAR2(16);
  v_sequencial_1 VARCHAR2(16) := SUBSTR(p_titulo, 1, LENGTH(p_titulo) - 4);
  v_uf VARCHAR2(2) := SUBSTR(p_titulo, LENGTH(p_titulo) - 3, 2);
  v_sequencial_2 VARCHAR2(16) := SUBSTR(p_titulo, LENGTH(p_titulo) - 3, 3);
  v_multiplicador NUMBER(1) := 9;
  v_soma NUMBER(3) := 0;
  v_digito_calculado NUMBER(2);
  
  v_e_tamanho EXCEPTION;
BEGIN
  IF LENGTH(p_titulo) > 12 OR LENGTH(p_titulo) < 10 THEN
    RAISE v_e_tamanho;
  END IF;
  
  v_sequencial_aux := v_sequencial_1;
  FOR v_seq IN 0..1 LOOP
    FOR v_i IN REVERSE 1..LENGTH(v_sequencial_aux) LOOP
      v_soma := v_soma + (SUBSTR(v_sequencial_aux, v_i, 1) * v_multiplicador);
      v_multiplicador := v_multiplicador - 1;
    END LOOP;
    
    v_digito_calculado := MOD(v_soma, 11);
    
    IF v_digito_calculado = 10 THEN
      v_digito_calculado := 0;
    END IF;

    IF v_uf IN ('01', '02') AND v_digito_calculado = 0 THEN
      v_digito_calculado := 1;
    END IF;
    
    IF v_digito_calculado <> SUBSTR(p_titulo, LENGTH(p_titulo) - 1 + v_seq, 1) THEN
      RETURN 'Título de Eleitor Inválido';
    END IF;
    
    v_multiplicador := 9;
    v_soma := 0;
    v_sequencial_aux := v_sequencial_2;
  END LOOP;
  
  RETURN 'Título de Eleitor Válido';
EXCEPTION
  WHEN v_e_tamanho THEN
    RETURN 'O tamanho do título de eleitor deve ser de 10 a 12 dígitos';
  WHEN OTHERS THEN
    RETURN 'Ocorreu um erro ao validar o título de eleitor: ' || SQLERRM;
END f_ckp_5_valida_titulo_eleitoral;
/

-- ******* TESTES *******

SET SERVEROUT ON

BEGIN
    dbms_output.put_line('Teste CPF ' || '51841612871' || ' ' || f_ckp_5_valida_cpf('51841612871'));
    dbms_output.put_line('Teste CPF ' || '44176313870' || ' ' || f_ckp_5_valida_cpf('44176313870'));
    dbms_output.put_line('Teste CPF ' || '07174548350' || ' ' || f_ckp_5_valida_cpf('07174548350'));
    dbms_output.put_line('Teste CPF ' || '26337836510' || ' ' || f_ckp_5_valida_cpf('26337836510'));
    dbms_output.put_line('Teste CPF ' || '02303463408' || ' ' || f_ckp_5_valida_cpf('02303463408'));
    dbms_output.put_line('Teste CPF ' || '67611303104' || ' ' || f_ckp_5_valida_cpf('67611303104'));
    dbms_output.put_line('Teste CPF ' || '35506148615' || ' ' || f_ckp_5_valida_cpf('35506148615'));
    dbms_output.put_line('Teste CPF ' || '02764803842' || ' ' || f_ckp_5_valida_cpf('02764803842'));
    dbms_output.put_line('Teste CPF ' || '76611057218' || ' ' || f_ckp_5_valida_cpf('76611057218'));
    dbms_output.put_line('Teste CPF ' || '81850416877' || ' ' || f_ckp_5_valida_cpf('81850416877'));
    dbms_output.put_line('Teste CPF ' || '82618837606' || ' ' || f_ckp_5_valida_cpf('82618837606'));
    dbms_output.put_line('Teste CPF ' || '17865416709' || ' ' || f_ckp_5_valida_cpf('17865416709'));
    
    dbms_output.put_line('Teste RG ' || '583595418' || ' ' || f_ckp_5_valida_rg('583595418'));
    dbms_output.put_line('Teste RG ' || '55358943X' || ' ' || f_ckp_5_valida_rg('55358943X'));
    dbms_output.put_line('Teste RG ' || '495851589' || ' ' || f_ckp_5_valida_rg('495851589'));
    dbms_output.put_line('Teste RG ' || '495290452' || ' ' || f_ckp_5_valida_rg('495290452'));
    dbms_output.put_line('Teste RG ' || '478523725' || ' ' || f_ckp_5_valida_rg('478523725'));
    dbms_output.put_line('Teste RG ' || '127392282' || ' ' || f_ckp_5_valida_rg('127392282'));
    dbms_output.put_line('Teste RG ' || '274077851' || ' ' || f_ckp_5_valida_rg('274077851'));
    dbms_output.put_line('Teste RG ' || '234110193' || ' ' || f_ckp_5_valida_rg('234110193'));
    dbms_output.put_line('Teste RG ' || '472555558' || ' ' || f_ckp_5_valida_rg('472555558'));
    dbms_output.put_line('Teste RG ' || '200980178' || ' ' || f_ckp_5_valida_rg('200980178'));
    dbms_output.put_line('Teste RG ' || '360016510' || ' ' || f_ckp_5_valida_rg('360016510'));
    dbms_output.put_line('Teste RG ' || '373232214' || ' ' || f_ckp_5_valida_rg('373232214'));
    dbms_output.put_line('Teste RG ' || '49434457X' || ' ' || f_ckp_5_valida_rg('49434457X'));
    dbms_output.put_line('Teste RG ' || '15182826X' || ' ' || f_ckp_5_valida_rg('15182826X'));
    
    dbms_output.put_line('Teste Cartão ' || '30111198763335' || ' ' || f_ckp_5_valida_cartao('30111198763335'));
    dbms_output.put_line('Teste Cartão ' || '3412123412341238' || ' ' || f_ckp_5_valida_cartao('3412123412341238'));
    dbms_output.put_line('Teste Cartão ' || '5400591401664316' || ' ' || f_ckp_5_valida_cartao('5400591401664316'));
    dbms_output.put_line('Teste Cartão ' || '5513155096292033' || ' ' || f_ckp_5_valida_cartao('5513155096292033'));
    dbms_output.put_line('Teste Cartão ' || '4556170810301847' || ' ' || f_ckp_5_valida_cartao('4556170810301847'));
    dbms_output.put_line('Teste Cartão ' || '372395746022692' || ' ' || f_ckp_5_valida_cartao('372395746022692'));
    dbms_output.put_line('Teste Cartão ' || '38777497146927' || ' ' || f_ckp_5_valida_cartao('38777497146927'));
    dbms_output.put_line('Teste Cartão ' || '6011395150235941' || ' ' || f_ckp_5_valida_cartao('6011395150235941'));
    dbms_output.put_line('Teste Cartão ' || '201476321730680' || ' ' || f_ckp_5_valida_cartao('201476321730680'));
    dbms_output.put_line('Teste Cartão ' || '3519215993500729' || ' ' || f_ckp_5_valida_cartao('3519215993500729'));
    dbms_output.put_line('Teste Cartão ' || '869962723711876' || ' ' || f_ckp_5_valida_cartao('869962723711876'));
    dbms_output.put_line('Teste Cartão ' || '6062826451576029' || ' ' || f_ckp_5_valida_cartao('6062826451576029'));
    
    dbms_output.put_line('Teste CNPJ ' || '18781203000128' || ' ' || f_ckp_5_valida_cnpj('18781203000128'));
    dbms_output.put_line('Teste CNPJ ' || '45594341000170' || ' ' || f_ckp_5_valida_cnpj('45594341000170'));
    dbms_output.put_line('Teste CNPJ ' || '31184405000150' || ' ' || f_ckp_5_valida_cnpj('31184405000150'));
    dbms_output.put_line('Teste CNPJ ' || '52833207000140' || ' ' || f_ckp_5_valida_cnpj('52833207000140'));
    dbms_output.put_line('Teste CNPJ ' || '08403522000146' || ' ' || f_ckp_5_valida_cnpj('08403522000146'));
    dbms_output.put_line('Teste CNPJ ' || '18161387000123' || ' ' || f_ckp_5_valida_cnpj('18161387000123'));
    dbms_output.put_line('Teste CNPJ ' || '55632225000152' || ' ' || f_ckp_5_valida_cnpj('55632225000152'));
    dbms_output.put_line('Teste CNPJ ' || '45323600000129' || ' ' || f_ckp_5_valida_cnpj('45323600000129'));
    dbms_output.put_line('Teste CNPJ ' || '42141545000168' || ' ' || f_ckp_5_valida_cnpj('42141545000168'));
    dbms_output.put_line('Teste CNPJ ' || '05315231000108' || ' ' || f_ckp_5_valida_cnpj('05315231000108'));
    dbms_output.put_line('Teste CNPJ ' || '43275674000101' || ' ' || f_ckp_5_valida_cnpj('43275674000101'));
    dbms_output.put_line('Teste CNPJ ' || '14820582000167' || ' ' || f_ckp_5_valida_cnpj('14820582000167'));
    dbms_output.put_line('Teste CNPJ ' || '18113232000111' || ' ' || f_ckp_5_valida_cnpj('18113232000111'));
    
    dbms_output.put_line('Teste Titulo Eleitoral ' || '4356870906' || ' ' || f_ckp_5_valida_titulo_eleitoral('4356870906'));
    dbms_output.put_line('Teste Titulo Eleitoral ' || '459238930116' || ' ' || f_ckp_5_valida_titulo_eleitoral('459238930116'));
    dbms_output.put_line('Teste Titulo Eleitoral ' || '252510340281' || ' ' || f_ckp_5_valida_titulo_eleitoral('252510340281'));
    dbms_output.put_line('Teste Titulo Eleitoral ' || '252510340388' || ' ' || f_ckp_5_valida_titulo_eleitoral('252510340388'));
    dbms_output.put_line('Teste Titulo Eleitoral ' || '302416350183' || ' ' || f_ckp_5_valida_titulo_eleitoral('302416350183'));
    dbms_output.put_line('Teste Titulo Eleitoral ' || '503460200167' || ' ' || f_ckp_5_valida_titulo_eleitoral('503460200167'));
    dbms_output.put_line('Teste Titulo Eleitoral ' || '753544460167' || ' ' || f_ckp_5_valida_titulo_eleitoral('753544460167'));
    dbms_output.put_line('Teste Titulo Eleitoral ' || '758672350175' || ' ' || f_ckp_5_valida_titulo_eleitoral('758672350175'));
    dbms_output.put_line('Teste Titulo Eleitoral ' || '356850700167' || ' ' || f_ckp_5_valida_titulo_eleitoral('356850700167'));
    dbms_output.put_line('Teste Titulo Eleitoral ' || '850411710183' || ' ' || f_ckp_5_valida_titulo_eleitoral('850411710183'));
    dbms_output.put_line('Teste Titulo Eleitoral ' || '118143420159' || ' ' || f_ckp_5_valida_titulo_eleitoral('118143420159'));
    dbms_output.put_line('Teste Titulo Eleitoral ' || '321230700116' || ' ' || f_ckp_5_valida_titulo_eleitoral('321230700116'));
    dbms_output.put_line('Teste Titulo Eleitoral ' || '344831670116' || ' ' || f_ckp_5_valida_titulo_eleitoral('344831670116'));
    dbms_output.put_line('Teste Titulo Eleitoral ' || '570362510124' || ' ' || f_ckp_5_valida_titulo_eleitoral('570362510124'));
    dbms_output.put_line('Teste Titulo Eleitoral ' || '015323060141' || ' ' || f_ckp_5_valida_titulo_eleitoral('015323060141'));
    
    
    dbms_output.put_line('Teste CPF ' || '518416128711' || ' ' || f_ckp_5_valida_cpf('518416128711'));
    dbms_output.put_line('Teste CPF ' || '4417631380' || ' ' || f_ckp_5_valida_cpf('4417631380'));
    dbms_output.put_line('Teste CPF ' || '07174548351' || ' ' || f_ckp_5_valida_cpf('07174548351'));
    dbms_output.put_line('Teste CPF ' || '2633783651a' || ' ' || f_ckp_5_valida_cpf('2633783651a'));
    dbms_output.put_line('Teste CPF ' || '2633B83651a' || ' ' || f_ckp_5_valida_cpf('2633B83651a'));
    
    dbms_output.put_line('Teste RG ' || '5835954188' || ' ' || f_ckp_5_valida_rg('5835954188'));
    dbms_output.put_line('Teste RG ' || '5535894X' || ' ' || f_ckp_5_valida_rg('5535894X'));
    dbms_output.put_line('Teste RG ' || '495851582' || ' ' || f_ckp_5_valida_rg('495851582'));
    dbms_output.put_line('Teste RG ' || '495B90452' || ' ' || f_ckp_5_valida_rg('495B90452'));
    
    dbms_output.put_line('Teste Cartão ' || '3011119876333' || ' ' || f_ckp_5_valida_cartao('3011119876333'));
    dbms_output.put_line('Teste Cartão ' || '34121234123412381231' || ' ' || f_ckp_5_valida_cartao('34121234123412381231'));
    dbms_output.put_line('Teste Cartão ' || '5400A91401664316' || ' ' || f_ckp_5_valida_cartao('5400A91401664316'));
    dbms_output.put_line('Teste Cartão ' || '5513155096292034' || ' ' || f_ckp_5_valida_cartao('5513155096292034'));
    
    dbms_output.put_line('Teste CNPJ ' || '187812030001228' || ' ' || f_ckp_5_valida_cnpj('187812030001228'));
    dbms_output.put_line('Teste CNPJ ' || '4559434100017' || ' ' || f_ckp_5_valida_cnpj('4559434100017'));
    dbms_output.put_line('Teste CNPJ ' || '31184405000152' || ' ' || f_ckp_5_valida_cnpj('31184405000152'));
    dbms_output.put_line('Teste CNPJ ' || '528A3207000140' || ' ' || f_ckp_5_valida_cnpj('528A3207000140'));
    
    dbms_output.put_line('Teste Titulo Eleitoral ' || '435687096' || ' ' || f_ckp_5_valida_titulo_eleitoral('435687096'));
    dbms_output.put_line('Teste Titulo Eleitoral ' || '4592389301162' || ' ' || f_ckp_5_valida_titulo_eleitoral('4592389301162'));
    dbms_output.put_line('Teste Titulo Eleitoral ' || '252510340282' || ' ' || f_ckp_5_valida_titulo_eleitoral('252510340282'));
    dbms_output.put_line('Teste Titulo Eleitoral ' || '2525A0340388' || ' ' || f_ckp_5_valida_titulo_eleitoral('2525A0340388'));
END;
/

SET SERVEROUT OFF

-- ******* GRANTS *******

GRANT EXECUTE ON f_ckp_5_valida_cpf TO PF0645;
GRANT EXECUTE ON f_ckp_5_valida_rg TO PF0645;
GRANT EXECUTE ON f_ckp_5_valida_cartao TO PF0645;
GRANT EXECUTE ON f_ckp_5_valida_cnpj TO PF0645;
GRANT EXECUTE ON f_ckp_5_valida_titulo_eleitoral TO PF0645;


