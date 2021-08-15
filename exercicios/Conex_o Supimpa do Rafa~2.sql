-- TRIGGERS

/*************
* DataEtapaDatasDiferentes/DataEtapaDatasDiferentes2:
*   Age na inser��o/update da tabela DataEtapa.
*   Garante que etapas de uma mesma prova tenham datas diferentes.
*************/
create or replace trigger DataEtapaDatasDiferentes
instead of insert on DataEtapas
referencing NEW as NovaData
for each row
declare
  nenhumaDataRepetida number;
begin
  nenhumaDataRepetida :=
    0 = (select count(*)
    from DataEtapas
    where NumMod = NovaData.NumMod and
          DistProva = NovaData.DistProva and
          SexoProva = NovaData.SexoProva and
          Data = NovaData.data);
  if (nenhumaDataRepetida) then
    insert into DataEtapas
      values(NovaData.NumMod,NovaData.DistProva,NovaData.SexoProva,NovaData.Data);
  end if;
end;

create or replace trigger DataEtapaDatasDiferentes2
instead of update on DataEtapas
referencing NEW as NovaData
for each row
declare
  nenhumaDataRepetida number;
begin
  nenhumaDataRepetida :=
    1 >= (select count(*)
    from DataEtapas
    where NumMod = NovaData.NumMod and
          DistProva = NovaData.DistProva and
          SexoProva = NovaData.SexoProva and
          Data = NovaData.data);
  if (nenhumaDataRepetida) then
    insert into DataEtapas
      values(NovaData.NumMod,NovaData.DistProva,NovaData.SexoProva,NovaData.Data);
  end if;
end;


/*************
* ParticipaUmaSeriePorEtapa/ParticipaUmaSeriePorEtapa2:
*   Age na inser��o/update da tabela Participa.
*   Garante que cada competidor s� participe de uma s�rie por etapa, para cada prova
*************/
create or replace trigger ParticipaUmaSeriePorEtapa
instead of insert on Participa
referencing NEW as NovaParticipacao
for each row
declare
  nenhumaTreta number;
begin
  nenhumaTreta :=
    0 = (select count(*)
    from Participa
    where NumInscr = NovaParticipacao.NumInscr and
          NumMod = NovaParticipacao.NumMod and
          SexoProva = NovaParticipacao.SexoProva and
          DistProva = NovaParticipacao.DistProva and
          EtapaSerie = NovaParticipacao.EtapaSerie);
  if (nenhumaTreta) then
    insert into Participa
      values(NovaParticipacao.NumInscr,NovaParticipacao.NumMod,NovaParticipacao.SexoProva,
            NovaParticipacao.DistProva,NovaParticipacao.EtapaSerie,NovaParticipacao.SeqSerie,
            NovaParticipacao.Tempo,NovaParticipacao.Situacao,NovaParticipacao.Raia);
  end if;
end;

create or replace trigger ParticipaUmaSeriePorEtapa2
instead of update on Participa
referencing NEW as NovaParticipacao
for each row
declare
  nenhumaTreta number;
begin
  nenhumaTreta :=
    1 >= (select count(*)
    from Participa
    where NumInscr = NovaParticipacao.NumInscr and
          NumMod = NovaParticipacao.NumMod and
          SexoProva = NovaParticipacao.SexoProva and
          DistProva = NovaParticipacao.DistProva and
          EtapaSerie = NovaParticipacao.EtapaSerie);
  if (nenhumaTreta) then
    insert into Participa
      values(NovaParticipacao.NumInscr,NovaParticipacao.NumMod,NovaParticipacao.SexoProva,
            NovaParticipacao.DistProva,NovaParticipacao.EtapaSerie,NovaParticipacao.SeqSerie,
            NovaParticipacao.Tempo,NovaParticipacao.Situacao,NovaParticipacao.Raia);
  end if;
end;


/*************
* ParticipaProximaEtapa:
*   Age no update da tabela Participa.
*   Garante que um competidor s� possa ter tempo e situa��o colocados em uma s�rie caso
*   o status da s�rie anterior seja 'executada'.
*************/
create or replace trigger ParticipaProximaEtapa
instead of insert on Participa
referencing OLD as VelhaParticipacao NEW as NovaParticipacao
for each row
declare
  altereiOQueNaoDevia number;
  serieAntes number;
  statusAnterior
begin 
  altereiOQueNaoDevia :=
  (VelhaParticipacao.tempo != NovaParticipacao.tempo or
  VelhaParticipacao.situcacao != NovaParticipacao.situacao);
  if (altereiOQueNaoDevia) then
    serieAntes := VelhaParticipacao.SeqSerie;
    if (serieAntes != 1) then
      select status
      case when Seq = serieAntes-1 then
        
      from serie;
    else
      ;
    end if;
  else
    ;
  end if;
end;