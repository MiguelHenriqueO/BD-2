/*
Exercício 02:

Dado o seguinte esquema relacional:

Marca (id_marca, nome) 
Produto (id_pro, nome_produto, id_marca, estoque, preço) 
Pedido(id_pedido, data, valor_desc, valor_total)
ItemPedido (id_pedido, id_pro, qtde, vl_unit)

em que:

id_marca – identificador único da marca
nome – nome completo da marca, também único 
id_pro- inteiro identificador de produto
nome_produto – não necessariamente único, descreve o produto, p.ex. “borracha” 
estoque – inteiro que define a quantidade em estoque (sempre positivo)
preço – preço de venda do produto
id_pedido – inteiro identificador do pedido
data – data do pedido

Defina em SQL as seguintes restrições de integridade:

1.	O nome_produto é de preenchimento obrigatório. 
2.	Todos os valores da marca na relação Produto existem na relação Marca em id_marca. 
3.	O id_pro é um inteiro com 4 dígitos. 
4.	A data do pedido é por padrão a data atual. 
5.	No mesmo pedido, não pode haver mais de uma venda do mesmo produto.
6.	Se o preço de um item vendido é superior a 1000 então a quantidade vendida tem de ser menor que 100. 
7.	O valor total do Estoque de cada Produto não pode exceder os 250.000 (considerando o preço de venda).

*/

-- 1.	O nome_produto é de preenchimento obrigatório. 
ALTER TABLE Produto
ALTER COLUMN nome_produto VARCHAR(100) NOT NULL;

-- 2.	Todos os valores da marca na relação Produto existem na relação Marca em id_marca. 

ALTER TABLE Produto
add CONSTRAINT id_marca_fk FOREIGN KEY (id_marca) REFERENCES marca(id_marca)

-- 3.	O id_pro é um inteiro com 4 dígitos. 
ALTER TABLE Produto
ALTER COLUMN id_pro NUMERIC(4)

-- 4.	A data do pedido é por padrão a data atual. 
ALTER TABLE Pedido
add CONSTRAINT data_default DEFAULT GETDATE() for data_pedido

-- 5.	No mesmo pedido, não pode haver mais de uma venda do mesmo produto.

ALTER TABLE ItemPedido
add CONSTRAINT uniq_item_pedido UNIQUE(id_pedido,id_pro)

-- 6.	Se o preço de um item vendido é superior a 1000 então a quantidade vendida tem de ser menor que 100. 

ALTER table ItemPedido
add CONSTRAINT chk_item_preco_vend
CHECK(
    (vl_unit <= 1000)
    or
    (qtde < 100)
)

-- 7.	O valor total do Estoque de cada Produto não pode exceder os 250.000 (considerando o preço de venda).
alter table Produto
add CONSTRAINT vl_estq
CHECK(estoque * preco <= 250000)
