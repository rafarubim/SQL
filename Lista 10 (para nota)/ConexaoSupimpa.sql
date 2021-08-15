/* Eliminar todas as tabelas: (propósito de debug) */
drop table empregado cascade constraints;
drop table departamento cascade constraints;
drop table projeto cascade constraints;
drop table trabalhano cascade constraints;
drop table dependente cascade constraints;
/* Fim de eliminação de tabelas */

/* 1) */
create table empregado (
  ident       number(9)     not null,
  nome        varchar2(60)  not null,
  salario     number(10,2)  not null,
  cpf         number(11)    not null,
  end         varchar2(120) not null,
  sexo        char(1)       not null,
  datanasc    date          not null,
  depnum      number(2)     null,
  superident  number(9)     null,
  
  constraint  emp_pk          primary key(ident),
  constraint  emp_check_sal   check(salario >= 0),
  constraint  emp_unique_cpf  unique(cpf),
  constraint  emp_check_sexo  check(upper(sexo) in ('M', 'F')),
  /*constraint  emp_fk_depnum   foreign key(depnum)
                                references departamento.num
                                on delete set null,*/ /* Criar constraint após criação de tabela 'departamento' */
  constraint  emp_fk_superident foreign key(superident)
                                  references empregado(ident)
                                  on delete set null
  
);

create table departamento (
  num       number(2)     not null,
  nome      varchar2(60)  not null,
  identger  number(9)     null,
  dataini   date          not null,
  
  constraint  dep_pk            primary key(num),
  constraint  dep_check_num     check(num <= 50 and num > 0),
  constraint  dep_fk_identger   foreign key(identger)
                                  references  empregado(ident),
  constraint  dep_check_dataini check(dataini >= to_date('01/01/2000','dd/mm/yyyy'))
);

alter table empregado /* Criar constraint após criação de tabela 'departamento' */
  add constraint  emp_fk_depnum foreign key(depnum)
                                references departamento(num)
                                on delete set null;

create table projeto (
  num     number(4)     not null,
  nome    varchar(200)  not null,
  local   varchar(500)  null,
  depnum  number(2)     null,
  
  constraint  proj_pk         primary key(num),
  constraint  proj_check_num  check(num <= 1000 and num > 0),
  constraint  proj_fk_depnum  foreign key(depnum)
                                references  departamento(num)
                                on delete set null
);

create table trabalhano (
  identemp  number(9)     not null,
  projnum   number(4)     not null,
  hrs       number(2)     not null,
  
  constraint  trab_pk           primary key(identemp, projnum),
  constraint  trab_fk_identemp  foreign key(identemp)
                                  references empregado(ident)
                                  on delete cascade,
  constraint  trab_fk_projnum   foreign key(projnum)
                                  references projeto(num)
  );

create table dependente (
  identemp    number(9)     not null,
  nome        varchar2(60)  not null,
  sexo        char(1)       not null,
  datanasc    date          not null,
  parentesco  varchar2(50)  null,
  
  constraint  depend_pk           primary key(identemp, nome),
  constraint  depend_fk_identemp  foreign key(identemp)
                                    references empregado(ident)
                                    on delete cascade
);


/* 2) */
/* ************************************************************************* TESTES ******************************************************************************************* */
/* SUCESSO -> Código funciona/ FALHA -> Código nâo roda por alguma restrição /// Independente de sucesso ou falha, todos os códigos têm resultado esperado */

/* **************************** TESTES EMPREGADO ********************************** */
/* Teste normal empregado */
insert into empregado(ident,nome,salario,cpf,end,sexo,datanasc,depnum,superident)
  values(12345,'Rafael Rubim',99999999.99,12345,'Avenida a','M',to_date('17/09/1997','dd/mm/yyyy'),null, null);
  /* SUCESSO */
delete from empregado
  where ident = 12345;
  /* SUCESSO */

/* Teste pk/unique_cpf empregado */
insert into empregado(ident,nome,salario,cpf,end,sexo,datanasc,depnum,superident)
  values(12345,'Rafael Rubim',99999999.99,12345,'Avenida a','M',to_date('17/09/1997','dd/mm/yyyy'),null, null);
  /* SUCESSO */
insert into empregado(ident,nome,salario,cpf,end,sexo,datanasc,depnum,superident)
  values(12345,'Joana Fomm',99999999.99,12346,'Avenida a','F',to_date('17/09/1997','dd/mm/yyyy'),null, null);
  /* FALHA */
