-------------------------------------------------------------------------- DECLARA��ES ----------------------------------------------------------------------------------------
----------------
-- DROP TABLE --
----------------


drop table inscrito cascade constraints;
drop table prova cascade constraints;
drop table serie cascade constraints;
drop table modalidade cascade constraints;
DROP TABLE COMPETIDOR cascade constraints;
DROP TABLE PARTICIPA cascade constraints;
DROP TABLE PATROCINADO cascade constraints;
DROP TABLE DATAETAPA cascade constraints; 
drop table RaiasAAlocar cascade constraints;
------------------
-- CREATE TABLE --
------------------

drop table Globais cascade constraints;
create table Globais (
  Nome  varchar2(30)  primary key,
  Valor number        null
);


drop table RaiasAAlocar cascade constraints;
create table RaiasAAlocar (
	Ident		number(2)	primary key,
	SeqSerie	number(1)	not null,
	NumRaia		number(1)	not null
);


drop table modalidade cascade constraints;
create table modalidade
(
  num number not null,
  nome varchar2(20) not null,
  
  constraint ModPK primary key (num)
);



drop table prova cascade constraints;
create table prova
(
  numMod number not null,
  sexo char not null,
  dist number not null,
  
  constraint ProvaPK primary key (numMod, dist, sexo),
  constraint ProvaDistPositiva check (dist > 0),
  constraint ProvaSexo check (sexo in ('M', 'F'))
);

drop table serie cascade constraints;
create table serie
(
  numMod number not null,
  sexoProva char not null,
  distProva number not null,
  etapa number not null,
  seq number not null,
  status number not null,
  
  constraint SeriePK primary key (distProva, etapa, numMod, seq, sexoProva),
  constraint SerieEtapaPositiva check (etapa in (1, 2, 3)),
  constraint SerieSeq check (seq >= 1 and seq <= 8),
  constraint SerieSexoProva check (sexoProva in ('M', 'F')),
  constraint SerieStatus check (status in (0, 1))
);

drop table inscrito cascade constraints;
create table inscrito
(
  NUMINSCR number(5) not null,
  numMod number not null,
  sexoProva char not null,
  distProva number not null,
  melhorTempo number(5,2) not null,
  nomeTorneio varchar2(200) not null,
  localTorneio varchar2(200) not null,
  dataTorneio date not null,
  aprovado char not null,
  
  constraint InscritoPK primary key (NUMINSCR, numMod, distProva, sexoProva),
  constraint InscritoNUMINSCR CHECK(NUMINSCR>0),
  constraint InscritoSexoProva check (sexoProva in ('M', 'F')),
  constraint InscritoAprovado check (aprovado in ('S', 'N')),
  constraint InscritoMelhorTempo check (melhorTempo > 0)
);

DROP TABLE COMPETIDOR cascade constraints;
create table competidor
(
   NUMINSCR NUMBER(5) NOT NULL,
   NOME VARCHAR2(100) NOT NULL,
   SEXO CHAR NOT NULL,
   ANONASC NUMBER(4) NOT NULL,
  
  CONSTRAINT COMPETIDOR_NUMINSCRPK PRIMARY KEY(NUMINSCR),
  CONSTRAINT COMPETIDOR_SEXOCK CHECK(SEXO IN('M','F')),
  CONSTRAINT COMPETIDOR_NUMINSCRCK CHECK(NUMINSCR>0)
);

DROP TABLE PARTICIPA cascade constraints;
create table PARTICIPA
(
   NUMINSCR NUMBER(5) NOT NULL,
   NUMMOD NUMBER NOT NULL,
   SEXOPROVA CHAR NOT NULL,
   DISTPROVA NUMBER NOT NULL,
   ETAPASERIE NUMBER NOT NULL,
   SEQSERIE NUMBER NOT NULL,
   TEMPO NUMBER(5,2),
   SITUACAO NUMBER,
   RAIA NUMBER NOT NULL,
   
  CONSTRAINT PARTICIPAPK PRIMARY KEY(NUMINSCR,NUMMOD,SEXOPROVA,DISTPROVA,ETAPASERIE,SEQSERIE),
  CONSTRAINT PARTICIPA_NUMINSCRCK CHECK(NUMINSCR>0),
  CONSTRAINT PARTICIPA_SEXOPROVACK CHECK(SEXOPROVA IN('M','F')),
  CONSTRAINT PARTICIPA_DISTPROVACK CHECK(DISTPROVA>0),
  CONSTRAINT PARTICIPA_ETAPASERIECK CHECK(ETAPASERIE IN (1,2,3)),
  CONSTRAINT PARTICIPA_SEQSERIECK CHECK(SEQSERIE>= 1 AND SEQSERIE <= 8),
  CONSTRAINT PARTICIPA_RAIACK CHECK(RAIA>= 1 AND RAIA<= 8),
  CONSTRAINT PARTICIPA_SITUCAOCK CHECK(SITUACAO IN(NULL,1,2,3))
);

DROP TABLE PATROCINADO cascade constraints;
create table PATROCINADO
(
  NUMINSCR number(5) not null,
  PATROCINADOR VARCHAR2(100) not null,
  
  CONSTRAINT PATROCINADO_NUMINSCRCK CHECK(NUMINSCR>0),
  CONSTRAINT PATROCINADOPK PRIMARY KEY (NUMINSCR,PATROCINADOR)
);

DROP TABLE DATAETAPA cascade constraints;  
create table DATAETAPA
(
   NUMMOD NUMBER NOT NULL,
   DISTPROVA NUMBER NOT NULL,
   SEXOPROVA CHAR NOT NULL,
   DATA DATE NOT NULL,
   
   CONSTRAINT DATAETAPAPK PRIMARY KEY(NUMMOD,DISTPROVA,SEXOPROVA,DATA),
   CONSTRAINT DATAETAPA_SEXOPROVACK CHECK(SEXOPROVA IN('M','F')),
   CONSTRAINT DATAETAPA_DISTPROVACK CHECK(DISTPROVA>0)
);



-----------------
-- ALTER TABLE --
-----------------

alter table prova
  add constraint ProvaFK_numMod foreign key (numMod) references modalidade (num);
  
alter table serie
  add constraint SerieFK_Prova foreign key (numMod, distProva, sexoProva) references prova (numMod, dist, sexo);

alter table inscrito
  add constraint InscritoFK_Competidor foreign key (NUMINSCR) references competidor (NUMINSCR);
  
alter table inscrito
  add constraint InscritoFK_Mod foreign key (numMod) references modalidade (num);
  
alter table inscrito
  add constraint InscritoFK_Prova foreign key (numMod, distProva, sexoProva) references prova (numMod, dist, sexo);
  
ALTER TABLE PARTICIPA
ADD CONSTRAINT PARTICIPA_NUMINSCRFK FOREIGN KEY (NUMINSCR) REFERENCES COMPETIDOR(NUMINSCR);

