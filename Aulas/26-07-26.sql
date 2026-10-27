/*
================================================================================
GUIA COMPLETO: TRANSAÇÕES (TRANSACTIONS) NO MICROSOFT SQL SERVER (T-SQL)
================================================================================

O que é uma Transação?
Uma transação é uma unidade lógica de trabalho. Ela agrupa múltiplos comandos SQL
para garantir que o banco de dados passe de um estado válido para outro. Ou tudo
é executado com sucesso (**COMMIT**), ou o banco volta ao estado original (**ROLLBACK**).

As transações são fundamentais para evitar dados corrompidos ou inconsistentes.

As Propriedades ACID (O Coração das Transações):
- [A]tomicidade : Princípio do "tudo ou nada". Se uma única linha falhar dentro da
                  transação, todas as alterações anteriores dela serão desfeitas.
- [C]onsistência: Garante que todas as regras de integridade (chaves primárias,
                  estrangeiras, checagens) sejam validadas ao salvar os dados.
- [I]solamento  : Uma transação em execução fica invisível para outras consultas 
                  concorrentes até ser finalizada, evitando leituras de dados parciais.
- [D]urabilidade: Uma vez salva (Commit), a alteração é gravada permanentemente no
                  disco e não será perdida mesmo se o servidor cair logo em seguida.

SINTAXE ESPECÍFICA DO SQL SERVER (MSSQL):
- BEGIN TRANSACTION : Inicia formalmente o bloco da transação (pode abreviar para BEGIN TRAN).
- COMMIT TRANSACTION: Salva em definitivo todas as alterações pendentes.
- ROLLBACK TRANSACTION: Cancela e desfaz todas as alterações pendentes.
- SAVE TRANSACTION  : Cria um ponto de salvamento/restauração intermediário (Sub-transação).
*/

-- =============================================================================
-- CENÁRIO 1: TRANSAÇÃO BÁSICA (FLUXO DE SUCESSO - COMMIT)
-- =============================================================================
-- Contexto: Transferência bancária simples entre duas contas.

BEGIN TRANSACTION; -- Abre o bloco seguro

-- Passo 1: Retira o valor da conta de origem
UPDATE contas 
SET saldo = saldo - 100.00 
WHERE id_conta = 1;

-- Passo 2: Adiciona o valor na conta de destino
UPDATE contas 
SET saldo = saldo + 100.00 
WHERE id_conta = 2;

-- Se o sistema executou ambos os passos sem interrupções, persistimos no banco:
COMMIT TRANSACTION;


-- =============================================================================
-- CENÁRIO 2: USO DE PONTOS DE SALVAMENTO (SAVE TRANSACTION & ROLLBACK PARCIAL)
-- =============================================================================
-- Contexto: O pedido principal DEVE ser salvo. O histórico é opcional/secundário.

BEGIN TRANSACTION;

-- Operação Principal (Obrigatória)
INSERT INTO pedidos (id, cliente_id, total)
VALUES (501, 10, 250.00);

-- Criamos uma 'âncora' na memória chamada 'pos_pedido'
-- Se algo falhar daqui para frente, podemos voltar exatamente para este ponto.
SAVE TRANSACTION pos_pedido;

-- Operação Secundária (Pode falhar sem comprometer o pedido acima)
INSERT INTO historico_pedidos (pedido_id, status)
VALUES (501, 'Processando');

-- Simulação de um Rollback Seletivo:
-- Se o sistema detectar um problema com o histórico, cancelamos APENAS o histórico.
-- O pedido feito no passo inicial continua ativo na memória da transação.
ROLLBACK TRANSACTION pos_pedido;

-- Confirmamos a transação. O banco salvará o Pedido, mas não o Histórico.
COMMIT TRANSACTION;

-- =============================================================================
-- BÔNUS EVOLUÍDO: TRATAMENTO DE ERROS PROFISSIONAL COM TRY/CATCH
-- =============================================================================
-- No mundo real, você não digita Rollback manualmente. O próprio SQL Server
-- monitora os erros e desfaz tudo automaticamente usando a estrutura abaixo.

BEGIN TRY
  BEGIN TRANSACTION;

    -- Forçando um erro intencional: Divisão por zero
    -- Se o SQL tentar rodar isso, ele pula direto para o bloco CATCH abaixo.
    UPDATE contas SET saldo = saldo / 0 WHERE id_conta = 1;

    -- Este comando nunca será executado devido ao erro acima
    UPDATE contas SET saldo = saldo + 50 WHERE id_conta = 2;

  COMMIT TRANSACTION; -- Só chega aqui se NENHUM comando der erro
END TRY
BEGIN CATCH
  -- Se houver qualquer erro de banco (sintaxe, constraint, divisão por zero):
  
  -- Verificamos se a transação realmente está aberta e ativa antes do Rollback
  IF (XACT_STATE()) = 1
  BEGIN
    ROLLBACK TRANSACTION;
    PRINT 'Transação desfeita com sucesso automática devido a um erro!';
  END

  -- Exibe detalhes do erro que aconteceu para o desenvolvedor
  SELECT 
    ERROR_NUMBER() AS NumeroDoErro,
    ERROR_MESSAGE() AS MensagemDeErro;
END CATCH;


-- inicio da aula

CREATE TABLE teste (
  id INT PRIMARY KEY,
  campoA VARCHAR(80) NOT NULL,
  campoB VARCHAR(80) NULL
)

--- Transacoes de autoconfirmacao (executadas uma a uma como se fossem 3 transacoes)
INSERT INTO teste VALUES (1, 'Um texto qualquer', 'outro texto');
INSERT INTO teste VALUES (2, null, 'novo texto');
INSERT INTO teste VALUES (3, 'terceiro texto', 'outro texto');

SELECT * FROM teste;

-- colocando tudo dentro de uma transaction
BEGIN TRAN testeTran
  BEGIN TRY
    INSERT INTO teste VALUES (1, 'Um texto qualquer', 'outro texto');
    INSERT INTO teste VALUES (2, null, 'novo texto');
    INSERT INTO teste VALUES (3, 'terceiro texto', 'outro texto');

    COMMIT TRAN testeTran
  END TRY
  BEGIN CATCH
    SELECT ERROR_NUMBER() as NumeroErro,
           ERROR_LINE() as LinhaComErro,
           ERROR_MESSAGE() as MensagemErro
    ROLLBACK TRAN testeTran
  End CATCH

--- Transacao implicita

-- SET IMPLICIT_TRANSACTIONS ON
SELECT @@TRANCOUNT

PRINT @@TRANCOUNT
BEGIN TRAN
  PRINT @@TRANCOUNT
  BEGIN TRAN
    PRINT @@TRANCOUNT
  COMMIT
  PRINT @@TRANCOUNT
COMMIT
PRINT @@TRANCOUNT

--

SELECT @@TRANCOUNT
CREATE TABLE NovoTeste (
  ID int PRIMARY KEY,
  nome varchar(40),
  sexo varchar(1)
)

SELECT @@TRANCOUNT
INSERT INTO NovoTeste VALUES (500, 'Machado de assis', 'M')
SELECT * FROM NovoTeste 
SELECT @@TRANCOUNT;

COMMIT;