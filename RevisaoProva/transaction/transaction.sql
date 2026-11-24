CREATE DATABASE LojaGamesProva;
GO

USE LojaGamesProva;
GO

CREATE TABLE Cliente (
    IdCliente INT IDENTITY(1,1) PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Saldo DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    CONSTRAINT CK_Cliente_Saldo CHECK (Saldo >= 0)
);

CREATE TABLE Jogo (
    IdJogo INT IDENTITY(1,1) PRIMARY KEY,
    Titulo VARCHAR(120) NOT NULL,
    Preco DECIMAL(10,2) NOT NULL,
    Estoque INT NOT NULL,
    CONSTRAINT CK_Jogo_Preco CHECK (Preco > 0),
    CONSTRAINT CK_Jogo_Estoque CHECK (Estoque >= 0)
);

CREATE TABLE Pedido (
    IdPedido INT IDENTITY(1,1) PRIMARY KEY,
    IdCliente INT NOT NULL,
    IdJogo INT NOT NULL,
    Quantidade INT NOT NULL,
    ValorTotal DECIMAL(10,2) NOT NULL,
    DataPedido DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    CONSTRAINT FK_Pedido_Cliente FOREIGN KEY (IdCliente) REFERENCES Cliente(IdCliente),
    CONSTRAINT FK_Pedido_Jogo FOREIGN KEY (IdJogo) REFERENCES Jogo(IdJogo),
    CONSTRAINT CK_Pedido_Quantidade CHECK (Quantidade > 0)
);

-- Dados iniciais para você testar
INSERT INTO Cliente (Nome, Saldo) VALUES
    ('Lucas', 200.00),
    ('Mariana', 50.00);

INSERT INTO Jogo (Titulo, Preco, Estoque) VALUES
    ('Elden Ring', 180.00, 5),
    ('Hollow Knight', 60.00, 1);
GO

-- transaction que da erro pois cai no catch

BEGIN TRY

    BEGIN TRANSACTION;

        INSERT into Pedido
        VALUES(
            2,2,2,120.00,'2026-06-12'
        )

        update Jogo
        set Estoque = Estoque -2
        where IdJogo = 2


        update Cliente
        set Saldo = Saldo - 120.00
        where IdCliente = 2

    COMMIT TRANSACTION;

END TRY
BEGIN CATCH
    SELECT 
        ERROR_NUMBER()  AS NumeroErro,
        ERROR_MESSAGE() AS MensagemErro,
        ERROR_LINE()    AS LinhaErro;
    
    if XACT_STATE() <> 0
        ROLLBACK TRANSACTION

END CATCH

select * FROM Pedido


-- transaction correta
BEGIN TRY

    BEGIN TRANSACTION;

        INSERT into Pedido
        VALUES(
            1,2,1,60.00,'2026-06-12'
        )

        update Jogo
        set Estoque = Estoque -1
        where IdJogo = 2


        update Cliente
        set Saldo = Saldo - 60.00
        where IdCliente = 1

    COMMIT TRANSACTION;

END TRY
BEGIN CATCH
    SELECT 
        ERROR_NUMBER()  AS NumeroErro,
        ERROR_MESSAGE() AS MensagemErro,
        ERROR_LINE()    AS LinhaErro;
    
    if XACT_STATE() <> 0
        ROLLBACK TRANSACTION

END CATCH

select * FROM Pedido 