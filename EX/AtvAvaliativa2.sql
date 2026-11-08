-- 1. Analise o modelo conceitual apresentado, se encontrar erros, corrija-os

---Cliente pode possuir vários endereços, sendo cada endereço pertencente a um único cliente.
---Venda e Produto possuem relacionamento N:N, sendo necessária a criação da entidade Item_Venda.
---Cada venda pode gerar um único registro financeiro.
---Cada venda pode gerar uma única comissão, vinculada ao vendedor responsável.
---Um vendedor pode realizar várias vendas e receber várias comissões.
---Um vendedor pode possuir vários registros de salário, permitindo armazenar o histórico salarial.
---Foram adicionadas chaves primárias para identificar cada entidade.
---Foram adicionadas chaves estrangeiras para garantir os relacionamentos entre as tabelas.
---A entidade Item_Venda foi criada para armazenar a quantidade e o valor unitário dos produtos vendidos.

--2. Complete com as cardinalidades de cada relacionamento (você vai precisar simular algumas regras de
--negócio, como por exemplo: um cliente poderá ter somente um endereço ou terá mais de um endereço?)

-- Cliente e Endereço: 1:N
-- Um cliente pode possuir vários endereços, mas cada endereço pertence a um único cliente.

-- Cliente e Venda: 1:N
-- Um cliente pode realizar várias vendas, mas cada venda pertence a um único cliente.

-- Venda e Financeiro: 1:1
-- Cada venda registrada gera um único registro financeiro.

-- Venda e Produto: N:N
-- Uma venda pode conter vários produtos e um produto pode estar presente em várias vendas.
-- Esse relacionamento é transformado na entidade Item_Venda.

-- Vendedor e Venda: 1:N
-- Um vendedor pode realizar várias vendas, mas cada venda possui um único vendedor.

-- Venda e Comissão: 1:1
-- Cada venda pode gerar uma única comissão.

-- Vendedor e Comissão: 1:N
-- Um vendedor pode receber várias comissões.

-- Vendedor e Salário: 1:N
-- Um vendedor pode possuir vários registros de salário ao longo do tempo,
-- permitindo armazenar seu histórico salarial.

---3. A partir do modelo conceitual, aplique as regras de transformações de modelos e crie as tabelas (modelo
---físico)

-- Criação da tabela ENDERECO (caso seja 1:N com Cliente, ou independente)
CREATE TABLE Endereco (
    id_endereco INT AUTO_INCREMENT PRIMARY KEY,
    rua VARCHAR(150),
    bairro VARCHAR(100),
    cep VARCHAR(10)
);

-- Criação da tabela CLIENTE
CREATE TABLE Cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    fone VARCHAR(20),
    limite_credito DECIMAL(10,2),
    id_endereco INT,
    CONSTRAINT fk_cliente_endereco FOREIGN KEY (id_endereco) REFERENCES Endereco(id_endereco)
);

-- Criação da tabela VENDEDOR
CREATE TABLE Vendedor (
    id_vendedor INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    fone VARCHAR(20),
    funcao VARCHAR(50)
);

-- Criação da tabela SALARIO
CREATE TABLE Salario (
    id_salario INT AUTO_INCREMENT PRIMARY KEY,
    id_vendedor INT NOT NULL,
    data_salario DATE,
    vl_fixo DECIMAL(10,2),
    vl_comissao DECIMAL(10,2),
    CONSTRAINT fk_salario_vendedor FOREIGN KEY (id_vendedor) REFERENCES Vendedor(id_vendedor)
);

-- Criação da tabela PRODUTO
CREATE TABLE Produto (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    unidade VARCHAR(10),
    estoque INT NOT NULL
);

-- Criação da tabela VENDA
CREATE TABLE Venda (
    id_venda INT AUTO_INCREMENT PRIMARY KEY,
    data_venda DATE NOT NULL,
    vl_frete DECIMAL(10,2),
    id_cliente INT NOT NULL,
    id_vendedor INT NOT NULL,
    CONSTRAINT fk_venda_cliente FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    CONSTRAINT fk_venda_vendedor FOREIGN KEY (id_vendedor) REFERENCES Vendedor(id_vendedor)
);

-- Criação da tabela FINANCEIRO (Relacionada à Venda)
CREATE TABLE Financeiro (
    id_financeiro INT AUTO_INCREMENT PRIMARY KEY,
    id_venda INT NOT NULL,
    dt_lancto DATE NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    dt_vencto DATE NOT NULL,
    dt_liq DATE,
    CONSTRAINT fk_financeiro_venda FOREIGN KEY (id_venda) REFERENCES Venda(id_venda)
);

