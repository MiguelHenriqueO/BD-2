

create database clinicaVeterinaria

USE clinicaVeterinaria

create table veterinario(

	codMed int primary key identity(1,1),
	nome varchar(80),
	dataNasc date,

);

create table animal(

	codPac int primary key identity(1,1),
	nomeAnimal varchar(80),
	especie varchar(80)

);

create table consulta(

	codConsul int primary key identity(1,1),
	dataConsul date,
	valor money,
	codMed int foreign key references veterinario(codMed),
	codPac int foreign key references animal(codPac)

);

--- 1.	Cadastrar 5 médicos (veterinários) para esta clínica

insert into veterinario
values
	
	('Paulo', '1998-12-09'),
	('Roberto', '1998-07-21'),
	('Mario', '1987-05-31'),
	('Marina' , '2002-08-28'),
	('Carla' , '1997-07-10')

---2.	Cadastrar 10 pacientes (animais) para a clínica de pelo menos 3 espécies diferentes

INSERT INTO animal
VALUES
    ('Rex', 'Cachorro'),
    ('Mel', 'Cachorro'),
    ('Thor', 'Cachorro'),
    ('Luna', 'Gato'),
    ('Mia', 'Gato'),
    ('Nina', 'Gato'),
    ('Pipoca', 'Coelho'),
    ('Bidu', 'Coelho'),
    ('Fred', 'Papagaio'),
    ('Toby', 'Papagaio');

---3.	Cadastre 20 consultas para estes médicos e pacientes com datas e valores diferentes

INSERT INTO consulta
VALUES
    ('2026-01-05', 150.00, 1, 1),
    ('2026-01-08', 200.00, 2, 4),
    ('2026-01-12', 180.00, 3, 7),
    ('2026-01-15', 250.00, 4, 2),
    ('2026-01-20', 120.00, 5, 9),
    
    ('2026-02-03', 170.00, 1, 3),
    ('2026-02-07', 220.00, 2, 5),
    ('2026-02-11', 135.00, 3, 8),
    ('2026-02-16', 300.00, 4, 6),
    ('2026-02-21', 190.00, 5, 10),
    
    ('2026-03-02', 160.00, 1, 2),
    ('2026-03-06', 275.00, 2, 7),
    ('2026-03-10', 145.00, 3, 1),
    ('2026-03-15', 210.00, 4, 9),
    ('2026-03-20', 185.00, 5, 4),
    
    ('2026-04-04', 230.00, 1, 6),
    ('2026-04-09', 155.00, 2, 3),
    ('2026-04-14', 320.00, 3, 10),
    ('2026-04-19', 175.00, 4, 5),
    ('2026-04-25', 260.00, 5, 8);

--- 1.	Selecione o maior valor pago por uma consulta
select max(valor) as maiorValorConsulta from consulta 


---2.	Selecione o valor médio, maior valor e menor valor das consultas realizadas no mês passado

select avg(valor) as valorMedio, max(valor) as maiorValor, min(valor) as menorValor 
from consulta
where dataConsul >= '2026-07-01' and dataConsul <= '2026-07-31'

--- 3.	Cadastre uma nova consulta para um paciente que já está cadastrado
insert into consulta
values
    ('2026-07-20', 200, 1, 4)

--- 4.	Atualize o nome do médico cujo código é 3 para o seu nome

update veterinario set nome = 'miguel'
where codMed = 3

---5.	Selecione as espécies de pacientes que estão cadastrados.
select distinct(especie) 
from animal

---6.	Quantas consultas você já realizou nesta clínica?
select count(codConsul) as totalConsultas
from consulta

--- 7.	Quantas consultas foram feitas por todos os médicos?

select count(codConsul) 
from consulta
where codMed is not null

---8.	Selecione, de forma exclusiva, as espécies de pacientes que estão cadastrados.

select distinct(especie)
from animal
where codPac is not null

---9.	Liste os nomes dos pacientes em ordem alfabética.

select nomeAnimal
from animal
order by nomeAnimal

--- 10.	Qual o valor total de todas as consultas feitas por você?
select sum(valor) as somaValor
from consulta
where codMed = 3

---11.	Qual a quantidade de médicos que esta clínica possui?

select count(codMed) quantidadeMedicos
from veterinario

---12.	Quanto seria o total das consultas que você realizou se estas consultas tivessem um aumento de 10%?

select sum(valor * 1.1) as somaValorAcrescido
from consulta
where codMed = 3

---13.	Quantas consultas foram feitas por você entre os dias 01/01/2026 e 31/03/2026?

SELECT COUNT(codConsul) AS qntConsultasMiguel
FROM consulta
WHERE codMed = 3 
  AND dataConsul >= '2026-01-01' 
  AND dataConsul <= '2026-03-31';


