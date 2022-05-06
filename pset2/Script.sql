
/*

Professor, construí todo o script usando o command line do PostgreSQL, quando testei alguns comandos no MySql da faculdade não rodou. Comando comando como o que usei para tirar o valor da idade em anos, DATEPART no PostgreSQL que sempre dá erro no MySQL.

*/



/* QUESTÃO 01: prepare um relatório que mostre a média salarial dos funcionários
de cada departamento. */

SELECT 
	numero_departamento 	AS departamento,
	AVG(salario)		AS media_salarial
FROM funcionario
GROUP BY numero_departamento;




/* Questao 2: Descobrir media salarial de homens e mulheres */

SELECT 
	sexo 		AS genero,
	AVG(salario) 	AS media_salarial
FROM funcionario
GROUP BY sexo;


/* Questao 3: Prepare um relatório que liste o nome dos departamentos e, para
cada departamento, inclua as seguintes informações de seus funcionários: o nome
completo, a data de nascimento, a idade em anos completos e o salário. */

SELECT 
	nome_departamento 						AS departamento, 
	CONCAT(primeiro_nome,' ', nome_meio,' ', ultimo_nome) 		AS nome, 
	data_nascimento, 
	DATE_PART ('year', NOW()) - DATE_PART ('year', data_nascimento)	AS idade, 
	salario 
FROM 
	departamento dp
INNER JOIN funcionario  f ON f.numero_departamento = dp.numero_departamento
ORDER BY nome_departamento ASC;


/* QUESTÃO 04: prepare um relatório que mostre o nome completo dos funcionários,
a idade em anos completos, o salário atual e o salário com um reajuste que
obedece ao seguinte critério: se o salário atual do funcionário é inferior a 35.000 o
reajuste deve ser de 20%, e se o salário atual do funcionário for igual ou superior a
35.000 o reajuste deve ser de 15%.*/

SELECT 
 	CONCAT(primeiro_nome,' ', nome_meio,' ', ultimo_nome) 			AS nome,
 	DATE_PART ('year', NOW()) - DATE_PART ('year', data_nascimento)		AS idade, 
	salario 								AS salario_atual, 

CASE 
	WHEN salario < 35000 THEN salario + salario * 0.2
	WHEN salario >= 35000 THEN salario + salario * 0.15 

END 										AS salario_reajustado
FROM funcionario
ORDER BY nome ASC;

/* QUESTÃO 05: prepare um relatório que liste, para cada departamento, o nome
do gerente e o nome dos funcionários. Ordene esse relatório por nome do departamento
(em ordem crescente) e por salário dos funcionários (em ordem decrescente). */
/*

SELECT 
		
CASE 
	WHEN dp.numero_departamento = 1 THEN 'Jorge E. Brito'
	WHEN dp.numero_departamento = 4 THEN 'Jennifer S. Souza'
	WHEN dp.numero_departamento = 5 THEN 'Fernando T. Wong'
END 									AS gerente,
	nome_departamento 						AS departamento,
	CONCAT(primeiro_nome,' ', nome_meio,' ', ultimo_nome) 		AS funcionario,
	salario

FROM departamento dp

INNER JOIN funcionario f ON (dp.numero_departamento = f.numero_departamento)
ORDER BY nome_departamento ASC, salario DESC;


*/

/* QUESTÃO 06: prepare um relatório que mostre o nome completo dos funcionários
que têm dependentes, o departamento onde eles trabalham e, para cada funcionário,
também liste o nome completo dos dependentes, a idade em anos de cada
dependente e o sexo (o sexo NÃO DEVE aparecer como M ou F, deve aparecer
como “Masculino” ou “Feminino”).*/
 
SELECT
	CONCAT(primeiro_nome,' ', nome_meio,' ', ultimo_nome) 			AS funcionario,
	numero_departamento 							AS departamento,
	CONCAT(nome_dependente,' ', ultimo_nome) 				AS dependente, 
	DATE_PART ('year', NOW()) - DATE_PART ('year', d.data_nascimento) 	AS idade_dependente,

CASE
	WHEN d.sexo = 'M' THEN 'Masculino'
	WHEN d.sexo = 'F' THEN 'Feminino'

END 										AS genero_dependente

FROM funcionario f
INNER JOIN dependente d ON (f.cpf = d.cpf_funcionario);

/* QUESTÃO 07: prepare um relatório que mostre, para cada funcionário que NÃO
TEM dependente, seu nome completo, departamento e salário.*/ 

SELECT
	CONCAT(primeiro_nome,' ', nome_meio,' ', ultimo_nome) 			AS funcionario,
	f.numero_departamento 							AS departamento,
	salario
FROM funcionario f
LEFT OUTER JOIN dependente d ON (f.cpf = d.cpf_funcionario)
WHERE d.cpf_funcionario IS NULL
ORDER BY departamento ASC;

/* QUESTÃO 08: prepare um relatório que mostre, para cada departamento, os projetos
desse departamento e o nome completo dos funcionários que estão alocados
em cada projeto. Além disso inclua o número de horas trabalhadas por cada funcionário,
em cada projeto.*/ 
	
SELECT DISTINCT
	f.numero_departamento 							AS departamento, 
	p.nome_projeto,
	CONCAT(primeiro_nome,' ', nome_meio,' ', ultimo_nome) 			AS funcionario,
	SUM(horas) 								AS horas						
