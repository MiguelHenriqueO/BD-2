create DATABASE prodAtv

use prodAtv

create TABLE fabricante(
    codFabr int constraint pk_codFabr PRIMARY KEY IDENTITY(1,1),
    razaoSocial VARCHAR(80) CONSTRAINT nn_razao NOT NULL,
    cidade VARCHAR(80) CONSTRAINT Df_cidade DEFAULT('Franca'),
    uf VARCHAR(2) CONSTRAINT chk_uf CHECK(uf in('SP', 'MG', 'RJ'))
)

CREATE table categoria(
    codCat int CONSTRAINT pk_codCat PRIMARY KEY IDENTITY(1,1),
    descricao varchar(100) CONSTRAINT nn_desc NOT NULL,
    statusCat varchar(20) CONSTRAINT chk_status CHECK(statusCat in ('ATIVO', 'INATIVO'))
)

create table produto(
    codPro int CONSTRAINT pk_codPro PRIMARY KEY IDENTITY(1,1),
    descricaoProd VARCHAR(100) CONSTRAINT nn_descProd NOT NULL,
    preco int 
)



-- a)	Cidade do Fabricante tem valor padrão como sendo ‘FRANCA’
alter TABLE fabricante
add CONSTRAINT df_cidade DEFAULT('FRANCA') FOR cidade   

-- b)	Campo Razão Social é um campo obrigatório.
alter table fabricante
alter COLUMN razaoSocial VARCHAR(100) NOT NULL

-- c)	Só poderão ser cadastrados fabricantes de SP, MG ou RJ.
alter table fabricante 
add CONSTRAINT chk_uf check(uf in('SP','MG','RJ'))

-- d)	Descrição do produto é obrigatório.
alter table produto
alter COLUMN descricaoProd VARCHAR(100) NOT NULL

-- e)	Status da categoria poderá ser ATIVO ou INATIVO.
alter table categoria
add CONSTRAINT chk_stt check(statusCat in('ATIVO', 'INATIVO'))

--f)	Crie um campo para guardar o estoque dos produtos. Este campo deverá ser sempre um número positivo.
alter table produto
add estoqueProd int CONSTRAINT chk_estoq CHECK(estoqueProd > 0)

-- g)	Preço do produto deverá ser sempre maior que 0 (zero).
alter table produto
add CONSTRAINT chk_preco CHECK(preco > 0)

-- h)	Observe as restrições impostas pelas cardinalidades.
alter table produto
ADD codFabr INT,
    codCat INT


alter table produto
add CONSTRAINT fk_codFabr FOREIGN KEY(codFabr) REFERENCES fabricante(codFabr)

alter table produto
add CONSTRAINT fk_codCat FOREIGN KEY (codCat) REFERENCES categoria(codCat)

-- i)	Código da categoria deverá ser um número inteiro de 3 dígitos.
alter table categoria     
add CONSTRAINT pk_codCat
PRIMARY KEY (codcat)

alter TABLE categoria
add CONSTRAINT chk_codCat CHECK(codCat >= 100 and codCat <= 999)


-------------------------------

-- part 2

-- a.	Listar o código do produto, sua descrição e preço, a categoria, o nome e a cidade do fabricante.

create view vProFabCat 
as 
SELECT p.codPro, p.descricaoProd as NomePro, p.preco, c.descricao, f.razaoSocial, f.cidade
from produto as p
INNER JOIN categoria as c
    on c.codCat = p.codCat
INNER JOIN fabricante as f
    on f.codFabr = p.codFabr

select * from vProFabCat


-- b.	Listar os produtos dos fabricantes do RJ.
create view vProFabRJ
as 
SELECT p.descricaoProd, p.codPro, p.preco, f.uf
from produto as p
INNER JOIN fabricante as f
    on p.codFabr = f.codFabr

WHERE f.uf = 'RJ'

-- c.	Selecionar de forma exclusiva as categorias que possuem produtos fornecidos para o estado de SP e que estão em categorias inativas.

create view vCatProFabrSp
as 
SELECT c.descricao, c.statusCat, c.codCat, p.codPro, f.uf
from produto as p
INNER JOIN categoria as c
    on p.codCat = c.codCat
INNER JOIN fabricante as f
    on p.codFabr = f.codFabr

where f.uf = 'SP' and c.statusCat = 'INATIVO'


-- d.	Listar os nomes dos produtos, o preço total dos seus estoques (considerando o preço de venda) e o nome das categorias que eles pertencem. Somente de produtos fabricados em SP.

create view estoqueSp
as 
SELECT p.descricaoProd as produto, c.descricao, (estoqueProd * preco) as valorEstoque
from produto as p
INNER join fabricante as f 
    on p.codFabr = f.codFabr
INNER JOIN categoria as c
    on p.codCat= c.codCat
where f.uf = 'SP'

---------------------------------------------------------------------
-- part 3
-- 3.	Crie uma nova tabela para cadastro de Marcas com os campos CodMarca e NomeMarca. O código deverá ser chave primária com numeração automática a partir de 5000 e o Nome da marca precisará ser único e de preenchimento obrigatório.
create table marca(
    codMarca int CONSTRAINT pk_marca PRIMARY KEY IDENTITY(5000, 1),
    NomeMarca VARCHAR(50) CONSTRAINT uk_nome UNIQUE NOT NULL
)

--4.	Cada produto poderá ter apenas uma marca.
alter table produto add codMarca INT
    CONSTRAINT fk_pro_marca FOREIGN KEY REFERENCES Marca(codMarca)

ALTER table marca 
add CONSTRAINT unq_marca UNIQUE(NomeMarca)

-- 5.	Cadastre 5 marcas.
insert into marca
VALUES 
    ('coca'),
    ('Sprite'),
    ('fors'),
    ('Antartica'),
    ('fanta')


--6.	Crie uma view que informe quais são os fabricantes e as marcas dos produtos que estão nas categorias Inativas.
create view vFabriInativo
AS
SELECT f.razaoSocial, m.NomeMarca
from fabricante as f
    INNER JOIN produto as p on p.codFabr = f.codFabr
    INNER JOIN marca as m on p.codMarca = m.codMarca
    INNER JOIN categoria as c on p.codCat = c.codCat
where c.statusCat = 'INATIVO'

-- 7.	Crie uma nova view para mostrar a descrição e os preços dos produtos e suas respectivas marcas, ordenado por produto.
create view vProMarca
as 
select p.descricaoProd, p.preco, m.NomeMarca
from produto as p
    INNER JOIN marca as m on p.codMarca = m.codMarca

SELECT * from vProMarca
order by descricaoProd