-- Tabela Associativa para o relacionamento N:N entre VENDA e PRODUTO (Itens da Venda)
CREATE TABLE Venda_Produto (
    id_venda INT,
    id_produto INT,
    qtde INT NOT NULL,
    vl_unit DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_venda, id_produto),
    CONSTRAINT fk_vp_venda FOREIGN KEY (id_venda) REFERENCES Venda(id_venda),
    CONSTRAINT fk_vp_produto FOREIGN KEY (id_produto) REFERENCES Produto(id_produto)
);

-- Tabela Associativa para a COMISSÃO (relacionando Venda e Vendedor, ou ligada à Venda/Salário)
CREATE TABLE Comissao (
    id_comissao INT AUTO_INCREMENT PRIMARY KEY,
    id_venda INT NOT NULL,
    id_vendedor INT NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_comissao_venda FOREIGN KEY (id_venda) REFERENCES Venda(id_venda),
    CONSTRAINT fk_comissao_vendedor FOREIGN KEY (id_vendedor) REFERENCES Vendedor(id_vendedor)
);

-- Questão 4: Analise e crie corretamente as chaves primárias das tabelas.

-- Tabela ENDERECO
-- Chave Primária: id_endereco (Identificador único de cada endereço)
CREATE TABLE Endereco (
    id_endereco INT AUTO_INCREMENT PRIMARY KEY,
    rua VARCHAR(150),
    bairro VARCHAR(100),
    cep VARCHAR(10)
);

-- Tabela CLIENTE
-- Chave Primária: id_cliente (Identificador único do cliente)
-- Chave Estrangeira: id_endereco (Relaciona o cliente ao seu endereço)
CREATE TABLE Cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    fone VARCHAR(20),
    limite_credito DECIMAL(10,2),
    id_endereco INT,
    CONSTRAINT pk_cliente PRIMARY KEY (id_cliente),
    CONSTRAINT fk_cliente_endereco FOREIGN KEY (id_endereco) REFERENCES Endereco(id_endereco)
);

-- Tabela VENDEDOR
-- Chave Primária: id_vendedor (Identificador único do vendedor)
CREATE TABLE Vendedor (
    id_vendedor INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    fone VARCHAR(20),
    funcao VARCHAR(50),
    CONSTRAINT pk_vendedor PRIMARY KEY (id_vendedor)
);

-- Tabela SALARIO
-- Chave Primária: id_salario (Identificador único do registro salarial)
-- Chave Estrangeira: id_vendedor (Vincula o salário ao vendedor correspondente)
CREATE TABLE Salario (
    id_salario INT AUTO_INCREMENT PRIMARY KEY,
    id_vendedor INT NOT NULL,
    data_salario DATE,
    vl_fixo DECIMAL(10,2),
    vl_comissao DECIMAL(10,2),
    CONSTRAINT pk_salario PRIMARY KEY (id_salario),
    CONSTRAINT fk_salario_vendedor FOREIGN KEY (id_vendedor) REFERENCES Vendedor(id_vendedor)
);

-- Tabela PRODUTO
-- Chave Primária: id_produto (Identificador único do produto no estoque)
CREATE TABLE Produto (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    unidade VARCHAR(10),
    estoque INT NOT NULL,
    CONSTRAINT pk_produto PRIMARY KEY (id_produto)
);

-- Tabela VENDA
-- Chave Primária: id_venda (Identificador único da nota/transação de venda)
-- Chaves Estrangeiras: id_cliente e id_vendedor
CREATE TABLE Venda (
    id_venda INT AUTO_INCREMENT PRIMARY KEY,
    data_venda DATE NOT NULL,
    vl_frete DECIMAL(10,2),
    id_cliente INT NOT NULL,
    id_vendedor INT NOT NULL,
    CONSTRAINT pk_venda PRIMARY KEY (id_venda),
    CONSTRAINT fk_venda_cliente FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    CONSTRAINT fk_venda_vendedor FOREIGN KEY (id_vendedor) REFERENCES Vendedor(id_vendedor)
);

-- Tabela FINANCEIRO
-- Chave Primária: id_financeiro (Identificador único do lançamento financeiro)
-- Chave Estrangeira: id_venda (Vincula o financeiro à venda geradora)
CREATE TABLE Financeiro (
    id_financeiro INT AUTO_INCREMENT PRIMARY KEY,
    id_venda INT NOT NULL,
    dt_lancto DATE NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    dt_vencto DATE NOT NULL,
    dt_liq DATE,
    CONSTRAINT pk_financeiro PRIMARY KEY (id_financeiro),
    CONSTRAINT fk_financeiro_venda FOREIGN KEY (id_venda) REFERENCES Venda(id_venda)
);