FROM funcionario f
INNER JOIN trabalha_em te ON (f.cpf = te.cpf_funcionario)
INNER JOIN projeto p ON ( te.numero_projeto = p.numero_projeto)
WHERE f.cpf = te.cpf_funcionario
GROUP BY f.numero_departamento, p.nome_projeto, funcionario
ORDER BY funcionario;


/* QUESTÃO 09: prepare um relatório que mostre a soma total das horas de cada
projeto em cada departamento. Obs.: o relatório deve exibir o nome do departamento,
o nome do projeto e a soma total das horas.*/

SELECT
	p.nome_projeto 					AS nome_projeto,
	d.nome_departamento 				AS nome_departamento,
	SUM(horas) 					AS horas_trabalhadas

FROM projeto p
INNER JOIN departamento d ON ( d.numero_departamento = p.numero_departamento)
INNER JOIN trabalha_em te ON ( te.numero_projeto = p.numero_projeto)
GROUP BY p.nome_projeto, d.nome_departamento
ORDER BY p.nome_projeto;


/* 

A QUESTÃO 10 ESTÁ IGUAL A PRIMEIRA!!
 
QUESTÃO 10: prepare um relatório que mostre a média salarial dos funcionários
de cada departamento.

*/


/* QUESTÃO 11: considerando que o valor pago por hora trabalhada em um projeto
é de 50 reais, prepare um relatório que mostre o nome completo do funcionário, o
nome do projeto e o valor total que o funcionário receberá referente às horas trabalhadas
naquele projeto. */

SELECT
	CONCAT(primeiro_nome,' ', nome_meio,' ', ultimo_nome) 			AS funcionario,
	nome_projeto,
	SUM(horas) * 50 							AS valor
FROM funcionario f
INNER JOIN projeto p ON ( p.numero_departamento = f.numero_departamento)
INNER JOIN trabalha_em te ON (te.numero_projeto = p.numero_projeto)
GROUP BY funcionario, nome_projeto
ORDER BY funcionario ASC;

/* QUESTÃO 12: seu chefe está verificando as horas trabalhadas pelos funcionários
nos projetos e percebeu que alguns funcionários, mesmo estando alocadas à algum
projeto, não registraram nenhuma hora trabalhada. Sua tarefa é preparar um relatório
que liste o nome do departamento, o nome do projeto e o nome dos funcionários
que, mesmo estando alocados a algum projeto, não registraram nenhuma hora trabalhada. */


SELECT DISTINCT
	nome_departamento,
	nome_projeto,
	CONCAT(primeiro_nome,' ', nome_meio,' ', ultimo_nome) 			AS funcionario

FROM funcionario f
INNER JOIN departamento d ON ( d.numero_departamento = f.numero_departamento)
INNER JOIN projeto p ON ( p.numero_departamento = d.numero_departamento)
INNER JOIN trabalha_em te ON ( te.cpf_funcionario = f.cpf)
WHERE te.horas IS NULL;

/* QUESTÃO 13: durante o natal deste ano a empresa irá presentear todos os funcionários
e todos os dependentes (sim, a empresa vai dar um presente para cada
funcionário e um presente para cada dependente de cada funcionário) e pediu para
que você preparasse um relatório que listasse o nome completo das pessoas a serem
presenteadas (funcionários e dependentes), o sexo e a idade em anos completos
(para poder comprar um presente adequado). Esse relatório deve estar ordenado
pela idade em anos completos, de forma decrescente. */

SELECT
	CONCAT(primeiro_nome,' ', nome_meio,' ', ultimo_nome) 			AS nome_completo,
	DATE_PART ('year', NOW()) - DATE_PART ('year', data_nascimento) 	AS idade,
	sexo 									AS genero								
FROM funcionario 
UNION
SELECT
	CONCAT(nome_dependente,' ', ultimo_nome),
	DATE_PART ('year', NOW()) - DATE_PART ('year', d.data_nascimento),
	d.sexo 					
FROM dependente d
INNER JOIN funcionario f ON ( d.cpf_funcionario = f.cpf)
ORDER BY idade DESC;




/* QUESTÃO 14: prepare um relatório que exiba quantos funcionários cada departamento
tem. */
	
SELECT
	f.numero_departamento 		AS numero,
	d.nome_departamento 		AS departamento,
	COUNT(cpf) 			AS numero_funcionarios

FROM funcionario f
INNER JOIN departamento d ON (d.numero_departamento = f.numero_departamento)
GROUP BY departamento, numero
ORDER BY numero ASC;


/* QUESTÃO 15: como um funcionário pode estar alocado em mais de um projeto,
prepare um relatório que exiba o nome completo do funcionário, o departamento
desse funcionário e o nome dos projetos em que cada funcionário está alocado.
Atenção: se houver algum funcionário que não está alocado em nenhum projeto,
o nome completo e o departamento também devem aparecer no relatório. */

SELECT 
	CONCAT(primeiro_nome,' ', nome_meio,' ', ultimo_nome) 			AS nome_completo,
	nome_departamento,
	nome_projeto
FROM funcionario f
INNER JOIN departamento d ON (d.numero_departamento = f.numero_departamento)
INNER JOIN projeto p ON (p.numero_departamento = d.numero_departamento)
ORDER BY nome_completo ASC;
	