insert into empregado(ident,nome,salario,cpf,end,sexo,datanasc,depnum,superident)
  values(12346,'Joana Fomm',99999999.99,12345,'Avenida a','F',to_date('17/09/1997','dd/mm/yyyy'),null, null);
  /* FALHA */
insert into empregado(ident,nome,salario,cpf,end,sexo,datanasc,depnum,superident)
  values(12346,'Joana Fomm',99999999.99,12346,'Avenida a','F',to_date('17/09/1997','dd/mm/yyyy'),null, null);
  /* SUCESSO */
delete from empregado
  where ident = 12345
        or ident = 12346;
  /* SUCESSO */

/* Teste salario empregado */
insert into empregado(ident,nome,salario,cpf,end,sexo,datanasc,depnum,superident)
  values(12345,'Rafael Rubim',-99999999.99,12345,'Avenida a','M',to_date('17/09/1997','dd/mm/yyyy'),null, null);
  /* FALHA */

/* Teste sexo empregado */
insert into empregado(ident,nome,salario,cpf,end,sexo,datanasc,depnum,superident)
  values(12345,'Rafael Rubim',99999999.99,12345,'Avenida a','oi',to_date('17/09/1997','dd/mm/yyyy'),null, null);
  /* FALHA */
insert into empregado(ident,nome,salario,cpf,end,sexo,datanasc,depnum,superident)
  values(12345,'Rafael Rubim',99999999.99,12345,'Avenida a','d',to_date('17/09/1997','dd/mm/yyyy'),null, null);
  /* FALHA */
  
  
/* **************************** TESTES DEPARTAMENTO ********************************** */
/* Teste normal departamento */
insert into departamento(num,nome,identger,dataini)
  values(50,'Departamento mais incrível',null,to_date('10/10/2010','dd/mm/yyyy'));
  /* SUCESSO */
delete from departamento
  where num = 50;
  /* SUCESSO */

/* Teste pk departamento */
insert into departamento(num,nome,identger,dataini)
  values(10,'Departamento mais incrível',null,to_date('10/10/2010','dd/mm/yyyy'));
  /* SUCESSO */
insert into departamento(num,nome,identger,dataini)
  values(10,'Departamento mais chato',null,to_date('07/07/2007','dd/mm/yyyy'));
  /* FALHA */
insert into departamento(num,nome,identger,dataini)
  values(11,'Departamento mais chato',null,to_date('07/07/2007','dd/mm/yyyy'));
  /* SUCESSO */
delete from departamento
  where num = 10
        or num = 11;
  /* SUCESSO */
  
/* Teste check_num departamento */
insert into departamento(num,nome,identger,dataini)
  values(51,'Departamento mais incrível',null,to_date('10/10/2010','dd/mm/yyyy'));
  /* FALHA */
insert into departamento(num,nome,identger,dataini)
  values(-1,'Departamento mais incrível',null,to_date('10/10/2010','dd/mm/yyyy'));
  /* FALHA */
  
/* Teste check_dataini departamento */
insert into departamento(num,nome,identger,dataini)
  values(50,'Departamento mais incrível',null,to_date('10/10/1999','dd/mm/yyyy'));
  /* FALHA */
  
/* **************************** TESTES PROJETO ********************************** */
/* Teste normal projeto */
insert into projeto(num, nome, local, depnum)
  values(1000,'Estouramento de bolhas de sabão','Casa da mãe Joana',null);
  /* SUCESSO */
delete from projeto
  where num = 1000;
  /* SUCESSO */

/* Teste pk projeto */
insert into projeto(num, nome, local, depnum)
  values(1000,'Estouramento de bolhas de sabão','Casa da mãe Joana',null);
  /* SUCESSO */
insert into projeto(num, nome, local, depnum)
  values(1000,'Banho em unicórnios','Onde Judas perdeu as botas',null);
  /* FALHA */
insert into projeto(num, nome, local, depnum)
  values(999,'Banho em unicórnios','Onde Judas perdeu as botas',null);
  /* SUCESSO */
delete from projeto
  where num = 1000
        or num = 999;
  /* SUCESSO */
  
/* Teste check_num projeto */
insert into projeto(num, nome, local, depnum)
  values(1001,'Estouramento de bolhas de sabão','Casa da mãe Joana',null);
  /* FALHA */
