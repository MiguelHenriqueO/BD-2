CREATE DATABASE vestibular

USE vestibular

CREATE TABLE candidato(
    codCan int CONSTRAINT pk_candidato PRIMARY KEY IDENTITY(1,1),
    nome varchar(80),
    endereco varchar(250),
    cpf VARCHAR(90),
    rg VARCHAR(90)
)

CREATE TABLE curso(
    codCur int CONSTRAINT pk_curso PRIMARY KEY IDENTITY(1,1),
    nome varchar(80),
    cargaHoraria VARCHAR(100),
    nroVagas INT
)

CREATE TABLE inscricao(
    codIns int CONSTRAINT pk_inscricao PRIMARY KEY IDENTITY(1,1),
    nota INT,
    anoInscr INT,
    dataInscr DATE,

    -- fk's
    codCan int CONSTRAINT fk_inscr_candidato FOREIGN KEY REFERENCES candidato(codCan),
    codCur int CONSTRAINT fk_inscr_curso FOREIGN KEY REFERENCES curso(codCur)
)

CREATE TABLE pagamento(
    codPag int CONSTRAINT pk_pag PRIMARY KEY IDENTITY(1,1),
    VlPago DECIMAL(10,2),
    VlJurosMulta DECIMAL(10,2),
    dtVencimento
)