ALTER TABLE PARTICIPA
ADD CONSTRAINT PARTICIPA_NUMMODFK FOREIGN KEY (NUMMOD) REFERENCES MODALIDADE(NUM);

ALTER TABLE PARTICIPA
ADD CONSTRAINT PARTICIPA_SEXOPROVAFK FOREIGN KEY (SEXOPROVA,DISTPROVA,NUMMOD) REFERENCES PROVA(SEXO,DIST,NUMMOD);

ALTER TABLE PARTICIPA
ADD CONSTRAINT PARTICIPA_SERIEFK FOREIGN KEY (SEQSERIE,ETAPASERIE,SEXOPROVA,DISTPROVA,NUMMOD) REFERENCES SERIE(SEQ,ETAPA,SEXOPROVA,DISTPROVA,NUMMOD);

ALTER TABLE PATROCINADO
  ADD CONSTRAINT PATROCINADO_NUMINSCRFK FOREIGN KEY (NUMINSCR) REFERENCES COMPETIDOR(NUMINSCR)
  on delete cascade;

ALTER TABLE DATAETAPA
ADD CONSTRAINT DATAETAPA_NUMMODFK FOREIGN KEY (NUMMOD) REFERENCES MODALIDADE(NUM);

ALTER TABLE DATAETAPA
ADD CONSTRAINT DATAETAPA_PROVAFK FOREIGN KEY (NUMMOD,DISTPROVA,SEXOPROVA) REFERENCES PROVA(NUMMOD,DIST,SEXO);


CREATE OR REPLACE VIEW SELECIONADOS_PARA_TORNEIO
AS
SELECT C.NOME,I.NUMMOD,I.SEXOPROVA,I.DISTPROVA,I.MELHORTEMPO
FROM COMPETIDOR C INNER JOIN
INSCRITO I 
ON C.NUMINSCR=I.NUMINSCR
WHERE I.APROVADO='S'
WITH CHECK OPTION;

CREATE OR REPLACE VIEW PARTICIPACAO_DO_COMPETIDOR
AS
SELECT C.NOME,P.NUMMOD,P.SEXOPROVA,P.DISTPROVA,P.ETAPASERIE,P.SEQSERIE,P.TEMPO
FROM COMPETIDOR C INNER JOIN
PARTICIPA P
ON C.NUMINSCR=P.NUMINSCR
WHERE P.SITUACAO=1
WITH CHECK OPTION;

CREATE OR REPLACE VIEW GANHADORES_DA_PROVA
AS
SELECT * FROM PARTICIPA P1
WHERE 3 > (SELECT COUNT(*) FROM PARTICIPA P2 WHERE P2.TEMPO < P1.TEMPO and P2.EtapaSerie = 3);

---------------------------------------------------------------------------------- DECLARA��O DE PROCEDURES, FUN��ES  E TRIGGERS ----------------------------------------------------------------------

------------------------------------------------------ TRIGGER$ -------------------------------------------------------

/**********************************************************************
*	TRIGGER:
*		ParticipaProximaEtapa
*	DESCRI��O:
*   	Age no update da tabela Participa.
*		Garante que um competidor s� possa ter tempo e situa��o
*		colocados em uma s�rie caso o status da s�rie anterior
*											seja 'executada'.
**********************************************************************/
set define off;
create or replace trigger ParticipaProximaEtapa --  TESTADO
before update on Participa
referencing OLD as VelhaParticipacao NEW as NovaParticipacao
for each row
declare
  statusAnterior integer;
begin 

  if :VelhaParticipacao.tempo != :NovaParticipacao.tempo or :VelhaParticipacao.situacao != :NovaParticipacao.situacao then
    if :VelhaParticipacao.SeqSerie > 1 then
      select Status into statusAnterior
		from Serie
		where	NumMod = :VelhaParticipacao.NumMod and
				SexoProva = :VelhaParticipacao.SexoProva and
				DistProva = :VelhaParticipacao.DistProva and
				Etapa = :VelhaParticipacao.EtapaSerie and
				Seq = :VelhaParticipacao.SeqSerie - 1;
		
		if statusAnterior = 0 then
			raise_application_error(-20023,'A s�rie anterior ainda n�o foi finalizada, portanto n�o se pode mudar tempo e situa��o desse competidor ainda');
		end if;
    end if;
  end if;
end;
/

/**********************************************************************
*	TRIGGER:
*		InscritoSexoValido
*	DESCRI��O:
*   	Age no insert da tabela Inscrito.
*		Garante que um competidor s� possa se inscrever em uma prova de
*		seu sexo.
**********************************************************************/
set define off;
create or replace trigger InscritoSexoValido -- TESTADO
before insert on Inscrito
referencing NEW as NovoInscrito
for each row
declare
	sexoInscrito char;
begin
	select Sexo into sexoInscrito
		from Competidor
		where NumInscr = :NovoInscrito.NumInscr;
		
	if sexoInscrito != :NovoInscrito.SexoProva then
		raise_application_error(-20024,'O inscrito n�o pode se inscrever numa prova do sexo oposto');
	end if;
end;
/

------------------------------------------------------ STORED PROCEDURES -------------------------------------------------------


/**********************************************************************
*   PROCEDURE:
*       AbrirInscricoes
*   DESCRI��O:
*       Abre as inscri��es em todas as prova, permitindo a inscri��o de
*		competidores nelas. N�o funciona caso inscri��es j� tenham sido
*		anteriormente abertas e fechadas.
**********************************************************************/
create or replace procedure AbrirInscricoes -- TESTADO
as
	inscricoes 		integer;
begin
	select Valor into inscricoes
		from Globais
		where Nome = 'inscricoes';
	if inscricoes = 1 then
		raise_application_error(-20010,'As inscri��es j� foram abertas!');
	end if;
	if inscricoes = 0 then
		raise_application_error(-20011,'As inscri��es j� foram finalizadas! N�o podem ser reabertas!');
	end if;
	if inscricoes != -1 then
		raise_application_error(-20012,'Erro desconhecido: Configura��o "inscricoes" com valor inv�lido');
	end if;
	
	update Globais
		set Valor = 1
		where Nome = 'inscricoes';
end AbrirInscricoes;
/
 
/**********************************************************************
*   PROCEDURE:
*       CriarProva
*   DESCRI��O:
*       Cria uma prova. Falha se datas passadas n�o seguirem requisitos:
*       Datas das etapas devem ser diferentes. Data da eliminat�ria �
*       predecessora da semifinal que vem antes da etapa final. 
*   PAR�METROS:
*       pMod        - ENTRADA   - INTEIRO
*           N�mero da modalidade (ver tabela Modalidade) da prova
*       pSexo   - ENTRADA   - CARACTER
*           'M' ou 'F', sexo dos participantes da prova
*       pDist       - ENTRADA   - N�MERO
*           Dist�ncia de percurso da prova, em metros
*       pData1      - ENTRADA   - DATA
*           Data da etapa eliminat�ria
*       pData2      - ENTRADA   - DATA
*           Data da etapa semifinal
*       pData3      - ENTRADA   - DATA
*           Data da etapa final 
**********************************************************************/
create or replace procedure CriarProva  (pMod in integer, pSexo in char, pDist in number, -- TESTADO
                                        pData1 in date, pData2 in date, pData3 in date)
