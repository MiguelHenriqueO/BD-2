-- REVISÃO 3 - HOTEL

CREATE DATABASE Hotel;

USE Hotel;


-- 1. CRIAÇÃO DAS TABELAS

CREATE TABLE Hospede (
    idHospede INT IDENTITY(1,1) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    sexo CHAR(1) NOT NULL,
    idade INT
);

CREATE TABLE Quarto (
    idQuarto INT IDENTITY(1,1) PRIMARY KEY,
    numero INT NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    andar INT NOT NULL,
    valorDiaria DECIMAL(10,2) NOT NULL
);

CREATE TABLE Reserva (
    idReserva INT IDENTITY(1,1) PRIMARY KEY,
    dataEntrada DATE NOT NULL,
    dataSaida DATE NOT NULL,
    idHospede INT NOT NULL,
    idQuarto INT NOT NULL,

    FOREIGN KEY (idHospede) REFERENCES Hospede(idHospede),
    FOREIGN KEY (idQuarto) REFERENCES Quarto(idQuarto)
);

CREATE TABLE Refeicao (
    idRefeicao INT IDENTITY(1,1) PRIMARY KEY,
    descricao VARCHAR(100) NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    idHospede INT NOT NULL,

    FOREIGN KEY (idHospede) REFERENCES Hospede(idHospede)
);


-- 2. CADASTRO DOS DADOS

-- 8 hóspedes
INSERT INTO Hospede (nome, sexo, idade)
VALUES
('João da Silva', 'M', 35),
('Maria Oliveira', 'F', 28),
('Pedro Santos', 'M', 42),
('Ana Souza', 'F', 31),
('Carlos Pereira', 'M', 25),
('Juliana Costa', 'F', 36),
('Lucas Almeida', 'M', 29),
('Fernanda Lima', 'F', 24);


-- 5 quartos
INSERT INTO Quarto (numero, tipo, andar, valorDiaria)
VALUES
(101, 'Standard', 1, 150.00),
(202, 'Superior', 2, 220.00),
(301, 'Superior Master', 3, 350.00),
(402, 'Superior Master', 4, 450.00),
(501, 'Luxo', 5, 600.00);


-- 4 reservas
INSERT INTO Reserva (dataEntrada, dataSaida, idHospede, idQuarto)
VALUES
('2024-12-20', '2024-12-27', 1, 101),
('2025-01-10', '2025-01-15', 2, 202),
('2026-02-01', '2026-02-08', 3, 301),
('2026-02-10', '2026-02-16', 4, 402);


-- 6 refeições
INSERT INTO Refeicao (descricao, valor, idHospede)
VALUES
('Café da manhã', 25.00, 1),
('Almoço', 45.00, 1),
('Jantar', 50.00, 2),
('Café da manhã', 25.00, 3),
('Almoço', 40.00, 4),
('Jantar', 60.00, 4);


-- 3. QUANTIDADE DE QUARTOS DO TIPO SUPERIOR MASTER

SELECT COUNT(*) AS quantidade
FROM Quarto
WHERE tipo = 'Superior Master';


-- 4. VALOR MÉDIO PAGO POR UMA REFEIÇÃO

SELECT AVG(valor) AS valorMedio
FROM Refeicao;


-- 5. EXCLUIR IDADE E CRIAR DATA DE NASCIMENTO

ALTER TABLE Hospede
DROP COLUMN idade;

ALTER TABLE Hospede
ADD dataNascimento DATE;


-- 6. QUANTOS HÓSPEDES FIZERAM RESERVA?

SELECT COUNT(DISTINCT idHospede) AS quantidadeHospedes
FROM Reserva;


-- 7. NOMES DOS HÓSPEDES E DATAS DE ENTRADA


SELECT 
    h.nome,
    r.dataEntrada
FROM Hospede h
INNER JOIN Reserva r
    ON h.idHospede = r.idHospede;


-- 8. ATUALIZAR AS DATAS DE NASCIMENTO

UPDATE Hospede
SET dataNascimento = '1991-05-10'
WHERE idHospede = 1;

UPDATE Hospede
SET dataNascimento = '1998-08-20'
WHERE idHospede = 2;

UPDATE Hospede
SET dataNascimento = '1984-03-15'
WHERE idHospede = 3;

UPDATE Hospede
SET dataNascimento = '1995-11-02'
WHERE idHospede = 4;

UPDATE Hospede
SET dataNascimento = '2001-01-25'
WHERE idHospede = 5;

UPDATE Hospede
SET dataNascimento = '1989-07-18'
WHERE idHospede = 6;

UPDATE Hospede
SET dataNascimento = '1997-09-30'
WHERE idHospede = 7;

UPDATE Hospede
SET dataNascimento = '2002-12-05'
WHERE idHospede = 8;


-- 9. HÓSPEDES E ENTRADAS ANTES DE 01/01/2025
-- EM ORDEM ALFABÉTICA

SELECT
    h.nome,
    r.dataEntrada
FROM Hospede h
INNER JOIN Reserva r
    ON h.idHospede = r.idHospede
WHERE r.dataEntrada < '2025-01-01'
ORDER BY h.nome ASC;


-- 10. MULHERES QUE JÁ SE HOSPEDARAM NO 4º ANDAR

SELECT DISTINCT
    h.nome
FROM Hospede h
INNER JOIN Reserva r
    ON h.idHospede = r.idHospede
INNER JOIN Quarto q
    ON r.idQuarto = q.idQuarto
WHERE h.sexo = 'F'
AND q.andar = 4;


-- 11. QUARTOS QUE AINDA NÃO TIVERAM RESERVAS

SELECT
    q.numero,
    q.tipo
FROM Quarto q
LEFT JOIN Reserva r
    ON q.idQuarto = r.idQuarto
WHERE r.idReserva IS NULL;


-- 12. QUANTO JOÃO DA SILVA PAGOU POR SUAS HOSPEDAGENS?

SELECT
    h.nome,
    SUM(
        DATEDIFF(DAY, r.dataEntrada, r.dataSaida) * q.valorDiaria
    ) AS totalPago
FROM Hospede h
INNER JOIN Reserva r
    ON h.idHospede = r.idHospede
INNER JOIN Quarto q
    ON r.idQuarto = q.idQuarto
WHERE h.nome = 'João da Silva'
GROUP BY h.nome;


-- 13. QUANTOS HÓSPEDES FICARAM MAIS DE 5 DIAS
-- DURANTE FEVEREIRO DE 2026?

SELECT COUNT(DISTINCT h.idHospede) AS quantidadeHospedes
FROM Hospede h
INNER JOIN Reserva r
    ON h.idHospede = r.idHospede
WHERE r.dataEntrada >= '2026-02-01'
AND r.dataEntrada < '2026-03-01'
AND DATEDIFF(DAY, r.dataEntrada, r.dataSaida) > 5;