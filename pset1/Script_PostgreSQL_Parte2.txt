
-- Criando esquema elmasri
    
create schema elmasri

-- Autorizando o usuário a entrar no esquema elmasri

authorization lucasbraganca;

--Criando tabela funcionário

CREATE TABLE elmasri.funcionario (
                cpf CHAR(11) NOT NULL,
                primeiro_nome VARCHAR(15) NOT NULL,
                nome_meio CHAR(1),
                ultimo_nome VARCHAR(15) NOT NULL,
                data_nascimento DATE,
                endereco VARCHAR(100),
                sexo CHAR(1),
                salario NUMERIC(10,2),
                cpf_supervisor CHAR(11),
                numero_departamento INTEGER NOT NULL,
                CONSTRAINT pk_funcionario PRIMARY KEY (cpf)
);

-- Adicionando comentários

COMMENT ON COLUMN elmasri.funcionario.cpf IS 'CPF do funcionario. Sera a PK da tabela.';
COMMENT ON COLUMN elmasri.funcionario.primeiro_nome IS 'Primeiro nome do funcionario.';
COMMENT ON COLUMN elmasri.funcionario.nome_meio IS 'Inicial do nome do meio.';
COMMENT ON COLUMN elmasri.funcionario.ultimo_nome IS 'Sobrenome do funcionario.';
COMMENT ON COLUMN elmasri.funcionario.data_nascimento IS 'Data de nascimento do funcionario.';
COMMENT ON COLUMN elmasri.funcionario.endereco IS 'Endereço do funcionario.';
COMMENT ON COLUMN elmasri.funcionario.sexo IS 'Sexo do funcionario.';
COMMENT ON COLUMN elmasri.funcionario.salario IS 'Salario do funcionario.';
COMMENT ON COLUMN elmasri.funcionario.cpf_supervisor IS 'CPF do supervisor. Sera uma FK para a propria tabela.';
COMMENT ON COLUMN elmasri.funcionario.numero_departamento IS 'Numero do departamento do funcionario.';

-- Criando tabela departamento

CREATE TABLE elmasri.departamento (
                numero_departamento INTEGER NOT NULL,
                nome_departamento VARCHAR(15) NOT NULL,
                cpf_gerente CHAR(11) NOT NULL,
                data_inicio_gerente DATE,
                CONSTRAINT pk_departamento PRIMARY KEY (numero_departamento)
);

-- Adicionando comentários

COMMENT ON COLUMN elmasri.departamento.numero_departamento IS 'Numero do departamento. PK desta tabela.';
COMMENT ON COLUMN elmasri.departamento.nome_departamento IS 'Nome do departamento. Deve ser unico.';
COMMENT ON COLUMN elmasri.departamento.cpf_gerente IS 'CPF do gerente do departamento. FK da tabela funcionarios.';
COMMENT ON COLUMN elmasri.departamento.data_inicio_gerente IS 'Data do início do gerente no departamento.';

-- Criando uma Chave Alternada na tabela departamento

CREATE UNIQUE INDEX departamento_idx
 ON elmasri.departamento
 ( nome_departamento );

-- Criando tabela projeto

CREATE TABLE elmasri.projeto (
                numero_projeto INTEGER NOT NULL,
                nome_projeto VARCHAR(15) NOT NULL,
                local_projeto VARCHAR(15),
                numero_departamento INTEGER NOT NULL,
                CONSTRAINT pk_projeto PRIMARY KEY (numero_projeto)
);

-- Adicionando comentários

COMMENT ON COLUMN elmasri.projeto.numero_projeto IS 'Numero do projeto.PK desta tabela.';
COMMENT ON COLUMN elmasri.projeto.nome_projeto IS 'Nome do projeto. Deve ser unico.';
COMMENT ON COLUMN elmasri.projeto.local_projeto IS 'Localizacao do projeto.';
COMMENT ON COLUMN elmasri.projeto.numero_departamento IS 'Numero do departamento. Uma FK para a tabela departamento.';

-- Criando uma Chave Alternada na tabela projeto

CREATE UNIQUE INDEX projeto_idx
 ON elmasri.projeto
 ( nome_projeto );

-- Criando tabela localizacoes_departamento

CREATE TABLE elmasri.localizacoes_departamento (
                numero_departamento INTEGER NOT NULL,
                local VARCHAR(15) NOT NULL,
                CONSTRAINT pk_localizacoes_departamento PRIMARY KEY (numero_departamento, local)
);

-- Adicionando comentários

COMMENT ON COLUMN elmasri.localizacoes_departamento.numero_departamento IS 'Numero departamento. PK e FK da tabela departamento.';
COMMENT ON COLUMN elmasri.localizacoes_departamento.local IS 'Localizacao do departamento. Faz parte da PK desta tabela.';

-- Criando tabela dependente

CREATE TABLE elmasri.dependente (
                cpf_funcionario CHAR(11) NOT NULL,
                nome_dependente VARCHAR(15) NOT NULL,
                sexo CHAR(1),
                data_nascimento DATE,
                parentesco VARCHAR(15),
                CONSTRAINT pk_dependente PRIMARY KEY (cpf_funcionario, nome_dependente)
);