as
begin
    if pData1 = pData2 or pData1 = pData3 or pData2 = pData3 or pData1 > pData2 or pData2 > pData3 then
        raise_application_error(-20001,'Datas de etapas inv�lidas');
    end if;
    insert into Prova(NumMod,Sexo,Dist)
        values (pMod,pSexo,pDist);
    insert into DataEtapa(NumMod,DistProva,SexoProva,Data)
        values  (pMod,pDist,pSexo,pData1);
    insert into DataEtapa(NumMod,DistProva,SexoProva,Data)
        values  (pMod,pDist,pSexo,pData2);
    insert into DataEtapa(NumMod,DistProva,SexoProva,Data)
        values  (pMod,pDist,pSexo,pData3);
end CriarProva;
/
 
/**********************************************************************
*   PROCEDURE:
*       AdicionarPatrocinio
*   DESCRI��O:
*       Cadastra um patrocinador de um competidor
*   PAR�METROS:
*       pNumInscr   - ENTRADA   - INTEIRO
*           N�mero de inscri��o do competidor
*       pPatroc     - ENTRADA   - STRING
*           Nome do patrocinador
**********************************************************************/
create or replace procedure AdicionarPatrocinio (pNumInscr in integer, pPatroc in varchar2)		-- TESTADO
as
begin
    insert into Patrocinado(NumInscr,Patrocinador)
        values(pNumInscr,pPatroc);
end;
/
 
/**********************************************************************
*   PROCEDURE:
*       FazerInscricao
*   DESCRI��O:
*       Inscreve um competidor numa prova.
*		N�o funciona se inscri��es estiverem finalizadas.
*   PAR�METROS:
*       pNumInscr   - ENTRADA   - INTEIRO
*           N�mero de inscri��o do competidor
*       pModProva           - ENTRADA   - INTEIRO
*           N�mero da modalidade (ver tabela Modalidade) da prova
*       pSexoProva          - ENTRADA   - CARACTER
*           'M' ou 'F', sexo dos participantes da prova
*       pDistProva          - ENTRADA   - N�MERO
*           Dist�ncia de percurso da prova, em metros
*       pMelhorTempo        - ENTRADA   - N�MERO
*           Melhor tempo de nado do competidor em categoria similar
*                                   em torneio antecedente, em segundos
*       pNomeTorneio        - ENTRADA   - STRING
*           Nome do torneio onde foi atingido melhor tempo pessoal
*       pLocalTorneio       - ENTRADA   - STRING
*           Nome do local onde torneio supracitado foi realizado
*       pDataTorneio        - ENTRADA   - DATA
*           Data de ocorr�ncia de torneio supracitado
**********************************************************************/
create or replace procedure FazerInscricao (pNumInscr in integer, pModProva in integer, -- TESTADO
                    pSexoProva in char, pDistProva in number, pMelhorTempo in number,
        pNomeTorneio in varchar2, pLocalTorneio in varchar2, pDataTorneio in varchar2)
as
	inscricoes integer;
begin
	select Valor into inscricoes
		from Globais
		where Nome = 'inscricoes';
	if inscricoes = 0 then
		raise_application_error(-20007,'A inscri��o n�o p�de ser feita porque as inscri��es j� foram finalizadas');
	end if;
	if inscricoes = -1 then
		raise_application_error(-20013,'A inscri��o n�o p�de ser feita porque as inscri��es ainda n�o foram abertas');
	end if;
	if inscricoes != 1 then
		raise_application_error(-20014,'Erro desconhecido: Configura��o "inscricoes" com valor inv�lido');
	end if;
    insert into Inscrito(NumInscr,NumMod,SexoProva,DistProva,MelhorTempo,NomeTorneio,
                                                    LocalTorneio,DataTorneio,Aprovado)
        values(pNumInscr,pModProva,pSexoProva,pDistProva,pMelhorTempo,pNomeTorneio,
                                                    pLocalTorneio,pDataTorneio,'N');
end;
/
 
/**********************************************************************
*   PROCEDURE:
*       CriarSeries
*   DESCRI��O:
*       Cria s�ries necess�rias pra realiz��o de uma prova, segundo a
*       quantidade de participantes selecionados (estritamente positivo)
*   PAR�METROS:
*       pModProva           - ENTRADA   - INTEIRO
*           N�mero da modalidade (ver tabela Modalidade) da prova
*       pSexoProva          - ENTRADA   - CARACTER
*           'M' ou 'F', sexo dos participantes da prova
*       pDistProva          - ENTRADA   - N�MERO
*           Dist�ncia de percurso da prova, em metros
*       pNumParticipantes   - ENTRADA   - N�MERO
*           N�mero de participantes total que participar� na prova
*                                                       (de 0 a 64)
**********************************************************************/
create or replace procedure CriarSeries (pModProva in integer, pSexoProva in char, pDistProva in number, -- TESTADO
                                        pNumParticipantes in integer)
as
    numSeries integer;
begin
    if pNumParticipantes <= 0 then
        raise_application_error(-20002,'N�mero de participantes da prova inv�lido');
    end if;
    numSeries := ceil(pNumParticipantes / 8);
    for i in 1..numSeries loop
        insert into Serie(NumMod,SexoProva,DistProva,Etapa,Seq,Status)
            values(pModProva,pSexoProva,pDistProva,1,i,0);
    end loop;
    if numSeries > 4 then
        numSeries := 4;
    end if;
    for i in 1..numSeries loop
        insert into Serie(NumMod,SexoProva,DistProva,Etapa,Seq,Status)
            values(pModProva,pSexoProva,pDistProva,2,i,0);
    end loop;
    insert into Serie(NumMod,SexoProva,DistProva,Etapa,Seq,Status)
        values(pModProva,pSexoProva,pDistProva,3,1,0);
end CriarSeries;
/
 
/**********************************************************************
*   PROCEDURE:
*       AlocarSelecionados
*   DESCRI��O:
*       Coloca participantes selecionados em uma prova em s�ries e
*       raias aleat�rias da etapa semifinal.
*   PAR�METROS:
*       pModProva           - ENTRADA   - INTEIRO
*           N�mero da modalidade (ver tabela Modalidade) da prova
*       pSexoProva          - ENTRADA   - CARACTER
*           'M' ou 'F', sexo dos participantes da prova
*       pDistProva          - ENTRADA   - N�MERO
*           Dist�ncia de percurso da prova, em metros
*       pNumParticipantes   - ENTRADA   - N�MERO
*           N�mero de participantes total que participar� na prova
*                                                       (de 0 a 64)
**********************************************************************/
create or replace procedure AlocarSelecionados  (pModProva in integer, pSexoProva in char, -- TESTADO
                                        pDistProva in number, pNumParticipantes in integer)