insert into projeto(num, nome, local, depnum)
  values(-1,'Estouramento de bolhas de sabão','Casa da mãe Joana',null);
  /* FALHA */
  
/* **************************** TESTES FK/TRABALHANO/PROJETO ********************************** */
/* Teste empregado: fk_depnum */
insert into departamento(num,nome,identger,dataini)
  values(50,'Departamento mais incrível',null,to_date('10/10/2010','dd/mm/yyyy'));
  /* SUCESSO */
insert into empregado(ident,nome,salario,cpf,end,sexo,datanasc,depnum,superident)
  values(12345,'Rafael Rubim',99999999.99,12345,'Avenida a','M',to_date('17/09/1997','dd/mm/yyyy'),13, null);
  /* FALHA */
insert into empregado(ident,nome,salario,cpf,end,sexo,datanasc,depnum,superident)
  values(12345,'Rafael Rubim',99999999.99,12345,'Avenida a','M',to_date('17/09/1997','dd/mm/yyyy'),50, null);
  /* SUCESSO */
delete from departamento
  where num = 50;
  /* SUCESSO */
select depnum
  from empregado
  where ident = 12345;
  /* SUCESSO */ /* (NULL) */
delete from empregado
  where ident = 12345;
  /* SUCESSO */
  
/* Teste empregado: fk_superident */
insert into empregado(ident,nome,salario,cpf,end,sexo,datanasc,depnum,superident)
  values(12345,'Rafael Rubim',99999999.99,12345,'Avenida a','M',to_date('17/09/1997','dd/mm/yyyy'),null, null);
  /* SUCESSO */
insert into empregado(ident,nome,salario,cpf,end,sexo,datanasc,depnum,superident)
  values(12346,'Joana Fomm',99999999.99,12346,'Avenida a','F',to_date('17/09/1997','dd/mm/yyyy'),null, 12347);
  /* FALHA */
insert into empregado(ident,nome,salario,cpf,end,sexo,datanasc,depnum,superident)
  values(12346,'Joana Fomm',99999999.99,12346,'Avenida a','F',to_date('17/09/1997','dd/mm/yyyy'),null, 12345);
  /* SUCESSO */
delete from empregado
  where ident = 12345;
  /* SUCESSO */
select superident
  from empregado
  where ident = 12346;
  /* SUCESSO */ /* (NULL) */
delete from empregado
  where ident = 12346;
  /* SUCESSO */
  
/* Teste departamento: fk_identger */
insert into empregado(ident,nome,salario,cpf,end,sexo,datanasc,depnum,superident)
  values(12345,'Rafael Rubim',99999999.99,12345,'Avenida a','M',to_date('17/09/1997','dd/mm/yyyy'),null, null);
  /* SUCESSO */
insert into departamento(num,nome,identger,dataini)
  values(50,'Departamento mais incrível',12346,to_date('10/10/2010','dd/mm/yyyy'));
  /* FALHA */
insert into departamento(num,nome,identger,dataini)
  values(50,'Departamento mais incrível',12345,to_date('10/10/2010','dd/mm/yyyy'));
  /* SUCESSO */
delete from empregado
  where ident = 12345;
  /* FALHA */
delete from departamento
  where num = 50;
  /* SUCESSO */
delete from empregado
  where ident = 12345;
  /* SUCESSO */
  
/* Teste projeto: fk_depnum */
insert into departamento(num,nome,identger,dataini)
  values(50,'Departamento mais incrível',null,to_date('10/10/2010','dd/mm/yyyy'));
  /* SUCESSO */
insert into projeto(num, nome, local, depnum)
  values(1000,'Estouramento de bolhas de sabão','Casa da mãe Joana',49);
  /* FALHA */
insert into projeto(num, nome, local, depnum)
  values(1000,'Estouramento de bolhas de sabão','Casa da mãe Joana',50);
  /* SUCESSO */
delete from departamento
  where num = 50;
  /* SUCESSO */
select depnum
  from projeto
  where num = 1000;
  /* SUCESSO */ /* (NULL) */
delete from projeto
  where num = 1000;
  /* SUCESSO */
  
/* Teste trabalhano */
insert into empregado(ident,nome,salario,cpf,end,sexo,datanasc,depnum,superident)
  values(12345,'Rafael Rubim',99999999.99,12345,'Avenida a','M',to_date('17/09/1997','dd/mm/yyyy'),null, null);
  /* SUCESSO */
