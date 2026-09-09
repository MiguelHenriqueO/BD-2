/*
Se precisar verificar o nome de uma constraint em uma tabela, use um dos comandos:

SELECT * FROM sys.objects
WHERE type_desc LIKE '%CONSTRAINT' AND OBJECT_NAME(parent_object_id)='Funcionario'
order by create_date desc


SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME='Departamento'


1.	Crie uma tabela para cadastro de Funcionários, obedecendo as seguintes regras:
	Um campo para código deverá ser chave primária com numeração automática,
	Defina as chaves de todas as demais tabelas desta forma.
	Nome é um atributo obrigatório;
	CPF e RG são atributos que têm valor único para cada funcionário;
	Sexo poderá ser: 'M' ou 'F';
	Categoria deverá ser um dos seguintes valores: Auxiliar, Supervisor, Terceirizado, Contratado, Coordenador.
	Idade deve estar entre 16 e 65 anos;
	Código de departamento que este funcionário trabalha.
*/

create DATABASE ExFuncionarios

use ExFuncionarios

create TABLE funcionarios(
    codFunc int constraint pk_funci PRIMARY KEY IDENTITY (1,1),
    Nome VARCHAR(80) CONSTRAINT Func_Nome NOT NULL,
    cpf numeric(20) CONSTRAINT uniq_cpf UNIQUE,
    rg numeric(20) CONSTRAINT uniq_rg UNIQUE,
    sexo VARCHAR(1) CONSTRAINT chk_sex CHECK(sexo IN('M' , 'F')),
    categoria VARCHAR(80) CONSTRAINT chk_cat CHECK(categoria in ('Auxiliar', 'Supervisor', 'Terceirizado', 'Contratado', 'Coordenador')),
    idade int CONSTRAINT chk_idade CHECK(idade > 15 and idade < 65),
    codDepartamento INT 

)


/*
2.	Crie uma tabela para cadastro de Departamentos, com as seguintes restrições:
	Um campo para código do departamento também com numeração automática
	Nome do departamento é atributo obrigatório
	Descrição do departamento
	Código do funcionário gerente do departamento.

*/

create table departamentos(
    codDepartamento int CONSTRAINT pk_id_codDepar PRIMARY KEY IDENTITY(1,1),
	nomeDepar VARCHAR(80) CONSTRAINT nn_nomeDepar NOT NULL,
	descDepar VARCHAR(100),
	codGerenProj int 

	

)

ALTER TABLE departamentos
add CONSTRAINT fk_codGerenProj FOREIGN KEY (codGerenProj) REFERENCES funcionarios(codFunc) 

/*


3.	Crie uma tabela para cadastro de Projetos
	Código do projeto é atributo obrigatório com numeração automática a partir de 100
	Nome é atributo obrigatório
	Descrição do projeto

*/

CREATE TABLE cadastroProj(
	codProj int CONSTRAINT pk_codProj PRIMARY KEY IDENTITY(100,1),
	nome VARCHAR(80) CONSTRAINT nn_nome_cadastroProj NOT NULL,
	descProj VARCHAR(100) 
)

exec sp_rename 'cadastroProj.CodProj' , 'codProj', 'COLUMN';

/*

4.	Crie uma tabela para registrar a participação dos funcionários em projetos
	Código do funcionário deverá ser obrigatório
	Código do projeto deverá também ser obrigatório
	Data de início da participação no projeto
	Data de fim da participação do projeto
	- A data de início deverá ser menor que a data de fim
*/ 

CREATE TABLE participacaoProj(
	codFunc int CONSTRAINT pk_fk_codFunc FOREIGN KEY REFERENCES funcionarios(codFunc),
	codProj int CONSTRAINT pk_fk_codproj FOREIGN KEY REFERENCES cadastroProj(codProj),
	dataIni DATE,
	dataFim DATE,

	CONSTRAINT pk_partipacaoProj PRIMARY KEY (codFunc, codProj),

	CONSTRAINT chk_dataProj CHECK (dataIni < dataFim),
)

/*
5.	Altere a tabela Funcionário criando uma ligação com a tabela de departamentos


*/


ALTER TABLE departamentos
add CONSTRAINT fk_codDepart FOREIGN KEY (codDepartamento) REFERENCES departamentos(codDepartamento) 



/*

6.	Crie uma restrição do tipo Chave Primária composta para a tabela Participação para os campos CodFun e CodProj

*/

alter table participacaoProj
add CONSTRAINT chk_dataProj CHECK (dataIni < dataFim)

/*
7.	Cadastre os seguintes departamentos
	CONTAS A PAGAR
	CONTAS A RECEBER
	FATURAMENTO
	VENDAS
	COMPRAS

*/

insert into departamentos (nomeDepar, descDepar)
VALUES
	('Contas a pagar', 'departamento de contas a pagar' ),
	('Contas a receber', 'departamento de contas a receber'),
	('Faturamento', 'departamento de faturamento'),
	('vendas', 'departamento de vendas'),
	('compras', 'dapartamento de compras')


/*
8.	Cadastre 5 projetos
*/

INSERT INTO cadastroProj (nome, descProj)
VALUES 
    ('Sistema ERP', 'Desenvolvimento do novo sistema integrado de gestão'),
    ('Migração de Nuvem', 'Migrar a infraestrutura local para AWS'),
    ('App Cliente', 'Criação do aplicativo móvel para o cliente final'),
    ('Segurança da Informação', 'Auditoria e implementação de melhorias na rede'),
    ('Portal de Vendas', 'Reformulação do e-commerce da empresa');