as
    numSeries integer;
    numRaiasExtras integer; -- N�mero de raias que ser�o usadas na �ltima s�rie
    raiaLimite integer;
    rSeed  BINARY_INTEGER;
    linhaInscrito Inscrito%rowtype;
    raiaRNG integer;
    serieRNG integer;
    linhaRNG integer;
    linhasRestantes integer;
     
    cursor cursorInscritoAprovados
        is
        select *
			from Inscrito
			where NumMod = pModProva and
            SexoProva = pSexoProva and
            DistProva = pDistProva and
            Aprovado = 'S';
begin
    rSeed := TO_NUMBER(TO_CHAR(SYSDATE,'YYYYDDMMSS'));
    dbms_random.initialize(val => rSeed);
     
    numSeries := ceil(pNumParticipantes / 8);
    numRaiasExtras := pNumParticipantes mod 8;
    if numRaiasExtras = 0 then -- Se a divis�o � exata a �ltima s�rie possui 8 raias
        numRaiasExtras := 8;
    end if;
     
    delete from RaiasAAlocar; -- Limpa tabela auxiliar para utiliz�-la
     
    for percorreSeries in 1..numSeries loop
        if percorreSeries = numSeries then -- �ltima s�rie -> preenchem-se algumas raias
            raiaLimite := numRaiasExtras;
        else -- primeiras s�ries -> preenchem-se todas as raias
            raiaLimite := 8;
        end if;
         
        for percorreRaias in 1..raiaLimite loop
            insert into RaiasAAlocar(Ident,SeqSerie,NumRaia)
                values((percorreSeries-1)*8+percorreRaias,percorreSeries,percorreRaias);
        end loop;
    end loop;
     
    linhasRestantes := pNumParticipantes;
    open cursorInscritoAprovados;
    loop
        fetch cursorInscritoAprovados into linhaInscrito;
        exit when cursorInscritoAprovados%notfound;
         
        linhaRNG := floor(dbms_random.value(1,linhasRestantes+1));
        select SeqSerie, NumRaia into serieRNG, raiaRNG
			from RaiasAAlocar casoATestar
			where linhaRNG-1 =  (select count(*) as qtdMenores
								from RaiasAAlocar
								where Ident < casoATestar.Ident);
        insert into Participa(NumInscr,NumMod,SexoProva,DistProva,EtapaSerie,SeqSerie,Tempo,Situacao,Raia)
            values(linhaInscrito.NumInscr,pModProva,pSexoProva,pDistProva,1,serieRNG,NULL,NULL,raiaRNG);
        delete from RaiasAAlocar
            where   SeqSerie = serieRNG and
                    NumRaia = raiaRNG;
        linhasRestantes := linhasRestantes - 1;
    end loop;
    close cursorInscritoAprovados;
     
    dbms_random.terminate;
end AlocarSelecionados;
/

/**********************************************************************
*   PROCEDURE:
*       FinalizarInscricoesProva
*   DESCRI��O:
*       Finaliza as inscri��es de uma prova, selecionando os
*		participantes, criando automaticamente todas suas s�ries e
*		alocando cada participante em uma raia da etapa eliminat�ria.
*		N�o funciona se inscri��es estiverem finalizadas.
*   PAR�METROS:
*       pModProva           - ENTRADA   - INTEIRO
*           N�mero da modalidade (ver tabela Modalidade) da prova
*       pSexoProva          - ENTRADA   - CARACTER
*           'M' ou 'F', sexo dos participantes da prova
*       pDistProva          - ENTRADA   - N�MERO
*           Dist�ncia de percurso da prova, em metros
**********************************************************************/
create or replace procedure FinalizarInscricoesProva (pModProva in integer, pSexoProva in char, -- TESTADO
                                                                    pDistProva in number)
as
    numSelecionados integer;
	inscricoes 	integer;
begin
	select Valor into inscricoes
		from Globais
		where Nome = 'inscricoes';
	if inscricoes = 0 then
		raise_application_error(-20008,'As inscri��es j� foram finalizadas');
	end if;
	if inscricoes = -1 then
		raise_application_error(-20015,'As inscri��es ainda nao foram abertas');
	end if;
	if inscricoes != 1 then
		raise_application_error(-20016,'Erro desconhecido: Configura��o "inscricoes" com valor inv�lido');
	end if;
    
	numSelecionados := SelecionarInscritos(pModProva,pSexoProva,pDistProva);
	if numSelecionados > 0 then
		CriarSeries(pModProva,pSexoProva,pDistProva,numSelecionados);
		AlocarSelecionados(pModProva,pSexoProva,pDistProva,numSelecionados);
	end if;
	
end FinalizarInscricoesProva;
/

/**********************************************************************
*   PROCEDURE:
*       FinalizarInscricoes
*   DESCRI��O:
*       Finaliza as inscri��es de todas as prova, selecionando os
*		participantes de cada, criando automaticamente todas as s�ries e
*		alocando cada participante em uma raia de cada etapa eliminat�ria.
*		Por fim, encerra as inscri��es.
*		N�o funciona se inscri��es estiverem finalizadas.
**********************************************************************/
create or replace procedure FinalizarInscricoes -- TESTADO
as
	inscricoes 	integer;
	linhaProva		Prova%rowtype;
	
	cursor cursorProva
		is
		select *
		from Prova;
begin
	select Valor into inscricoes
		from Globais
		where Nome = 'inscricoes';
	if inscricoes = 0 then
		raise_application_error(-20009,'As inscri��es j� foram finalizadas');
	end if;
	if inscricoes = -1 then
		raise_application_error(-20017,'As inscri��es ainda nao foram abertas');
	end if;
	if inscricoes != 1 then
		raise_application_error(-20018,'Erro desconhecido: Configura��o "inscricoes" com valor inv�lido');
	end if;
    
	open cursorProva;
	loop
		fetch cursorProva into linhaProva;
		exit when cursorProva%notfound;
		
		FinalizarInscricoesProva(linhaProva.NumMod,linhaProva.Sexo,linhaProva.Dist);
	end loop;
	close cursorProva;
	
	update Globais
		set Valor = 0
		where Nome = 'inscricoes';
	
end FinalizarInscricoes;
/
 