insert into projeto(num, nome, local, depnum)
  values(1000,'Estouramento de bolhas de sabão','Casa da mãe Joana',null);
  /* SUCESSO */
insert into trabalhano(identemp,projnum,hrs)
  values(12344,1000,30);
  /* FALHA */
insert into trabalhano(identemp,projnum,hrs)
  values(12345,999,30);
  /* FALHA */
insert into trabalhano(identemp,projnum,hrs)
  values(12345,1000,30);
  /* SUCESSO */
insert into trabalhano(identemp,projnum,hrs)
  values(12345,1000,32);
  /* FALHA */
delete from empregado
  where ident = 12345;
  /* SUCESSO */
select identemp
  from trabalhano
  where identemp = 12345
        and projnum = 1000;
  /* SUCESSO */ /* NENHUMA LINHA */
insert into empregado(ident,nome,salario,cpf,end,sexo,datanasc,depnum,superident)
  values(12345,'Rafael Rubim',99999999.99,12345,'Avenida a','M',to_date('17/09/1997','dd/mm/yyyy'),null, null);
  /* SUCESSO */
insert into trabalhano(identemp,projnum,hrs)
  values(12345,1000,30);
  /* SUCESSO */
delete from projeto
  where num = 1000;
  /* FALHA */
delete from trabalhano
  where identemp = 12345
        and projnum = 1000;
  /* SUCESSO */
delete from empregado
  where ident = 12345;
  /* SUCESSO */
delete from projeto
  where num = 1000;
  /* SUCESSO */
  
/* Teste dependente */
insert into empregado(ident,nome,salario,cpf,end,sexo,datanasc,depnum,superident)
  values(12345,'Rafael Rubim',99999999.99,12345,'Avenida a','M',to_date('17/09/1997','dd/mm/yyyy'),null, null);
  /* SUCESSO */
insert into dependente(identemp,nome,sexo,datanasc,parentesco)
  values(12344,'Merlin','m',to_date('01/01/2016','dd/mm/yyyy'),'Meu lindo cachorro S2');
  /* FALHA */
insert into dependente(identemp,nome,sexo,datanasc,parentesco)
  values(12345,'Merlin','m',to_date('01/01/2016','dd/mm/yyyy'),'Meu lindo cachorro S2');
  /* SUCESSO */
insert into dependente(identemp,nome,sexo,datanasc,parentesco)
  values(12345,'Nalu gorda','f',to_date('20/04/2000','dd/mm/yyyy'),'Maninha');
  /* SUCESSO */
insert into dependente(identemp,nome,sexo,datanasc,parentesco)
  values(12345,'Nalu gorda','f',to_date('20/04/2000','dd/mm/yyyy'),'Maninha gorda');
  /* FALHA */
delete from empregado
  where ident = 12345;
  /* SUCESSO */
select identemp
  from dependente
  where identemp = 12345;
  /* SUCESSO */ /* NENHUMA LINHA */
  
/* 3) */
/* ********************************************************** CRIAÇÃO DE VIEWS ************************************************************************** */

/* 3) a) */
create or replace view vw_empregados_projetos(nome, projeto, horas_semanais)
  as
  select emp.nome, proj.nome, trab.hrs
  from empregado emp
    inner join trabalhano trab
    on emp.ident = trab.identemp
      inner join projeto proj
      on trab.projnum = proj.num
  where proj.depnum is not null
with check option;


/* Teste visão */
insert into empregado(ident,nome,salario,cpf,end,sexo,datanasc,depnum,superident)
  values(12345,'Rafael Rubim',99999999.99,12345,'Avenida a','M',to_date('17/09/1997','dd/mm/yyyy'),null, null);
  /* SUCESSO */
insert into projeto(num, nome, local, depnum)
  values(1000,'Estouramento de bolhas de sabão','Casa da mãe Joana',null);
  /* SUCESSO */
insert into trabalhano(identemp,projnum,hrs)
  values(12345,1000,30);
  /* SUCESSO */
insert into empregado(ident,nome,salario,cpf,end,sexo,datanasc,depnum,superident)
  values(12346,'Joana Fomm',99999999.99,12346,'Avenida a','F',to_date('17/09/1997','dd/mm/yyyy'),null, null);
  /* SUCESSO */
insert into departamento(num,nome,identger,dataini)
  values(50,'Departamento mais incrível',null,to_date('10/10/2010','dd/mm/yyyy'));
  /* SUCESSO */
