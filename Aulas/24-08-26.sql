

CREATE TABLE Professores (
    codProf INT CONSTRAINT pk_codProf PRIMARY KEY IDENTITY(1,1),
    nome VARCHAR(80) NOT NULL,
    rg numeric(12) UNIQUE,
    sexo CHAR(1) CHECK(sexo in ('M', 'F')),
    idade INT CHECK(idade BETWEEN 21 AND 80),
    cidade VARCHAR(50) CONSTRAINT df_Prof_cidade DEFAULT ('Franca'),
    titulacao VARCHAR(15) CONSTRAINT chk_tit CHECK(titulacao in ('graduado', 'especialisata', 'mestre', 'doutor')),
    categoria varchar(15) CHECK(categoria in ('auxiliar', 'assistete', 'adjunto', 'titular')),

    salario money CHECK(salario >= 500)
)

SELECT * FROM Professores

INSERT into Professores(rg,sexo,idade,titulacao,categoria,salario, nome)
VALUES
    (5746578, 'F', 30, 'graduado', 'auxiliar', 1800, 'Ana')

INSERT into Professores(rg,sexo,idade,titulacao,categoria,salario, nome)
VALUES
    (1234, 'M', 25, 'graduado', 'auxiliar', 2000, 'João')

ALTER TABLE Professores
add 
  CONSTRAINT ch_titulacao_salario CHECK
(
    (titulacao = 'graduado' and salario < 1000)
    OR
    (titulacao <> 'graduado')
)