/**********************************************************************
*   PROCEDURE:
*       CadastrarTempo
*   DESCRI��O:
*       Cadastra (ou substitui) o tempo de nado de um competidor que
*       realizou (e completou) uma s�rie em uma etapa da prova. Isso
*       automaticamente cadastra a participa��o do competidor na s�rie
*       como "CONCLU�DA". N�o funciona se a s�rie j� foi dada como
*                                                       "executada".
*   PAR�METROS:
*       pNumInscr   - ENTRADA   - INTEIRO
*           N�mero de inscri��o do competidor
*       pModProva   - ENTRADA   - INTEIRO
*           N�mero da modalidade (ver tabela Modalidade) da prova
*       pSexoProva  - ENTRADA   - CARACTER
*           'M' ou 'F', sexo dos participantes da prova
*       pDistProva  - ENTRADA   - N�MERO
*           Dist�ncia de percurso da prova, em metros
*       pEtapaSerie - ENTRADA   - INTEIRO
*           N�mero de 1 a 3 que representa a etapa da prova
*                           (1- eliminat�ria, 2- semifinal, 3- final)
*       pTempo      - ENTRADA   - N�MERO
*           N�mero que representa tempo de conclus�o da s�rie de nado
*           do competidor, em segundos. 
**********************************************************************/
create or replace procedure CadastrarTempo (pNumInscr in integer, pModProva in integer, -- TESTADO
    pSexoProva in char, pDistProva in number, pEtapaSerie in integer, pTempo in number)
as
    sequenciaSerie integer;
    statusSerie integer;
    linhasAtualizadas integer;
begin
    select SeqSerie into sequenciaSerie
    from Participa
    where   NumInscr = PNumInscr and
            NumMod = pModProva and
            SexoProva = pSexoProva and
            DistProva = pDistProva and
            EtapaSerie = pEtapaSerie;
    select status into statusSerie
    from Serie
    where   NumMod = pModProva and
            SexoProva = pSexoProva and
            DistProva = pDistProva and
            Etapa = pEtapaSerie and
            Seq = sequenciaSerie;
    if statusSerie = 1 then -- S�rie j� foi executada
        raise_application_error(-20003,'S�rie j� foi executada e foi marcada como inalter�vel');
    end if;
     
    update Participa
        set Situacao = 1, Tempo = pTempo
        where   NumInscr = PNumInscr and
                NumMod = pModProva and
                SexoProva = pSexoProva and
                DistProva = pDistProva and
                EtapaSerie = pEtapaSerie;
     
    linhasAtualizadas := sql%rowcount;
    if linhasAtualizadas = 0 then
        raise_application_error(-20004,'Erro: Competidor ou prova/etapa da s�rie inv�lidos');
    end if;
end CadastrarTempo;
/
 
/**********************************************************************
*   PROCEDURE:
*       CadastrarSituacao
*   DESCRI��O:
*       Cadastra (ou substitui) a participa��o de um competidor numa
*       s�rie de uma etapa de uma prova como "NULO" (ainda indefinida),
*       "DESCLASSIFICADO" ou "AUSENTE" (Para cadastrar como conclu�da,
*       deve-se usar a procedure "CadastrarTempo"). N�o funciona se a
*       s�rie j� foi dada como "executada".
*   PAR�METROS:
*       pNumInscr   - ENTRADA   - INTEIRO
*           N�mero de inscri��o do competidor
*       pModProva   - ENTRADA   - INTEIRO
*           N�mero da modalidade (ver tabela Modalidade) da prova
*       pSexoProva  - ENTRADA   - CARACTER
*           'M' ou 'F', sexo dos participantes da prova
*       pDistProva  - ENTRADA   - N�MERO
*           Dist�ncia de percurso da prova, em metros
*       pEtapaSerie - ENTRADA   - INTEIRO
*           N�mero de 1 a 3 que representa a etapa da prova
*                           (1- eliminat�ria, 2- semifinal, 3- final)
*       pSituacao   - ENTRADA   - INTEIRO
*           N�mero que representa nova situa��o do competidor:
*           0- NULO, 1- DESCLASSIFICADO, 2- AUSENTE
**********************************************************************/
create or replace procedure CadastrarSituacao (pNumInscr in integer, pModProva in integer, -- TESTADO
    pSexoProva in char, pDistProva in number, pEtapaSerie in integer, pSituacao in integer)
as
    sequenciaSerie integer;
    statusSerie integer;
    linhasAtualizadas integer;
begin
    select SeqSerie into sequenciaSerie
    from Participa
    where   NumInscr = PNumInscr and
            NumMod = pModProva and
            SexoProva = pSexoProva and
            DistProva = pDistProva and
            EtapaSerie = pEtapaSerie;
    select status into statusSerie
    from Serie
    where   NumMod = pModProva and
            SexoProva = pSexoProva and
            DistProva = pDistProva and
            Etapa = pEtapaSerie and
            Seq = sequenciaSerie;
    if statusSerie = 1 then -- S�rie j� foi executada
        raise_application_error(-20003,'S�rie j� foi executada e foi marcada como inalter�vel');
    end if;
     
    if pSituacao = 0 then
        update Participa
            set Situacao = NULL, Tempo = NULL
            where   NumInscr = PNumInscr and
                    NumMod = pModProva and
                    SexoProva = pSexoProva and
                    DistProva = pDistProva and
                    EtapaSerie = pEtapaSerie;
    else
        if pSituacao = 1 or pSituacao = 2 then
            update Participa
                set Situacao = pSituacao+1, Tempo = NULL
                where   NumInscr = PNumInscr and
                        NumMod = pModProva and
                        SexoProva = pSexoProva and
                        DistProva = pDistProva and
                        EtapaSerie = pEtapaSerie;
        else -- pSituacao passada � inv�lida!
            raise_application_error(-20005,'N�mero de situa��o passado � inv�lido (deve ser de 1 a 2)');
        end if;
    end if;
                 
    linhasAtualizadas := sql%rowcount;
    if linhasAtualizadas = 0 then
        raise_application_error(-20006,'Erro: Competidor ou prova/etapa da s�rie inv�lidos');
    end if;
end CadastrarSituacao;
/

/**********************************************************************
*   PROCEDURE:
*       FinalizarSerie
*   DESCRI��O:
*       Muda o status de uma s�rie para "executada". S� funciona caso
*		todos os tempos ou situa��es dos competidores que nadaram nela
*		tenham sido inicializados. Finalizar a s�rie bloqueia toda
*		futura altera��o desses tempos e situa��es.
*   PAR�METROS:
*       pModProva   - ENTRADA   - INTEIRO
*           N�mero da modalidade (ver tabela Modalidade) da prova
*       pSexoProva  - ENTRADA   - CARACTER
*           'M' ou 'F', sexo dos participantes da prova
*       pDistProva  - ENTRADA   - N�MERO
*           Dist�ncia de percurso da prova, em metros
*       pEtapaSerie - ENTRADA   - INTEIRO
*           N�mero de 1 a 3 que representa a etapa
*                           (1- eliminat�ria, 2- semifinal, 3- final)
*       pSeqSerie	- ENTRADA   - INTEIRO
*           N�mero sequencial que identifica a s�rie da etapa
**********************************************************************/
create or replace procedure FinalizarSerie	(pModProva in integer, pSexoProva in char, pDistProva in number, -- TESTADO
											pEtapaSerie in integer, pSeqSerie in integer)
