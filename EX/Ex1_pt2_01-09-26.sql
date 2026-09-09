use ExFuncionarios
--1
select F.nome, F.cpf, D.nomeDepar from funcionarios as F
LEFT JOIN departamentos as D
    ON F.codDepartamento = D.codDepartamento

--2
select F.nome from funcionarios as F
LEFT JOIN departamentos as D
    ON F.codDepartamento = D.codDepartamento
WHERE F.codFunc != codGerenProj

