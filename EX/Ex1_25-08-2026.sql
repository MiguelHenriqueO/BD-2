CREATE TABLE TB_Cliente(
    codigo INT CONSTRAINT pk_codigo_cliente PRIMARY KEY IDENTITY (1,1) NOT NULL,
    nome VARCHAR(50) CONSTRAINT nome_cliente NOT NULL, 
    telefone VARCHAR(20) CONSTRAINT tele_cliente NOT NULL,
    tipo_cliente VARCHAR(20) CONSTRAINT tipo_cliente CHECK(tipo_cliente in ('Titular', 'Dependente')) NOT NULL,
    dt_cadastro DATETIME CONSTRAINT dt_cadastro_cliente NOT NULL DEFAULT GETDATE(),
    nr_dependentes INT CONSTRAINT nr_dependentes_cliente CHECK(nr_dependentes >= 0 AND nr_dependentes <= 3) NOT NULL,


)

INSERT into TB_Cliente(nome, telefone, tipo_cliente, nr_dependentes)
VALUES
    ('Claudio', '1234353', 'Titular', 3)



INSERT into TB_Cliente( telefone, tipo_cliente, nr_dependentes)
VALUES
    ( '214567', 'Dependente', 0)


INSERT into TB_Cliente(nome, tipo_cliente, nr_dependentes)
VALUES
    ('Mario', 'Titular', 1)


INSERT into TB_Cliente(nome, telefone, tipo_cliente, nr_dependentes)
VALUES
    ('Roberta', '09871', 'Avó', 2)


INSERT into TB_Cliente(nome, telefone, tipo_cliente, nr_dependentes)
VALUES
    ('Jubesval', '324678', 'Titular', 7)