as
	situacoesNulas integer;
	linhasAtualizadas integer;
begin
	select count(*) into situacoesNulas
		from Participa
		where	NumMod = pModProva and
				SexoProva = pSexoProva and
				DistProva = pDistProva and
				EtapaSerie = pEtapaSerie and
				SeqSerie = pSeqSerie and
				Situacao is NULL;
	if situacoesNulas > 0 then
		raise_application_error(-20019,'A s�rie n�o pode ser finalizada, ainda existem participantes de situa��o indefinida');
	end if;
	update Serie
		set Status = 1
		where	NumMod = pModProva and
				SexoProva = pSexoProva and
				DistProva = pDistProva and
				Etapa = pEtapaSerie and
				Seq = pSeqSerie and
				Status = 0;
	linhasAtualizadas := sql%rowcount;
	if linhasAtualizadas = 0 then
		raise_application_error(-20020,'A s�rie n�o existe ou j� foi finalizada');
	end if;
end FinalizarSerie;
/

/**********************************************************************
*   PROCEDURE:
*       FinalizarEtapa
*   DESCRI��O:
*       Finaliza a etapa eliminat�ria ou semifinal de uma prova, 
*		selecionando os melhores competidoes e passando-os para a etapa
*		seguinte. Aloca os competidores em s�ries e raias aleat�rias da
*		nova etapa ou em raias espec�ficas, no caso da etapa final. S�
*		funciona caso todas as s�ries da etapa encerrada estejam marcadas
*		como executadas.
*   PAR�METROS:
*       pModProva   - ENTRADA   - INTEIRO
*           N�mero da modalidade (ver tabela Modalidade) da prova
*       pSexoProva  - ENTRADA   - CARACTER
*           'M' ou 'F', sexo dos participantes da prova
*       pDistProva  - ENTRADA   - N�MERO
*           Dist�ncia de percurso da prova, em metros
*       pEtapa		- ENTRADA   - INTEIRO
*           N�mero de 1 a 2 que representa a etapa a ser finalizada
*                           (1- eliminat�ria, 2- semifinal)
**********************************************************************/
create or replace procedure FinalizarEtapa  (pModProva in integer, pSexoProva in char, -- TESTADO
											pDistProva in number, pEtapa in integer)
as
    numSeries integer;
    numRaiasExtras integer; -- N�mero de raias que ser�o usadas na �ltima s�rie
    raiaLimite integer;
    rSeed  BINARY_INTEGER;
    numInscrSelecionado Participa.NumInscr%type;
    raiaRNG integer;
    serieRNG integer;
    linhaRNG integer;
    linhasRestantes integer;
	numSelecionados integer;
	numSeriesNaoExecutadas integer;
	posSelecionado integer;
	posRaia integer;
	seriesDaEtapa integer;
	numMaxSelecionados integer;
     
	cursor cursorMenoresTemposEtapa (pModProva integer, pSexoProva char, pDistProva number, pEtapa number, pQtdMelhores integer)
	is
	(select *
		from (
		  select NumInscr,
		  row_number() over (order by Tempo, NumInscr) posicao
		  from Participa
		  where	NumMod = pModProva and
				SexoProva = pSexoProva and
				DistProva = pDistProva and
				EtapaSerie = pEtapa and
				Tempo is not NULL
		)
		where posicao <= pQtdMelhores);
begin

	select count(*) into numSeriesNaoExecutadas
		from Serie
		where	NumMod = pModProva and
				SexoProva = pSexoProva and
				DistProva = pDistProva and
				Etapa = pEtapa and
				Status = 0;
	
	select count(*) into seriesDaEtapa
		from Serie
		where	NumMod = pModProva and
				SexoProva = pSexoProva and
				DistProva = pDistProva and
				Etapa = pEtapa;
		
	if seriesDaEtapa = 0 then
		raise_application_error(-20022,'Prova ou etapa inv�lida');
	end if;
	
	if numSeriesNaoExecutadas > 0 then
		raise_application_error(-20023,'N�o � poss�vel finalizar a etapa pois h� s�ries ainda n�o executadas!');
	end if;
	
	if pEtapa = 1 then
		numMaxSelecionados := 32;
	else
		if pEtapa = 2 then
			numMaxSelecionados := 8;
		end if;
	end if;

	select count(*) into numSelecionados
		from (
		  select NumInscr,
		  row_number() over (order by Tempo, NumInscr) posicao
		  from Participa
		  where	NumMod = pModProva and
				SexoProva = pSexoProva and
				DistProva = pDistProva and
				EtapaSerie = pEtapa and
				Tempo is not NULL
		)
		where posicao <= numMaxSelecionados;
		
	if pEtapa = 1 then
		rSeed := TO_NUMBER(TO_CHAR(SYSDATE,'YYYYDDMMSS'));
		dbms_random.initialize(val => rSeed);
		
		numSeries := ceil(numSelecionados / 8);
		numRaiasExtras := numSelecionados mod 8;
		if numRaiasExtras = 0 then -- Se a divis�o � exata a �ltima s�rie possui 8 raias
			numRaiasExtras := 8;
		end if;
		
		delete from RaiasAAlocar; -- Limpa tabela auxiliar para utiliz�-la
		
		for percorreSeries in 1..numSeries loop
			if percorreSeries = numSeries then -- �ltima s�rie -> preenchem-se algumas raias
				raiaLimite := numRaiasExtras;
			else -- primeiras s�ries -> preenchem-se todas as raias
				raiaLimite := 8;
			end if;
			 
			for percorreRaias in 1..raiaLimite loop
				insert into RaiasAAlocar(Ident,SeqSerie,NumRaia)
					values((percorreSeries-1)*8+percorreRaias,percorreSeries,percorreRaias);
			end loop;
		end loop;
		
		linhasRestantes := numSelecionados;
		open cursorMenoresTemposEtapa(pModProva,pSexoProva,pDistProva,pEtapa,32);
		loop
			fetch cursorMenoresTemposEtapa into numInscrSelecionado;
			exit when cursorMenoresTemposEtapa%notfound;
			 
			linhaRNG := floor(dbms_random.value(1,linhasRestantes+1));
			select SeqSerie, NumRaia into serieRNG, raiaRNG
				from RaiasAAlocar casoATestar
				where linhaRNG-1 =  (select count(*) as qtdMenores
									from RaiasAAlocar
									where Ident < casoATestar.Ident);
			insert into Participa(NumInscr,NumMod,SexoProva,DistProva,EtapaSerie,SeqSerie,Tempo,Situacao,Raia)
				values(numInscrSelecionado,pModProva,pSexoProva,pDistProva,2,serieRNG,NULL,NULL,raiaRNG);
			delete from RaiasAAlocar
				where   SeqSerie = serieRNG and
						NumRaia = raiaRNG;
			linhasRestantes := linhasRestantes - 1;
		end loop;
		close cursorMenoresTemposEtapa;
		 
		dbms_random.terminate;

	else
		if pEtapa = 2 then
			open cursorMenoresTemposEtapa(pModProva,pSexoProva,pDistProva,pEtapa,8);
			posSelecionado := 1;
			loop
				fetch cursorMenoresTemposEtapa into numInscrSelecionado;
				exit when cursorMenoresTemposEtapa%notfound;
				
				if posSelecionado = 1 then posRaia := 4;
				else
					if posSelecionado = 2 then posRaia := 5;
					else
						if posSelecionado = 3 then posRaia := 3;
						else
							if posSelecionado = 4 then posRaia := 6;
							else
								if posSelecionado = 5 then posRaia := 2;
								else
									if posSelecionado = 6 then posRaia := 7;
									else
										if posSelecionado = 7 then posRaia := 1;
										else
											posRaia := 8;
										end if;
									end if;
								end if;
							end if;
						end if;
					end if;
				end if;
				
				insert into Participa(NumInscr,NumMod,SexoProva,DistProva,EtapaSerie,SeqSerie,Tempo,Situacao,Raia)
					values(numInscrSelecionado,pModProva,pSexoProva,pDistProva,3,1,NULL,NULL,posRaia);
				
				posSelecionado := posSelecionado + 1;
			end loop;
			close cursorMenoresTemposEtapa;
		else
			raise_application_error(-20021,'Etapa inv�lida');
		end if;		
	end if;
	
