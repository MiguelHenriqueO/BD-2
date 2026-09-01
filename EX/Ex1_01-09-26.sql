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

create TABLE Funcionarios(
    codFunc int constraint pk_funci PRIMARY KEY IDENTITY (1,1),
    Nome VARCHAR(80) CONSTRAINT Func_Nome NOT NULL,
    cpf numeric(20) CONSTRAINT uniq_cpf UNIQUE,
    rg numeric(20) CONSTRAINT uniq_rg UNIQUE,
    sexo VARCHAR(1) CONSTRAINT chk_sex CHECK(sexo IN('M' , 'F')),
    categoria VARCHAR(80) CONSTRAINT chk_cat CHECK(categoria in ('Auxiliar', 'Supervisor', 'Terceirizado', 'Contratado', 'Coordenador')),
    idade int CONSTRAINT chk_idade CHECK(idade > 15 and idade < 65),
    codDepartamento CONSTRAINT fk_cod_depart FOREIGN KEY REFERENCES

)

/*
2.	Crie uma tabela para cadastro de Departamentos, com as seguintes restrições:
	Um campo para código do departamento também com numeração automática
	Nome do departamento é atributo obrigatório
	Descrição do departamento
	Código do funcionário gerente do departamento.

*/

create table departamentos(
    
)

/*


3.	Crie uma tabela para cadastro de Projetos
	Código do projeto é atributo obrigatório com numeração automática a partir de 100
	Nome é atributo obrigatório
	Descrição do projeto

4.	Crie uma tabela para registrar a participação dos funcionários em projetos
	Código do funcionário deverá ser obrigatório
	Código do projeto deverá também ser obrigatório
	Data de início da participação no projeto
	Data de fim da participação do projeto
	- A data de início deverá ser menor que a data de fim

5.	Altere a tabela Funcionário criando uma ligação com a tabela de departamentos
6.	Crie uma restrição do tipo Chave Primária composta para a tabela Participação para os campos CodFun e CodProj
7.	Cadastre os seguintes departamentos
	CONTAS A PAGAR
	CONTAS A RECEBER
	FATURAMENTO
	VENDAS
	COMPRAS
8.	Cadastre 5 projetos
9.	Cadastre 10 funcionários
10.	Vincule 3 funcionários para cada um dos projetos cadastrados
11.	Cadastre os chefes dos departamentos
12.	Crie um campo para cidade do funcionário com valor padrão sendo 'Franca'
13.	Cadastre um novo funcionário sem preencher a cidade para testar sua constraint
14.	Crie um novo projeto e vincule 5 funcionários a este projeto
15.	Verifique se existe algum funcionário sem departamento, se houver, vincule os funcionários a algum departamento
16.	Crie uma restrição para todos os campos Descrição de todas as tabelas que possuem um campo descrição. Esta restrição deverá inserir um valor padrão para este campo.
17.	Exclua as tabelas que você criou.

*/