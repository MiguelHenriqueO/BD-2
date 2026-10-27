CREATE DATABASE BdVestibular;
GO
USE BdVestibular;
GO

-- 1 e 2
CREATE TABLE curso (
  codCur INT CONSTRAINT pk_codCur PRIMARY KEY IDENTITY(1,1),
  nome VARCHAR(80) NOT NULL,
  cargaHoraria INT CONSTRAINT chk_cargaHoraria CHECK(cargaHoraria in (2800, 3600)),
  nroVagas INT
);

CREATE TABLE candidato (
  codCan INT CONSTRAINT pk_codCan PRIMARY KEY IDENTITY(1,1),
  nome VARCHAR(80) NOT NULL,
  endereco VARCHAR(80),
  cpf VARCHAR(40),
  rg VARCHAR(40),
  situacao varchar(80) CONSTRAINT chk_situacao_candidato CHECK(situacao in ('Aprovado', 'Reprovado', 'Aprovado em 2ª chamada')),
  dtCadastro DATETIME CONSTRAINT dft_dtCadastro DEFAULT GETDATE()
);

CREATE TABLE inscricao (
  codIns INT CONSTRAINT pk_codIns PRIMARY KEY IDENTITY(1,1),
  nota NUMERIC(4,2),
  anoInscr INT,
  dataInscr DATETIME,
  situacao varchar(80) CONSTRAINT chk_situacao_inscricao CHECK(situacao in ('Aguardando pagamento', 'Cancelado', 'Encerrado', 'Pago')),
  codCan INT CONSTRAINT fk_codCan FOREIGN KEY REFERENCES candidato(codCan),
  codCur1 INT CONSTRAINT fk_codCur_1opcao FOREIGN KEY REFERENCES curso(codCur),
  codCur2 INT CONSTRAINT fk_codCur_2opcao FOREIGN KEY REFERENCES curso(codCur),

  CONSTRAINT uq_candidato_ano UNIQUE(codCan, anoInscr),
  CONSTRAINT chk_cursos CHECK(codCur1 <> codCur2)
);

CREATE TABLE pagamento (
  codPag INT CONSTRAINT pk_codPag PRIMARY KEY IDENTITY(1,1),
  vlPago MONEY,
  VlJurosMulta MONEY,
  dtVencto DATETIME CONSTRAINT dft_timestamp DEFAULT GETDATE() + 10,
  dtPagto DATETIME,
  dtRegistro DATETIME,
  codIns INT CONSTRAINT fk_codIns FOREIGN KEY REFERENCES inscricao(codIns)
);

-- 3
BEGIN TRANSACTION;

  INSERT INTO inscricao(nota, anoInscr, dataInscr, situacao, codCan, codCur1, codCur2)
  VALUES (NULL, 2026, GETDATE(), 'Aguardando pagamento', 1, 1, 2);

  DECLARE @UltimoCodIns INT;
  SET @UltimoCodIns = SCOPE_IDENTITY();

  INSERT INTO pagamento (vlPago, VlJurosMulta, dtPagto, dtRegistro, codIns)
  VALUES (NULL, NULL, NULL, GETDATE(), @UltimoCodIns);

COMMIT TRANSACTION;

-- 4
BEGIN TRANSACTION;
  UPDATE inscricao
  SET nota = 8.5
  WHERE codIns = 1;

  UPDATE candidato
  SET situacao = 'Aprovado'
  WHERE codCan = (SELECT codCan FROM inscricao WHERE codIns = 1);

COMMIT TRANSACTION;


-- 5
BEGIN TRANSACTION;

  UPDATE pagamento
  SET vlPago = 150.00,
      VlJurosMulta = 0.00,
      dtPagto = GETDATE()
  WHERE codIns = 1; 

  UPDATE inscricao
  SET situacao = 'Pago'
  WHERE codIns = 1;

COMMIT TRANSACTION;