CREATE DATABASE PROVA
GO
USE PROVA

CREATE TABLE participante(
  id INT CONSTRAINT PK_PART PRIMARY KEY IDENTITY(1,1),
  nome VARCHAR(90),
  data_nasc DATE,
  profissao VARCHAR(50),
  cidade VARCHAR(80),
  uf VARCHAR(2),
  status VARCHAR(30) CONSTRAINT CK_STA CHECK(status IN('ATIVO', 'ELIMINADO'))
)

CREATE TABLE prova(
  id INT CONSTRAINT PK_PROV PRIMARY KEY IDENTITY(1,1),
  nome VARCHAR(40),
  data DATE CONSTRAINT DF_DAT DEFAULT(GETDATE()), 
  tipo VARCHAR(50),
  tempo_minutos INT CONSTRAINT CK_TEMP CHECK(tempo_minutos BETWEEN 0 AND 180) 
)

CREATE TABLE ingrediente(
  id INT CONSTRAINT PK_INGR PRIMARY KEY IDENTITY(1,1),
  nome VARCHAR(80),
  categoria VARCHAR(80)
)

CREATE TABLE prato(
  id INT CONSTRAINT PK_PRATO PRIMARY KEY IDENTITY(1,1),
  nome VARCHAR(80),
  descricao VARCHAR(300), 
  dificuldade VARCHAR(80) CONSTRAINT DF_DIF DEFAULT('MÉDIA'),
  id_partic INT CONSTRAINT FK_PART FOREIGN KEY REFERENCES participante(id),
  id_prova INT CONSTRAINT FK_PROV FOREIGN KEY REFERENCES prova(id)
)


CREATE TABLE utiliza(
  id INT CONSTRAINT PK_UTIL PRIMARY KEY IDENTITY(1,1),
  quantidade INT,
  unidade_medida VARCHAR(10),
  id_prato INT CONSTRAINT FK_PRAT FOREIGN KEY REFERENCES prato(id),
  id_ingrediente INT CONSTRAINT FK_INGRED FOREIGN KEY REFERENCES ingrediente(id)
)

--========================================

-- CADASTRAR PARTICIPANTES
INSERT INTO participante (nome, data_nasc, profissao, cidade, uf, status)
VALUES
('Ana Paula', '1992-05-15', 'Chef', 'São Paulo', 'SP', 'ATIVO'),
('Bruno Silva', '1998-08-20', 'Estudante', 'Campinas', 'SP', 'ATIVO'),
('Carla Souza', '1990-03-10', 'Confeiteira', 'Rio de Janeiro', 'RJ', 'ATIVO'),
('Daniel Costa', '1985-11-25', 'Cozinheiro', 'Santos', 'SP', 'ATIVO'),
('Eduarda Lima', '2000-07-12', 'Nutricionista', 'Belo Horizonte', 'MG', 'ATIVO'),
('Felipe Rocha', '1995-09-18', 'Professor', 'Curitiba', 'PR', 'ELIMINADO'),
('Gabriela Alves', '1997-02-28', 'Chef', 'Ribeirão Preto', 'SP', 'ATIVO'),
('Henrique Martins', '1988-06-05', 'Empresário', 'Niterói', 'RJ', 'ATIVO'),
('Isabela Ferreira', '2001-12-01', 'Estudante', 'Uberlândia', 'MG', 'ATIVO'),
('João Pedro', '1993-04-22', 'Cozinheiro', 'Franca', 'SP', 'ATIVO');

-- CADASTRAR PROVAS
INSERT INTO prova (nome, tipo, tempo_minutos)
VALUES
('Desafio da Massa', 'ELIMINAÇÃO', 90),
('Sobremesa Criativa', 'ELIMINAÇÃO', 60),
('Prato Principal', 'INDIVIDUAL', 120),
('Cozinha Regional', 'EQUIPE', 150),
('Desafio do Chocolate', 'ELIMINAÇÃO', 45),
('Culinária Italiana', 'INDIVIDUAL', 100),
('Prato Vegetariano', 'ELIMINAÇÃO', 80),
('Desafio Final', 'FINAL', 180);

-- CADASTRAR INGREDIENTES
INSERT INTO ingrediente(nome, categoria)
VALUES
('Leite', 'Laticínios'),
('Queijo Mussarela', 'Laticínios'),
('Manteiga', 'Laticínios'),
('Creme de Leite', 'Laticínios'),
('Farinha de Trigo', 'Cereais'),
('Arroz', 'Cereais'),
('Macarrão', 'Massas'),
('Tomate', 'Vegetais'),
('Cebola', 'Vegetais'),
('Batata', 'Vegetais'),
('Frango', 'Carnes'),
('Carne Bovina', 'Carnes'),
('Chocolate', 'Doces'),
('Açúcar', 'Doces'),
('Ovo', 'Ovos');