insert into projeto(num, nome, local, depnum)
  values(999,'Banho em unicórnios','Onde Judas perdeu as botas',50);
  /* SUCESSO */
insert into trabalhano(identemp,projnum,hrs)
  values(12346,999,35);
  /* SUCESSO */
select *
  from vw_empregados_projetos;
  /* SUCESSO */
delete from empregado
  where ident = 12345
        or ident = 12346;
  /* SUCESSO */
delete from departamento
  where num = 50;
  /* SUCESSO */
delete from projeto
  where num = 999
        or num = 1000;
  /* SUCESSO */

/* 3) b) */
create or replace view vw_empregados(identificador,nome,cpf,endereço,sexo,data_nascimento)
  as
  select ident, nome, cpf, end, sexo, datanasc
  from empregado
with check option;

/* Teste visão */
insert into empregado(ident,nome,salario,cpf,end,sexo,datanasc,depnum,superident)
  values(12345,'Rafael Rubim',99999999.99,12345,'Avenida a','M',to_date('17/09/1997','dd/mm/yyyy'),null, null);
  /* SUCESSO */
select *
  from vw_empregados;
  /* SUCESSO */
delete from empregado
  where ident = 12345;
  /* SUCESSO */
  
/* 3) b) i) */
insert into vw_empregados(identificador,nome,cpf,endereço,sexo,data_nascimento)
  values(12345,'Rafael Rubim',12345,'Avenida a','M',to_date('17/09/1997','dd/mm/yyyy'));
  /* FALHA */ /* Inserção não funciona! Salario é not null e não está presente na visão */

/* b) ii) */
alter table empregado
  modify(salario default 0);
  
insert into vw_empregados(identificador,nome,cpf,endereço,sexo,data_nascimento)
  values(12345,'Rafael Rubim',12345,'Avenida a','M',to_date('17/09/1997','dd/mm/yyyy'));
  /* SUCESSO */
  
select *
  from vw_empregados;
select *
  from empregado;
  /* SUCESSO */ /* Inserção funciona! */
delete from vw_empregados
  where identificador = 12345;
select *
  from vw_empregados;
select *
  from empregado;
  /* SUCESSO */ /* Delete funciona! */
  
/* 3) c) */
create or replace view vw_projetos_sudeste(numero,nome,local)
  as
  select num, nome, local
  from projeto
  where upper(local) in ('RIO DE JANEIRO', 'SÃO PAULO', 'MINAS GERAIS', 'ESPÍRITO SANTO');

/* Teste visão */
insert into projeto(num, nome, local, depnum)
  values(777,'Aula de origami com o meu papel de trouxa','Paraná',null);
  /* SUCESSO */
insert into projeto(num, nome, local, depnum)
  values(333,'Entrar no 4shared pra baixar a bola','Rio de Janeiro',null);
  /* SUCESSO */
select *
  from vw_projetos_sudeste;
  /* SUCESSO */
delete from projeto
  where num = 777
        or num = 333;
  /* SUCESSO */
  
/* 3) c) i) */
insert into vw_projetos_sudeste(numero, nome, local)
  values(13,'Excursão para catar coquinhos','Paraná');
  /* SUCESSO */
select *
  from vw_projetos_sudeste;
  /* View não mostra linha inserida! */
select *
  from projeto;
  /* Linha aparece na tabela projeto! */
delete from vw_projetos_sudeste
  where numero = 13;
  /* A linha não é deletada pois não existe na view! */
delete from projeto
  where num = 13;
  /* SUCESSO */
select *
  from projeto;
  /* SUCESSO */
  
/* 3) c) ii) */
create or replace view vw_projetos_sudeste(numero,nome,local)
  as
  select num, nome, local
  from projeto
  where upper(local) in ('RIO DE JANEIRO', 'SÃO PAULO', 'MINAS GERAIS', 'ESPÍRITO SANTO')
with check option;

insert into vw_projetos_sudeste(numero, nome, local)
  values(13,'Distribuição de vergonha na cara','Paraná');
  /* FALHA */
insert into vw_projetos_sudeste(numero, nome, local)
  values(13,'Levantamento de forninho','São Paulo');
  /* SUCESSO */
select *
  from vw_projetos_sudeste;
  /* SUCESSO */
delete from vw_projetos_sudeste
  where numero = 13;
  /* SUCESSO */
select *
  from vw_projetos_sudeste;
  /* SUCESSO */