/*
9.	Cadastre 10 funcionários

*/

INSERT INTO funcionarios (Nome, cpf, rg, sexo, categoria, idade, codDepartamento)
VALUES 
    ('Ana Souza', 12345678901, 112223334, 'F', 'Supervisor', 35, 1),
    ('Carlos Silva', 23456789012, 223334445, 'M', 'Coordenador', 42, 2),
    ('Beatriz Santos', 34567890123, 334445556, 'F', 'Auxiliar', 24, 3),
    ('Daniel Oliveira', 45678901234, 445556667, 'M', 'Contratado', 29, 4),
    ('Fernanda Lima', 56789012345, 556667778, 'F', 'Terceirizado', 31, 5),
    ('Gabriel Costa', 67890123456, 667778889, 'M', 'Auxiliar', 19, 1),
    ('Juliana Ribeiro', 78901234567, 778889990, 'F', 'Supervisor', 48, 2),
    ('Lucas Martins', 89012345678, 889990001, 'M', 'Contratado', 26, 3),
    ('Mariana Pereira', 90123456789, 990001112, 'F', 'Coordenador', 50, 4),
    ('Ricardo Alves', 10987654321, 101112223, 'M', 'Terceirizado', 33, 5);


/*
10.	Vincule 3 funcionários para cada um dos projetos cadastrados
*/
INSERT INTO participacaoProj (codFunc, codProj, dataIni, dataFim)
VALUES
    -- Projeto 100 (Sistema ERP): Funcionários 1, 2 e 3
    (1, 100, '2026-01-10', '2026-06-30'),
    (2, 100, '2026-01-15', '2026-05-20'),
    (3, 100, '2026-02-01', '2026-07-15'),

    -- Projeto 101 (Migração de Nuvem): Funcionários 4, 5 e 6
    (4, 101, '2026-02-10', '2026-08-30'),
    (5, 101, '2026-03-01', '2026-06-15'),
    (6, 101, '2026-02-15', '2026-09-01'),

    -- Projeto 102 (App Cliente): Funcionários 7, 8 e 9
    (7, 102, '2026-01-05', '2026-04-30'),
    (8, 102, '2026-01-20', '2026-05-10'),
    (9, 102, '2026-02-10', '2026-06-01'),

    -- Projeto 103 (Segurança da Informação): Funcionários 10, 1 e 4
    (10, 103, '2026-03-15', '2026-10-31'),
    (1, 103, '2026-04-01', '2026-09-15'),
    (4, 103, '2026-03-20', '2026-11-30'),

    -- Projeto 104 (Portal de Vendas): Funcionários 2, 5 e 8
    (2, 104, '2026-05-01', '2026-12-20'),
    (5, 104, '2026-05-10', '2026-11-15'),
    (8, 104, '2026-06-01', '2026-10-05');

/*
11.	Cadastre os chefes dos departamentos
*/

UPDATE departamentos
set codGerenProj = case codDepartamento
	when 1 then 1
	when 2 then 2
	when 3 then 3
	when 4 then 4
	when 5 then 5
end
where codDepartamento in (1, 2, 3,4,5)

/*
12.	Crie um campo para cidade do funcionário com valor padrão sendo 'Franca'

*/

alter table funcionarios
add cidade VARCHAR(80) CONSTRAINT df_cidade DEFAULT('Franca')

/*
13.	Cadastre um novo funcionário sem preencher a cidade para testar sua constraint

*/

insert into funcionarios(nome, cpf, rg, sexo, categoria, idade, codDepartamento)
VALUES
	('claudio', 12345, 543321, 'M', 'Supervisor', 40, 2) 

SELECT * from funcionarios
/*

14.	Crie um novo projeto e vincule 5 funcionários a este projeto

*/

-- 1. Criar o novo projeto (Gerará o codProj = 105)
INSERT INTO cadastroProj (nome, descProj)
VALUES ('Sistema de Logística', 'Otimização das rotas de entrega e estoque');

-- 2. Vincular 5 funcionários a este projeto (ex: funcionários de 1 a 5)
INSERT INTO participacaoProj (codFunc, codProj, dataIni, dataFim)
VALUES
    (1, 105, '2026-03-01', '2026-09-01'),
    (2, 105, '2026-03-01', '2026-09-01'),
    (3, 105, '2026-03-15', '2026-10-15'),
    (4, 105, '2026-04-01', '2026-08-01'),
    (5, 105, '2026-03-10', '2026-11-20');


/*

15.	Verifique se existe algum funcionário sem departamento, se houver, vincule os funcionários a algum departamento

*/

UPDATE funcionarios
set codDepartamento = case codFunc
	WHEN 1 then 1
	WHEN 2 then 2
	ELSE 3
end
where codDepartamento is NULL

/*

16.	Crie uma restrição para todos os campos Descrição de todas as tabelas que possuem um campo descrição. Esta restrição deverá inserir um valor padrão para este campo.

*/

-- 1. Restrição para a tabela de Departamentos
ALTER TABLE departamentos
ADD CONSTRAINT df_desc_depar DEFAULT 'Sem descrição fornecida' FOR descDepar;

-- 2. Restrição para a tabela de Projetos
ALTER TABLE cadastroProj
ADD CONSTRAINT df_desc_proj DEFAULT 'Sem descrição fornecida' FOR descProj;


/*

17.	Exclua as tabelas que você criou.
*/

drop table departamentos
drop table funcionarios
drop table participacaoProj
drop table cadastroProj

/*
*/