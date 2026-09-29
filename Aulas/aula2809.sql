CREATE DATABASE aula2809
GO
USE aula2809

--##########

CREATE TABLE Time (
    idTime INT CONSTRAINT PK_TIME PRIMARY KEY IDENTITY(1,1),
    nome VARCHAR(50) NOT NULL,
    cidade VARCHAR(50),
    estado VARCHAR(2),
    anoFundacao INT
);

CREATE TABLE Jogador (
    idJogador INT CONSTRAINT PK_JOGADOR PRIMARY KEY IDENTITY(1,1),
    nome VARCHAR(80) NOT NULL,
    apelido VARCHAR(40),
    posicao VARCHAR(30),
    salario DECIMAL(10,2),
    dataNascimento DATE,
    numeroCamisa INT,
    idTime INT,

    CONSTRAINT FK_TIME_JOGADOR FOREIGN KEY (idTime) REFERENCES Time(idTime)
);


-- ============================================================
-- 2. INSERÇÃO DOS DADOS
-- ============================================================

INSERT INTO Time (nome, cidade, estado, anoFundacao)
VALUES
('Flamengo', 'Rio de Janeiro', 'RJ', 1895),
('Palmeiras', 'São Paulo', 'SP', 1914),
('Corinthians', 'São Paulo', 'SP', 1910),
('São Paulo', 'São Paulo', 'SP', 1930),
('Cruzeiro', 'Belo Horizonte', 'MG', 1921),
('Grêmio', 'Porto Alegre', 'RS', 1903);


INSERT INTO Jogador
(nome, apelido, posicao, salario, dataNascimento, numeroCamisa, idTime)
VALUES
('Marcelo Santos', 'Marcelinho', 'Atacante', 85000, '1998-05-12', 9, 1),
('Bruno Oliveira', NULL, 'Goleiro', 55000, '1995-08-20', 1, 1),
('Lucas Almeida', 'Luquinha', 'Meia', 72000, '2000-03-15', 10, 1),
('Matheus Silva', NULL, 'Zagueiro', 60000, '1997-11-02', 4, 1),

('Gabriel Souza', 'Biel', 'Atacante', 92000, '1999-01-25', 11, 2),
('Pedro Martins', 'Pedrinho', 'Meia', 78000, '2001-06-17', 8, 2),
('Rafael Costa', NULL, 'Zagueiro', 63000, '1996-09-08', 3, 2),
('Carlos Mendes', NULL, 'Goleiro', 58000, '1994-12-11', 1, 2),

('Marcos Ferreira', 'Marcão', 'Zagueiro', 67000, '1995-04-30', 4, 3),
('Felipe Rocha', NULL, 'Atacante', 88000, '2000-07-21', 9, 3),
('André Lima', 'Dedé', 'Meia', 74000, '1998-02-14', 10, 3),

('Rodrigo Alves', NULL, 'Goleiro', 52000, '1993-10-05', 1, 4),
('Miguel Ribeiro', 'Migué', 'Atacante', 95000, '2002-05-19', 7, 4),
('Daniel Barbosa', NULL, 'Meia', 76000, '1999-08-09', 8, 4),

('Eduardo Lopes', 'Dudu', 'Atacante', 81000, '1997-03-22', 11, 5),
('Henrique Gomes', NULL, 'Zagueiro', 59000, '1996-01-18', 3, 5),
('Gustavo Moraes', 'Guga', 'Meia', 70000, '2001-09-27', 10, 5),

('Leonardo Nunes', 'Leo', 'Goleiro', 50000, '1995-06-16', 1, 6),
('Thiago Cardoso', NULL, 'Atacante', 83000, '1998-12-03', 9, 6),
('Murilo Teixeira', 'Muri', 'Meia', 69000, '2000-10-10', 8, 6);

-- avg e count

select count(*) as qtdeTotal, posicao
from Jogador
GROUP BY posicao


select AVG(salario) as mediaSalarial, posicao
from Jogador
GROUP BY posicao

-- like 

SELECT *
FROM Jogador
WHERE nome LIKE 'M%'

SELECT *
FROM Jogador
WHERE nome LIKE '%Silva'

SELECT *
FROM Jogador
WHERE nome LIKE '%el%'

-- upper lower

SELECT 
    nome,
    UPPER(nome) as nomeMaiu,
    LOWER(nome) as nomeMin
FROM Jogador

-- primeiros 5 caracteres

SELECT 
    nome,
    LEFT(nome, 5) as primeirosCaracteres
FROM Jogador

SELECT 
    nome,
    RIGHT(nome, 5) as ultimosCaracteres
FROM Jogador

select
    nome,
    LEFT(nome, 5) as primeirosCaracteres,
    RIGHT(nome, 5) as ultimosCaracteres,
    SUBSTRING(nome, 3, 5) as parteNome
from Jogador
    
-- getdate

SELECT GETDATE() as dataHoraAtual

SELECT 
    nome,
    dataNascimento,
    GETDATE() as dataHoraAtual
FROM Jogador

-- dateformat

set dateformat dmy

INSERT into Jogador
(nome, posicao, salario, dataNascimento, numeroCamisa,idTime)
VALUEs
('João Pereira', 'Atacante', 65000, '25/08/2000',17,1)

-- isnull

select
    nome,
    ISNULL(apelido, 'Sem Apelido') as Apelido
from Jogador

-- top n


SELECT top 5
    nome,
    salario
FROM Jogador
ORDER BY salario DESC

SELECT top 3
    nome,
    salario
FROM Jogador
ORDER BY salario 
