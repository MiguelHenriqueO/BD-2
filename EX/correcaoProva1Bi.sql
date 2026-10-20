create DATABASE prova
GO
use prova

create table participante(
    id int PRIMARY KEY IDENTITY (1,1),
    nome VARCHAR(90),
    data_nasc date,
    profissao VARCHAR(50),
    cidade VARCHAR(80),
    uf varchar(2),
    status VARCHAR(30) CONSTRAINT ck_sta check(status in('ATIVO', 'ELIMINADO'))

)   

create table prova(
    id int constraint pk_prov PRIMARY KEY IDENTITY(1,1),
    nome varchar(40),
    data DATE CONSTRAINT df_dat DEFAULT(GETDATE()),
    tipo VARCHAR(50),
    tempo_minutos int CONSTRAINT ck_temp CHECK (tempo_minutos BETWEEN 0 and 180)
)

create table ingrediente(
    id int CONSTRAINT pk_ingr PRIMARY KEY identity(1,1),
    nome VARCHAR(80),
    categoria varchar(80)
)

CREATE table prato(
    id int CONSTRAINT pk_prato PRIMARY KEY IDENTITY(1,1),
    nome VARCHAR(80),
    descricao VARCHAR (300),
    dificuldade VARCHAR(80) CONSTRAINT df_dif DEFAULT('MÉDIA'),
    id_partic int CONSTRAINT fk_part FOREIGN KEY REFERENCES participante(id),
    id_prova int constraint pf_prov FOREIGN KEY REFERENCES prova(id)

)

create table utiliza(
    id int CONSTRAINT pk_util PRIMARY KEY IDENTITY(1,1),
    quantidade int,
    unidade int,
    unidade_medida VARCHAR(10),
    id_prato int CONSTRAINT fk_prat FOREIGN KEY REFERENCES prato(id),
    id_ingrediente int CONSTRAINT fk_ingred FOREIGN KEY REFERENCES ingrediente(id)
)

--2 
insert into prova(nome, tipo, tempo_minutos)
VALUES('Desafio da massa', 'ELIMINAÇÃO', '90')

UPDATE prova
set tempo_minutos = 120
WHERE tipo = 'ELIMINAÇÃO' and tempo_minutos < 90


--3
UPDATE participante
set status = 'ELIMINADO'
where 
    uf =  'SP' AND
    status = 'ATIVO' AND
    data_nasc < '1995/01/01'