end FinalizarEtapa;
/

------------------------------------------------------ FUN��ES -------------------------------------------------------

/**********************************************************************
*	FUN��O:
*		ObterDataEtapa
*	DESCRI��O:
*   	Obt�m a data em que ocorre uma etapa (n�mero de 1 a 3) de uma
*																prova
*	PAR�METROS:
*		pModProva	- ENTRADA	- INTEIRO
*			N�mero da modalidade (ver tabela Modalidade) da prova
*		pSexoProva	- ENTRADA	- CARACTER
*			'M' ou 'F', sexo dos participantes da prova
*		pDistProva	- ENTRADA	- N�MERO
*			Dist�ncia de percurso da prova, em metros
*		pEtapa		- ENTRADA	- N�MERO
*			N�mero de 1 a 3 que representa etapa (1- eliminat�ria,
*												2- semifinal, 3- final)	
*	RETORNO:
*		DATA - Retorna a data de realiza��o da etapa
**********************************************************************/
create or replace function ObterDataEtapa(pModProva in integer, pSexoProva in char, pDistProva in number, pEtapa in integer)	-- TESTADO
return date as
  dataEsperada date;
begin
  select Data into dataEsperada
    from DataEtapa dataEmTeste
    where pModProva = NumMod and
          pSexoProva = SexoProva and
          pDistProva = DistProva and
            pEtapa-1 =  (select count(*)
                        from DataEtapa
                        where Data < dataEmTeste.Data);
    return dataEsperada;
end ObterDataEtapa;
/

/**********************************************************************
*	FUN��O:
*		CriarCompetidor
*	DESCRI��O:
*   	Cadastra um competidor no BD. N�o funciona se as inscri��es n�o
*		  houverem sido abertas.
*	PAR�METROS:
*		pNome	- ENTRADA	- STRING
*			Nome do competidor
*		pSexo	- ENTRADA	- CARACTER
*			'M' ou 'F', sexo do competidor
*		pAno	- ENTRADA	- INTEIRO
*			Ano de nascimento do competidor
*	RETORNO:
*		INTEIRO - Retorna o n�mero de inscri��o do competidor criado
**********************************************************************/
create or replace function CriarCompetidor (pNome in varchar2, pSexo in char, pAno in integer)		-- RETESTAR
return integer as
	inscr integer;
	numCompetidores integer;
	inscricoes integer;
begin
	select Valor into inscricoes
		from Globais
		where Nome = 'inscricoes';
	if inscricoes = 0 then
		raise_application_error(-20007,'A inscri��o n�o p�de ser feita porque as inscri��es j� foram finalizadas');
	end if;
	if inscricoes = -1 then
		raise_application_error(-20013,'A inscri��o n�o p�de ser feita porque as inscri��es ainda n�o foram abertas');
	end if;
	if inscricoes != 1 then
		raise_application_error(-20014,'Erro desconhecido: Configura��o "inscricoes" com valor inv�lido');
	end if;

	select count(*) into numCompetidores
		from Competidor;
	
	if (numCompetidores = 0) then
		inscr := 1;
	else
		select max(NumInscr) into inscr
			from Competidor;
		inscr := inscr + 1;
	end if;
	
	insert into Competidor(NumInscr,Nome,Sexo,AnoNasc)
		values(inscr,pNome,pSexo,pAno);
	return inscr;
end;
/

/**********************************************************************
*	FUN��O:
*		SelecionarInscritos
*	DESCRI��O:
*   	Seleciona os 64 melhores competidores inscritos em uma prova e
*		muda o atributo "Aprovado" da tabela Inscrito deles para 'S'
*	PAR�METROS:
*		pModProva	- ENTRADA	- INTEIRO
*			N�mero da modalidade (ver tabela Modalidade) da prova
*		pSexoProva	- ENTRADA	- CARACTER
*			'M' ou 'F', sexo dos participantes da prova
*		pDistProva	- ENTRADA	- N�MERO
*			Dist�ncia de percurso da prova, em metros
*	RETORNO:
*		INTEIRO - Retorna o n�mero de participates selecionados
**********************************************************************/
create or replace function SelecionarInscritos	(pModProva in integer, pSexoProva in char, -- RETESTAR
												pDistProva in number)
return integer as
	inscricaoSelecionada Inscrito.NumInscr%type;
	numLinha integer;
	numSelecionados integer;
	
	cursor cursorInscritoMenoresTempos (pModProva integer, pSexoProva char, pDistProva number, pQtdMelhores integer)
	is
	(select *
		from (
		  select NumInscr,
		  row_number() over (order by MelhorTempo, NumInscr) posicao
		  from Inscrito
		  where	NumMod = pModProva and
				SexoProva = pSexoProva and
				DistProva = pDistProva
		)
		where posicao <= pQtdMelhores);
begin
	numSelecionados := 0;
	
	open cursorInscritoMenoresTempos(pModProva,pSexoProva,pDistProva,64);
	loop
		fetch cursorInscritoMenoresTempos into inscricaoSelecionada, numLinha;
		exit when cursorInscritoMenoresTempos%notfound;
		
		update Inscrito
			set Aprovado = 'S'
			where NumInscr = inscricaoSelecionada;
		
		numSelecionados := numSelecionados + 1;
	end loop;
	close cursorInscritoMenoresTempos;
	
	return numSelecionados;
end SelecionarInscritos;
/



---------------------------------------------------------------------------------- INICIALIZA��ES ---------------------------------------------------------------------------------------------------------
insert into Globais(Nome, Valor)
  values('inscricoes', -1);