-- Adicionando comentários

COMMENT ON COLUMN elmasri.dependente.cpf_funcionario IS 'CPF do funcionario. PK da tabela FK da tabela funcionario.';
COMMENT ON COLUMN elmasri.dependente.nome_dependente IS 'Nome do dependente. Faz parte da PK desta tabela.';
COMMENT ON COLUMN elmasri.dependente.sexo IS 'Sexo do dependente.';
COMMENT ON COLUMN elmasri.dependente.data_nascimento IS 'Data de nascimento do dependente.';
COMMENT ON COLUMN elmasri.dependente.parentesco IS 'Descricao do parentesco do dependente com o funcionario.';

-- Criando tabela trabalha_em 

CREATE TABLE elmasri.trabalha_em (
                cpf_funcionario CHAR(11) NOT NULL,
                numero_projeto INTEGER NOT NULL,
                horas NUMERIC(3,1),
                CONSTRAINT pk_trabalha_em PRIMARY KEY (cpf_funcionario, numero_projeto)
);

-- Adicionando comentários

COMMENT ON COLUMN elmasri.trabalha_em.cpf_funcionario IS 'CPF do funcionario. PK da tabela e FK da tabela funcionario.';
COMMENT ON COLUMN elmasri.trabalha_em.numero_projeto IS 'Numero do projeto. PK da tabela e FK da tabela projeto.';
COMMENT ON COLUMN elmasri.trabalha_em.horas IS 'Horas trabalhadas pelo funcionario neste projeto.';

-- Adicionando Constraints

alter table elmasri.funcionario add constraint genero check (sexo='M' OR sexo='F'); -- Genero apenas M ou F

alter table elmasri.funcionario add constraint salario check (salario > -1); -- Impossibilita valores negativos


alter table elmasri.funcionario add constraint numero_depart check (numero_departamento > 0); -- Impede numeros menores que zero

alter table elmasri.funcionario add constraint data check (data_nascimento between '1930-01-01' and '2004-12-30'); -- Impede datas que extrapolem esses limites


alter table elmasri.departamento add constraint numero_depart2 check (numero_departamento > 0); -- Impede numeros menores que zero 

alter table elmasri.departamento add constraint data_gerente check (data_inicio_gerente between '1980-01-01' and '2022-04-22' ); -- Impede datas que extrapolem esses limites


alter table elmasri.projeto add constraint numero_proj check (numero_projeto > 0); -- Impede valores menores que zero


alter table elmasri.trabalha_em add constraint hora_proj check ( horas > -1); -- Impede valores negativos


alter table elmasri.dependente add constraint genero_dependente check (sexo='M' or sexo='F'); -- Genero apenas M ou F

alter table elmasri.dependente add constraint data_dependente check (data_nascimento between '1930-01-01' and'2022-01-01'); -- Impede datas que extrapolem esses limites


-- Adicionando as Chaves Estrangeiras das tabelas