-- Tabela Associativa VENDA_PRODUTO (Itens da Venda - Relacionamento N:N)
-- Chave Primária Composta: (id_venda, id_produto) pois uma venda tem vários produtos e um produto pode estar em várias vendas
CREATE TABLE Venda_Produto (
    id_venda INT,
    id_produto INT,
    qtde INT NOT NULL,
    vl_unit DECIMAL(10,2) NOT NULL,
    CONSTRAINT pk_venda_produto PRIMARY KEY (id_venda, id_produto),
    CONSTRAINT fk_vp_venda FOREIGN KEY (id_venda) REFERENCES Venda(id_venda),
    CONSTRAINT fk_vp_produto FOREIGN KEY (id_produto) REFERENCES Produto(id_produto)
);

-- Tabela COMISSÃO
-- Chave Primária: id_comissao (Identificador único da comissão)
-- Chaves Estrangeiras: id_venda e id_vendedor
CREATE TABLE Comissao (
    id_comissao INT AUTO_INCREMENT PRIMARY KEY,
    id_venda INT NOT NULL,
    id_vendedor INT NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    CONSTRAINT pk_comissao PRIMARY KEY (id_comissao),
    CONSTRAINT fk_comissao_venda FOREIGN KEY (id_venda) REFERENCES Venda(id_venda),
    CONSTRAINT fk_comissao_vendedor FOREIGN KEY (id_vendedor) REFERENCES Vendedor(id_vendedor)
);


-- 5. Crie as restrições de integridade:

CREATE TABLE Endereco (
    id_endereco INT AUTO_INCREMENT PRIMARY KEY,
    rua VARCHAR(150),
    bairro VARCHAR(100),
    cep VARCHAR(10)
);

-- a. Nome do cliente é um campo obrigatório (NOT NULL aplicado)
CREATE TABLE Cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    fone VARCHAR(20),
    limite_credito DECIMAL(10,2),
    id_endereco INT,
    CONSTRAINT pk_cliente PRIMARY KEY (id_cliente),
    CONSTRAINT fk_cliente_endereco FOREIGN KEY (id_endereco) REFERENCES Endereco(id_endereco)
);

-- d. Função do vendedor só pode ser 'Balcão', 'Externo', 'Aprendiz', 'Supervisor'
CREATE TABLE Vendedor (
    id_vendedor INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    fone VARCHAR(20),
    funcao VARCHAR(50),
    CONSTRAINT pk_vendedor PRIMARY KEY (id_vendedor),
    CONSTRAINT chk_vendedor_funcao CHECK (funcao IN ('Balcão', 'Externo', 'Aprendiz', 'Supervisor'))
);

-- f. Quando o salário fixo for maior que R$ 2.000,00 a comissão não poderá ser maior que R$ 1.800,00
CREATE TABLE Salario (
    id_salario INT AUTO_INCREMENT PRIMARY KEY,
    id_vendedor INT NOT NULL,
    data_salario DATE,
    vl_fixo DECIMAL(10,2),
    vl_comissao DECIMAL(10,2),
    CONSTRAINT pk_salario PRIMARY KEY (id_salario),
    CONSTRAINT fk_salario_vendedor FOREIGN KEY (id_vendedor) REFERENCES Vendedor(id_vendedor),
    CONSTRAINT chk_salario_comissao CHECK (NOT (vl_fixo > 2000.00 AND vl_comissao > 1800.00))
);

-- e. Para os produtos vendidos com unidade 'PÇ' o estoque não poderá ser negativo (estoque >= 0 quando unidade = 'PÇ')
CREATE TABLE Produto (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    unidade VARCHAR(10),
    estoque INT NOT NULL,
    CONSTRAINT pk_produto PRIMARY KEY (id_produto),
    CONSTRAINT chk_produto_estoque CHECK (NOT (unidade = 'PÇ' AND estoque < 0))
);

-- b. Data da venda tem valor padrão como sendo a data atual do sistema (DEFAULT CURRENT_DATE)
CREATE TABLE Venda (
    id_venda INT AUTO_INCREMENT PRIMARY KEY,
    data_venda DATE NOT NULL DEFAULT (CURRENT_DATE),
    vl_frete DECIMAL(10,2),
    id_cliente INT NOT NULL,
    id_vendedor INT NOT NULL,
    CONSTRAINT pk_venda PRIMARY KEY (id_venda),
    CONSTRAINT fk_venda_cliente FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    CONSTRAINT fk_venda_vendedor FOREIGN KEY (id_vendedor) REFERENCES Vendedor(id_vendedor)
);