------------------------------------------------------------------------------------------- TESTES -----------------------------------------------------------------------------------------------------

insert into modalidade
  values(1,'Medley');
insert into modalidade
  values(2,'Crawl');
insert into modalidade
  values(3,'Borboleta');
insert into modalidade
  values(4,'Peito');
insert into modalidade
  values(5,'Costas');
insert into modalidade
  values(6,'Cachorrinho');

-- PROCEDURE Abrir Inscricoes
begin
  AbrirInscricoes;
end;
/

-- PROCEDURE Criar Prova
begin
  CriarProva(1,'M',200.5,to_date('10/12/2016','dd/mm/yyyy'),to_date('11/12/2016','dd/mm/yyyy'),to_date('12/12/2016','dd/mm/yyyy'));
  CriarProva(1,'F',200.5,to_date('10/12/2016','dd/mm/yyyy'),to_date('11/12/2016','dd/mm/yyyy'),to_date('12/12/2016','dd/mm/yyyy'));
  CriarProva(2,'M',200.5,to_date('10/12/2016','dd/mm/yyyy'),to_date('11/12/2016','dd/mm/yyyy'),to_date('12/12/2016','dd/mm/yyyy'));
end;
/

-- FUN��O Criar Competidor
declare
  ident integer;
begin
  ident := CriarCompetidor('Jo�o T Greysson','M',1997);
end;
/

-- PROCEDURE Adicionar Patroc�nio
declare
  ident integer;
begin
  ident := CriarCompetidor('Patr�cia Popular Patrocinada','F',1997);
  AdicionarPatrocinio(ident,'Churrascaria Vegana');
  AdicionarPatrocinio(ident,'Mundo Verde');
end;
/

-- PROCEDURE Fazer Inscri��o
declare
  ident integer;
begin
  ident := CriarCompetidor('Gabriel Tatu','M',1997);
  FazerInscricao(ident,1,'M',200.5,2.2,'T','t',to_date('30/10/2016','dd/mm/yyyy'));
end;
/

-- PROCEDURE FinalizarInscricoes (Testa tamb�m as procedures/fun��es: FinalizarInscricoesProva, SelecionarInscritos, CriarSeries, AlocarSelecionados)
declare
  ident integer;
  numTorneio integer;
  tempoTotal number;
begin
  for i in 1..67 loop
    ident := CriarCompetidor('Competidor (Mod 2) '||i,'M',1997);
    numTorneio := (i mod 7) + 1;
    tempoTotal := (i-34)*(i-34)+1;
    if tempoTotal >= 1000 then
      tempoTotal := 999.99;
    end if;
    FazerInscricao(ident,2,'M',200.5,tempoTotal,'Torneio '||numTorneio,'Local do torneio '||numTorneio,to_date('0'||numTorneio||'/11/2016','dd/mm/yyyy'));
  end loop;
  for i in 1..9 loop
    ident := CriarCompetidor('Competidor (Mod 1) '||i,'M',1997);
    FazerInscricao(ident,1,'M',200.5,100,'Oi','Casa da m�e joana',to_date('02/11/2016','dd/mm/yyyy'));
  end loop;
  
  FinalizarInscricoes;
end;
/

-- PROCEDURE Cadastrar Tempo/Cadastrar Situa��o

declare
  inscricao Participa.NumInscr%type;
  cursor cursorParticipaSerieEtapa  (pModProva integer, pSexoProva char,
                                    pDistProva number, pEtapa integer, pSeqSerie integer)
    is
    select NumInscr
      from Participa
      where NumMod = pModProva and
            SexoProva = pSexoProva and
            DistProva = pDistProva and
            EtapaSerie = pEtapa and
            SeqSerie = pSeqSerie;
begin
  open cursorParticipaSerieEtapa(2,'M',200.5,1,1);
  loop
    fetch cursorParticipaSerieEtapa into inscricao;
    exit when cursorParticipaSerieEtapa%notfound;
    CadastrarTempo(inscricao,2,'M',200.5,1,50);
  end loop;
  close cursorParticipaSerieEtapa;
  open cursorParticipaSerieEtapa(2,'M',200.5,1,1);
  loop
    fetch cursorParticipaSerieEtapa into inscricao;
    exit when cursorParticipaSerieEtapa%notfound;
    CadastrarSituacao(inscricao,2,'M',200.5,1,1);
  end loop;
  close cursorParticipaSerieEtapa;
end;
/

-- PROCEDURE Finalizar S�rie
declare
  inscricao Participa.NumInscr%type;
  cursor cursorParticipaSerieEtapa  (pModProva integer, pSexoProva char,
                                    pDistProva number, pEtapa integer, pSeqSerie integer)
    is
    select NumInscr
      from Participa
      where NumMod = pModProva and
            SexoProva = pSexoProva and
            DistProva = pDistProva and
            EtapaSerie = pEtapa and
            SeqSerie = pSeqSerie;
begin
  for i in 1..8 loop
    open cursorParticipaSerieEtapa(2,'M',200.5,1,i);
    loop
      fetch cursorParticipaSerieEtapa into inscricao;
      exit when cursorParticipaSerieEtapa%notfound;
      CadastrarTempo(inscricao,2,'M',200.5,1,50);
    end loop;
    close cursorParticipaSerieEtapa;
    
    FinalizarSerie(2,'M',200.5,1,i);
  end loop;
end;
/

-- Finalizar Etapa
begin
  FinalizarEtapa(2,'M',200.5,1);
end;
/

-- Data Etapa
declare
  dataEtapa date;
begin
  dataEtapa := ObterDataEtapa(1,'M',200.5,1);
  dbms_output.put_line('Data Etapa 1: '||dataEtapa);
  dataEtapa := ObterDataEtapa(1,'M',200.5,2);
  dbms_output.put_line('Data Etapa 2: '||dataEtapa);
  dataEtapa := ObterDataEtapa(1,'M',200.5,3);
  dbms_output.put_line('Data Etapa 3: '||dataEtapa);
end;
/

----------------------------------------------------------------------- SELECTS ----------------------------------------------------------------------------------------------------------------------

SELECT C.NOME,P.PATROCINADOR FROM COMPETIDOR C LEFT OUTER JOIN 
PATROCINADO P ON C.NUMINSCR=P.NUMINSCR;
CREATE INDEX PATROCINA_IND ON PATROCINADO(PATROCINADOR);


SELECT I.NomeTorneio, I.LocalTorneio, I.DataTorneio, count(*) as QtdExParticipantes
  FROM Inscrito I
  group by I.NomeTorneio, I.LocalTorneio, I.DataTorneio
  having count(*) >= 5;
CREATE INDEX NOME_TORNEIO_IND ON Inscrito(NomeTorneio);
CREATE INDEX LOCAL_TORNEIO_IND ON Inscrito(LocalTorneio);
CREATE INDEX DATA_TORNEIO_IND ON Inscrito(DataTorneio);