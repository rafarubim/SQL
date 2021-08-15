 create or replace function aprovacao(g1 in number,
                                      g2 in number,
                                      pf in number default null)
  return number as x number;
begin
  if pf is null then
    if (g1+g2)/2 < 3 then
      return 0;
    end if;
    if g1 < 3 or g2 < 3 then
      return 1;
    end if;
    if g1 >= 6 and g2 >= 6 then
      return 2;
    end if;
    return 1;
  else
    if (pf*2+g1+g2)/4 >= 5 then
      return 2;
    else
      return 0;
    end if;
  end if;
end;
/

alter table empregado
  add qtd_dependentes number(2);

update empregado e
  set qtd_dependentes = (select count(*)
                          from dependente d
                          where d.identemp = e.ident);

insert into empregado(ident,nome,salario,cpf,end,sexo,datanasc,depnum,superident,qtd_dependentes)
  values(111,'Rafinha da quebrada', 1000000,6789998212,'Baker street','m',to_date('17/09/1997','dd/mm/yyyy'),NULL,NULL,NULL);

insert into dependente(identemp,nome,sexo,datanasc,parentesco)
  values(111,'Nalu Gorda','f',to_date('20/04/2000','dd/mm/yyyy'),'Animal de estimação');

insert into dependente(identemp,nome,sexo,datanasc,parentesco)
  values(111,'Pedrin Obeso','m',to_date('04/12/2002','dd/mm/yyyy'),'Animal de estimação');

create or replace procedure criar_dependente (pIdentEmp number, pNome varchar2,
                                              pSexo char, pDataNasc date, pParentesco varchar2)
as
begin
  insert into dependente(identemp,nome,sexo,datanasc,parentesco)
    values(pIdentEmp,pNome,pSexo,pDataNasc,pParentesco);
  
  update empregado e
    set qtd_dependentes = (select count(*)
                            from dependente d
                            where d.identemp = e.ident);
end;
/

begin
   criar_dependente(111,'Pedrin Obeso','m',to_date('04/12/2002','dd/mm/yyyy'),'Animal de estimação');
end;
/

create or replace procedure remover_dependente(pIdentEmp number, pNome varchar2)
as
begin
  delete from dependente
  where identemp = pIdentEmp
        and nome = pNome;
        
  update empregado e
    set qtd_dependentes = (select count(*)
                            from dependente d
                            where d.identemp = e.ident);
end;
/

begin
  remover_dependente(111,'Pedrin Obeso');
end;
/

select *
from dependente;

select *
from empregado;

create or replace trigger