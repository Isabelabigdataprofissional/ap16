-- --1.1 Escreva um cursor que exiba as variáveis rank e youtuber de toda tupla que tiver video_count pelo menos igual a 1000 e cuja category seja igual a Sports ou Music.
-- DO $$
-- DECLARE 
-- --1 DECLARAÇÃO DO CURSOR
-- cur_rank_youtubers REFCURSOR;
-- tupla RECORD;
-- v_video INT := 1000;
-- sport_cat VARCHAR(200):= 'Sports';
-- music_cat VARCHAR(200):= 'Music';
-- v_tabela VARCHAR(200):= 'tb_top_youtubers';
-- BEGIN
-- --ABRE O CURSOR
-- OPEN cur_rank_youtubers FOR EXECUTE
-- 	format ('
-- SELECT youtuber, rank
-- FROM %s
-- WHERE video_count >= $1 AND category IN ($2, $3)', v_tabela)  
-- USING v_video, sport_cat, music_cat;

-- LOOP 
-- --3 recuperação dos dados de interese 
-- FETCH cur_rank_youtubers INTO tupla;
-- EXIT WHEN NOT FOUND;
-- RAISE NOTICE '%', tupla;
-- END LOOP;
-- --4. Fechamento do cursos
-- CLOSE cur_rank_youtubers;
-- END; $$


-- DO $$
-- DECLARE
-- --1. declaração do cursor NAO VINCULADO
-- cur_delete REFCURSOR;
-- tupla RECORD;
-- BEGIN
-- -- scroll para poder voltar ao início
-- --2.abertura do cursor especifica que ele pode ir e voltar 
-- OPEN cur_delete SCROLL FOR

-- --VINCULA
-- SELECT * FROM tb_top_youtubers;

-- LOOP
-- --3 Recuperação dos dados de interesse busca as linha e coloca elas na tupla
-- FETCH cur_delete INTO tupla;
-- EXIT WHEN NOT FOUND;

-- IF tupla.video_count IS NULL THEN
-- DELETE FROM tb_top_youtubers WHERE CURRENT OF cur_delete;
-- END IF;

-- END LOOP;

-- -- loop para exibir item a item, de baixo para cima
-- LOOP
-- --3 Recuperação dos dados de interesse busca as linha de tras do cursor e coloca na tupla
-- FETCH BACKWARD FROM cur_delete INTO tupla;
-- EXIT WHEN NOT FOUND;

-- RAISE NOTICE '%', tupla;
-- END LOOP;

-- --4 fechamento
-- CLOSE cur_delete;
-- END;
-- $$
-- -- voltou todas por nao tem nenhuma que video count null
-- -- e como se ele fosse de cima pra baixo vendo qual e null e depois quando volta mostra quais nao foram apagadas ou seja quais tem um video count

-- -- DO $$
-- -- DECLARE
-- -- v_ano INT := 2010;
-- -- v_inscritos INT := 60_000_000;
-- -- v_youtuber VARCHAR(200);
-- -- -- --1. declaração do cursor
-- -- --cursor vinculado especificamenete  ano e incritos para o selecione o youtuber da tabela quando a coluna ano de criação do canal for >=ano(que é o primeiro parametro) e a coluna dos incritos for >= incristos (que no caso é o segundo parametro)  
-- -- -- o filtro sestá aqui na declaração agr
-- -- cur_ano_inscritos CURSOR (ano INT, inscritos INT) 
-- -- 					FOR SELECT youtuber FROM tb_top_youtubers 
-- -- 						WHERE started >= ano AND subscribers >= inscritos;


-- BEGIN
-- -- --2.abertura do cursor 

-- -- passando argumentos pela ordem
-- --OPEN cur_ano_inscritos (v_ano, v_inscritos);

-- --passando argumentos por nome
-- --aqui fala que o parametroinscritos é a variavel v_ano (60_000_000) e o parametro ano é a variavel v_amo(2010)
-- OPEN cur_ano_inscritos 
-- 	(	inscritos := v_inscritos, 
-- 		ano := v_ano	);

-- LOOP
--  --3. Recuperação dos dados de interesse busca as linha e coloca elas na nome youtubers 
-- FETCH cur_ano_inscritos INTO v_youtuber;
-- EXIT WHEN NOT FOUND;
-- RAISE NOTICE '%', v_youtuber;
-- END LOOP;
-- --4.fechamento
-- CLOSE cur_ano_inscritos;
-- END;
-- $$



-- DO $$
-- DECLARE
-- --cursor vinculado (bound)
-- cur_nomes_e_inscritos CURSOR FOR SELECT youtuber, subscribers FROM tb_top_youtubers;
-- --capaz de abrigar uma tupla(linha) inteira ou seja informação do youtuber + num de inscritos juntos
-- --tupla.youtuber nos dá o nome do youtuber = linha (dos) youtubers
-- --tupla.subscribers nos dá o número de inscritos = linha (dos) incristos
-- tupla RECORD;
-- --criando uma variavel que é do tipo texto vazia
-- resultado TEXT DEFAULT '';

-- BEGIN
-- --2.abertura do cursor 
-- OPEN cur_nomes_e_inscritos;

-- ---- --3. Recuperação dos dados de interesse busca as linha e coloca elas na tupla 
-- FETCH cur_nomes_e_inscritos INTO tupla;

-- WHILE FOUND LOOP
-- resultado := resultado || tupla.youtuber || ':' || tupla.subscribers || ',';
-- --enquanto houver found (linhas) coloque na caxa de texto a linha youtuber e incritos
-- FETCH cur_nomes_e_inscritos INTO tupla;
-- --falar que e para buscar a proxiam linha 
-- --aqui faz com que o loop mude para o proximo fetch oiu proximo ponteiro 
-- END LOOP;

-- --fecha o cursor
-- CLOSE cur_nomes_e_inscritos;

-- --mostra a coixinha de texto 
-- RAISE NOTICE '%', resultado;
-- END;
-- $$

-- DO $$

-- DECLARE
-- -- --1. declaração do cursor 
-- ---Esse tbm é cursor nao vinculado
-- cur_nomes_a_partir_de REFCURSOR;
-- v_youtuber VARCHAR(200);
-- v_ano INT := 2008;
-- --especifica que e a tabela youtuber por uma variavel nao está engessado como aontee em um select
-- v_nome_tabela VARCHAR(200) := 'tb_top_youtubers';

-- BEGIN

-- --2.abra o cursor e execute o seguinte selcione os youutbers da tabela que esta indicada na variavel v_nome_tabela quando stardet(é uma coluna de quando o canal começou) >= v_ano (que no cado é 2008)
-- OPEN cur_nomes_a_partir_de FOR EXECUTE
-- format('
-- 	SELECT
-- 	youtuber
-- 	FROM
-- 	%s
-- 	WHERE started >= $1'
-- 				,v_nome_tabela)
-- USING v_ano;
-- --é como se colocasse um filtro quando vc abre o cursor 

-- LOOP
-- --3. Recuperação dos dados de interesse
-- FETCH cur_nomes_a_partir_de INTO v_youtuber;
-- EXIT WHEN NOT FOUND;
-- RAISE NOTICE '%', v_youtuber;
-- END LOOP;

-- --4. Fechamento do cursos
-- CLOSE cur_nomes_a_partir_de;
-- END;
-- $$



-- DO $$
-- DECLARE
-- --1. declaração do cursor
-- --esse cursor é unbound por não ser associado a nenhuma query
-- cur_nomes_youtubers REFCURSOR;
-- --para armazenar o nome do youtuber a cada iteração
-- nome_youtuber VARCHAR(200);
-- BEGIN
-- --2. abertura do cursor
-- OPEN cur_nomes_youtubers FOR
-- SELECT youtuber 
-- FROM
-- tb_top_youtubers;
-- --selecione coluna youtubers da tabela top youtubers
-- LOOP
-- --3. Recuperação dos dados de interesse
-- -------buscar nos cursor (indicador usado para mostrar a posição) e colocar no nome_youtuber variavel de texto uma coluna espcifica cada lnha que achar
-- FETCH cur_nomes_youtubers INTO nome_youtuber;
-- --FOUND é uma variável especial que indica se exite ou nao a proxima linha 
-- ----se ele for verdadeiro significa que tem linha se ele nao for verdadeiro significa que as linhas acabaram 
-- -- entao a trdução seria saia quando nao achar (mais linhas) ou quando nao found  (nao true) = false 
-- EXIT WHEN NOT FOUND;
-- --mostre tudo que foi armanezado em cada loop na coluna nome youtubers 
-- RAISE NOTICE '%', nome_youtuber;
-- END LOOP;
-- --4. Fechamento do cursos
-- CLOSE cur_nomes_youtubers;
-- END;
-- $$



-- CREATE TABLE tb_top_youtubers(
-- cod_top_youtubers SERIAL PRIMARY KEY,
-- rank INT,
-- youtuber VARCHAR(200),
-- subscribers INT,
-- video_views VARCHAR(200),
-- video_count INT,
-- category VARCHAR(200),
-- started INT
-- );