-- g. A data de vencimento do financeiro não pode ser menor que a data de lançamento (dt_vencto >= dt_lancto)
CREATE TABLE Financeiro (
    id_financeiro INT AUTO_INCREMENT PRIMARY KEY,
    id_venda INT NOT NULL,
    dt_lancto DATE NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    dt_vencto DATE NOT NULL,
    dt_liq DATE,
    CONSTRAINT pk_financeiro PRIMARY KEY (id_financeiro),
    CONSTRAINT fk_financeiro_venda FOREIGN KEY (id_venda) REFERENCES Venda(id_venda),
    CONSTRAINT chk_financeiro_datas CHECK (dt_vencto >= dt_lancto)
);

CREATE TABLE Venda_Produto (
    id_venda INT,
    id_produto INT,
    qtde INT NOT NULL,
    vl_unit DECIMAL(10,2) NOT NULL,
    CONSTRAINT pk_venda_produto PRIMARY KEY (id_venda, id_produto),
    CONSTRAINT fk_vp_venda FOREIGN KEY (id_venda) REFERENCES Venda(id_venda),
    CONSTRAINT fk_vp_produto FOREIGN KEY (id_produto) REFERENCES Produto(id_produto)
);

-- c. Valor da comissão deve ser sempre maior que zero (valor > 0)
CREATE TABLE Comissao (
    id_comissao INT AUTO_INCREMENT PRIMARY KEY,
    id_venda INT NOT NULL,
    id_vendedor INT NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    CONSTRAINT pk_comissao PRIMARY KEY (id_comissao),
    CONSTRAINT fk_comissao_venda FOREIGN KEY (id_venda) REFERENCES Venda(id_venda),
    CONSTRAINT fk_comissao_vendedor FOREIGN KEY (id_vendedor) REFERENCES Vendedor(id_vendedor),
    CONSTRAINT chk_comissao_valor CHECK (valor > 0)
);

-- 6. Crie comandos para simular transações explícitas nas tabelas para os casos:

-- =====================================================================
-- a. Transação explícita para atualizar a venda para 'REGISTRADO' e inserir o financeiro
-- =====================================================================
START TRANSACTION;

-- 1. Atualiza a situação da venda para 'REGISTRADO'
UPDATE Venda 
SET situacao = 'REGISTRADO' 
WHERE id_venda = 1;

-- 2. Insere o registro financeiro correspondente à venda registrada
INSERT INTO Financeiro (id_venda, dt_lancto, valor, dt_vencto, dt_liq)
VALUES (1, CURRENT_DATE(), 1500.00, DATE_ADD(CURRENT_DATE(), INTERVAL 30 DAY), NULL);

-- Se tudo ocorrer sem erros, efetiva a transação:
COMMIT;
-- Caso ocorra algum erro lógico ou de exceção, use: ROLLBACK;

-- =====================================================================
-- b. Transação explícita para inserir um item da venda e atualizar o estoque do produto
-- =====================================================================
START TRANSACTION;

-- 1. Insere o item na tabela associativa Venda_Produto (ex: 2 unidades do produto id 5)
INSERT INTO Venda_Produto (id_venda, id_produto, qtde, vl_unit)
VALUES (1, 5, 2, 75.00);

-- 2. Atualiza (baixa) o estoque do produto correspondente subtraindo a quantidade vendida
UPDATE Produto 
SET estoque = estoque - 2 
WHERE id_produto = 5;

-- Efetiva a transação se o estoque for suficiente e a inserção ocorrer com sucesso:
COMMIT;
-- Em caso de falha (ex: estoque insuficiente): ROLLBACK;

-- =====================================================================
-- c. Transação explícita para inserir uma venda e sua respectiva comissão
-- =====================================================================
START TRANSACTION;

-- 1. Insere a nova venda (gerando o id_venda, recuperado via LAST_INSERT_ID() ou valor fixo)
INSERT INTO Venda (data_venda, vl_frete, id_cliente, id_vendedor, situacao)
VALUES (CURRENT_DATE(), 50.00, 2, 3, 'REGISTRADO');

-- 2. Insere a comissão vinculada ao vendedor e à venda recém-criada
INSERT INTO Comissao (id_venda, id_vendedor, valor)
VALUES (LAST_INSERT_ID(), 3, 150.00);

-- Confirma a gravação conjunta (atômica) da venda e de sua comissão:
COMMIT;
-- Se houver qualquer divergência nos valores: ROLLBACK;