ALTER TABLE elmasri.trabalha_em ADD CONSTRAINT funcionario_trabalha_em_fk
FOREIGN KEY (cpf_funcionario)
REFERENCES elmasri.funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE elmasri.dependente ADD CONSTRAINT funcionario_dependente_fk
FOREIGN KEY (cpf_funcionario)
REFERENCES elmasri.funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE elmasri.departamento ADD CONSTRAINT funcionario_departamento_fk
FOREIGN KEY (cpf_gerente)
REFERENCES elmasri.funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE elmasri.funcionario ADD CONSTRAINT funcionario_funcionario_fk
FOREIGN KEY (cpf_supervisor)
REFERENCES elmasri.funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE elmasri.localizacoes_departamento ADD CONSTRAINT departamento_localizacoes_departamento_fk
FOREIGN KEY (numero_departamento)
REFERENCES elmasri.departamento (numero_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE elmasri.projeto ADD CONSTRAINT departamento_projeto_fk
FOREIGN KEY (numero_departamento)
REFERENCES elmasri.departamento (numero_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE elmasri.trabalha_em ADD CONSTRAINT projeto_trabalha_em_fk
FOREIGN KEY (numero_projeto)
REFERENCES elmasri.projeto (numero_projeto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;



-- Inserindo valores na tabela funcionarios

insert into elmasri.funcionario values (
	'88866555576', 'Jorge', 'E', 'Brito', '1937-11-10', 'Rua do Horto, 35, Sao Paulo, SP',
	'M', 55000, null, 1
);

insert into elmasri.funcionario values (
	'98765432168', 'Jennifer', 'S', 'Souza', '1941-06-20', 'Av Arthur de Lima, 54, Santo Andre, SP',
	 'F', 43000, '88866555576', 4
);

insert into elmasri.funcionario values (
	'33344555587', 'Fernando', 'T', 'Wong', '1955-12-08', 'Rua da Lapa, 34, Sao Paulo, SP',
	 'M', 40000, '88866555576', 5
);

insert into elmasri.funcionario values (
	'99988777767', 'Alice', 'J', 'Zelaya', '1968-01-19', 'Rua Souza Lima, 35, Curitiba, PR',
 	'F', 25000, '98765432168', 4
);

insert into elmasri.funcionario values (
     '12345678966', 'João', 'B', 'Silva', '1965-01-09', 'Rua das Flores, 751, São Paulo, SP',
     'M', '30000.00', '33344555587', '5'
); 

insert into elmasri.funcionario values (
     '66688444476', 'Ronaldo', 'K', 'Lima', '1962-09-15', 'Rua Rebouças, 65, Piracicaba, SP',
     'M', '38000.00', '33344555587', '5'
);

insert into elmasri.funcionario values (
     '45345345376', 'Joice', 'A', 'Leite', '1972-07-31', 'Av. Lucas Obes, 74, São Paulo, SP',
     'F', '25000.00', '33344555587', '5'
);

insert into elmasri.funcionario values (
     '98798798733', 'André', 'V', 'Pereira', '1969-03-29', 'Rua Timbira, 35, São Paulo, SP',
     'M', '25000.00', '98765432168', '4'
);

-- Inserindo valores na tabela departamento

insert into elmasri.departamento values (
     5, 'Pesquisa', '33344555587', '1988-05-22'
);

insert into elmasri.departamento values (
     4, 'Administração', '98765432168', '1995-01-01'
);

insert into elmasri.departamento values (
     1, 'Matriz', '88866555576', '1981-06-19'
);

-- Inserindo valores na tabela localizacoes_departamento;


insert into elmasri.localizacoes_departamento values (
     1, 'São Paulo'
);

insert into elmasri.localizacoes_departamento values (
     4, 'Mauá'
);

insert into elmasri.localizacoes_departamento values (
     5, 'Santo André'
);

insert into elmasri.localizacoes_departamento values (
     5, 'Itu'
);

insert into elmasri.localizacoes_departamento values (
     5, 'São Paulo'
);

-- Inserindo valores na tabela projeto

insert into elmasri.projeto values (
     1, 'ProdutoX', 'Santo André', 5
);

insert into elmasri.projeto values (
     2, 'ProdutoY', 'Itu', 5
);

insert into elmasri.projeto values (
     3, 'ProdutoZ', 'São Paulo', 5
);

insert into elmasri.projeto values (
     10, 'Informatização', 'Mauá', 4
);

insert into elmasri.projeto values (
     20, 'Reorganização', 'São Paulo', 1
);

insert into elmasri.projeto values (
     30, 'NovosBenefícios', 'Mauá', 4
);

-- Inserindo valores na tabela dependente


insert into elmasri.dependente values (
     '33344555587', 'Alicia', 'F', '1986-04-05', 'Filha'
);

insert into elmasri.dependente values (
     '33344555587', 'Tiago', 'M', '1983-10-25', 'Filho'
);

insert into elmasri.dependente values (
     '33344555587', 'Janaina', 'F', '1958-05-03', 'Esposa'
);

insert into elmasri.dependente values (
     '98765432168', 'Antonio', 'M', '1942-02-28', 'Marido'
);

insert into elmasri.dependente values (
     '12345678966', 'Michael', 'M', '1988-01-04', 'Filho'
);

insert into elmasri.dependente values (
     '12345678966', 'Alicia', 'F', '1988-12-30', 'Filha'
);

insert into elmasri.dependente values (
     '12345678966', 'Elizabeth', 'F', '1967-05-05', 'Esposo'
);

-- Inserindo valores na tabela trabalha_em

insert into elmasri.trabalha_em values (
     '12345678966', 1, '32.5'
);

insert into elmasri.trabalha_em values (
     '12345678966', 2, '7.5'
);

insert into elmasri.trabalha_em values (
     '66688444476', 3, '40.0'
);

insert into elmasri.trabalha_em values (
     '45345345376', 1, '20.0'
);

insert into elmasri.trabalha_em values (
     '45345345376', 2, '20.0'
);

insert into elmasri.trabalha_em values (
     '33344555587', 2, '10.0'
);

insert into elmasri.trabalha_em values (
     '33344555587', 3, '10.0'
);

insert into elmasri.trabalha_em values (
     '33344555587', 10, '10.0'
);

insert into elmasri.trabalha_em values (
     '33344555587', 20, '10.0'
);

insert into elmasri.trabalha_em values (
     '99988777767', 30, '30.0'
);

insert into elmasri.trabalha_em values (
     '99988777767', 10, '10.0'
);

insert into elmasri.trabalha_em values (
     '98798798733', 10, '35.0'
);

insert into elmasri.trabalha_em values (
     '98798798733', 30, '5.0'
);

insert into elmasri.trabalha_em values (
     '98765432168', 30, '20.0'
);

insert into elmasri.trabalha_em values (
     '98765432168', 20, '15.0'
);

insert into elmasri.trabalha_em values (
     '88866555576', 20, null
);