-- CADASTRAR PRATOS
INSERT INTO prato(nome, descricao, dificuldade, id_partic, id_prova)
VALUES
('Lasanha Bolonhesa', 'Lasanha com carne e queijo', 'DIFÍCIL', 1, 1),
('Bolo de Chocolate', 'Bolo com cobertura de chocolate', 'MÉDIA', 1, 2),
('Risoto de Queijo', 'Risoto cremoso com queijo', 'MÉDIA', 1, 3),
('Macarrão ao Molho Branco', 'Macarrão com creme de leite', 'FÁCIL', 2, 1),
('Pizza Caseira', 'Pizza com queijo e tomate', 'MÉDIA', 2, 6),
('Torta de Chocolate', 'Torta recheada com chocolate', 'DIFÍCIL', 3, 2),
('Frango Assado', 'Frango temperado e assado', 'MÉDIA', 3, 3),
('Batata Gratinada', 'Batata com queijo e creme de leite', 'FÁCIL', 3, 7),
('Filé ao Molho', 'Carne bovina com molho especial', 'DIFÍCIL', 4, 3),
('Arroz Especial', 'Arroz com legumes', 'FÁCIL', 4, 4),
('Suflê de Queijo', 'Suflê preparado com queijo', 'DIFÍCIL', 5, 7),
('Panqueca', 'Panqueca recheada com carne', 'MÉDIA', 5, 1),
('Brownie', 'Brownie de chocolate', 'FÁCIL', 6, 5),
('Nhoque de Batata', 'Nhoque com molho de tomate', 'MÉDIA', 7, 6),
('Lasanha de Queijo', 'Lasanha recheada com queijo', 'DIFÍCIL', 7, 1),
('Bolo Simples', 'Bolo tradicional', 'FÁCIL', 7, 2),
('Carne Assada', 'Carne bovina assada', 'MÉDIA', 8, 4),
('Risoto de Frango', 'Risoto com frango', 'DIFÍCIL', 9, 8),
('Macarrão ao Queijo', 'Macarrão com queijo', 'FÁCIL', 10, 1),
('Torta Salgada', 'Torta recheada com frango', 'MÉDIA', 10, 7);

-- CADASTRAR UTILIZAÇÃO DE INGREDIENTES
-- Relaciona os pratos aos ingredientes
INSERT INTO utiliza(quantidade, unidade_medida, id_prato, id_ingrediente)
VALUES
(500, 'g', 1, 12),
(300, 'g', 1, 2),
(200, 'g', 1, 7),

(200, 'g', 2, 13),
(150, 'g', 2, 14),
(3, 'un', 2, 15),

(300, 'g', 3, 6),
(200, 'g', 3, 2),
(100, 'g', 3, 3),

(250, 'g', 4, 7),
(200, 'ml', 4, 4),
(100, 'ml', 4, 1),

(300, 'g', 5, 5),
(250, 'g', 5, 2),
(150, 'g', 5, 8),

(300, 'g', 6, 13),
(200, 'g', 6, 5),
(100, 'g', 6, 3),

(500, 'g', 7, 11),
(200, 'g', 7, 10),

(400, 'g', 8, 10),
(200, 'g', 8, 2),
(150, 'ml', 8, 4),

(500, 'g', 9, 12),
(100, 'g', 9, 9),

(300, 'g', 10, 6),
(150, 'g', 10, 8),

(200, 'g', 11, 2),
(150, 'ml', 11, 1),
(3, 'un', 11, 15),

(300, 'g', 12, 5),
(250, 'g', 12, 12),

(200, 'g', 13, 13),
(100, 'g', 13, 3),

(400, 'g', 14, 10),
(200, 'g', 14, 5),

(300, 'g', 15, 2),
(200, 'g', 15, 7),

(250, 'g', 16, 5),
(200, 'g', 16, 14),

(500, 'g', 17, 12),
(150, 'g', 17, 9),

(300, 'g', 18, 6),
(250, 'g', 18, 11),

(300, 'g', 19, 7),
(200, 'g', 19, 2),

(250, 'g', 20, 5),
(200, 'g', 20, 11);

--========================================

-- 1. Liste a quantidade total de participantes cadastrados em cada estado (UF). Exiba a UF e a quantidade de participantes, ordenando do estado com maior quantidade para o de menor quantidade.
SELECT
  uf,
  COUNT(*) AS totalParticipante
FROM participante
GROUP BY uf
ORDER BY COUNT(*) DESC

-- 2. Liste o tipo de prova e a média de duração das provas de cada tipo. Exiba somente os tipos de prova cuja média de duração seja superior a 120 minutos.
SELECT
  tipo,
  AVG(tempo_minutos) AS duracaoMedia
FROM prova
GROUP BY tipo
HAVING AVG(tempo_minutos) > 120

-- 3. Liste o nome dos participantes e a quantidade de pratos preparados por cada um. Exiba somente os participantes que tenham preparado mais de 2 pratos.

-- 4. Liste o nome de cada ingrediente e a soma total das quantidades utilizadas nos pratos. Exiba o nome do ingrediente, a unidade de medida e a quantidade total utilizada, ordenando do ingrediente mais utilizado para o menos utilizado. Considere as quantidades separadamente por unidade de medida.