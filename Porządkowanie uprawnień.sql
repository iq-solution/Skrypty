
declare @TypRelacji int = 208;    

if exists (select * from dbo.sysobjects where id = object_id(N'dbo.TMP_KLIENT_PH_RKS') and OBJECTPROPERTY(id, N'IsTable') = 1)
  drop table dbo.TMP_KLIENT_PH_RKS;
  
select OB_ID as KLIENTID, uph.UZY_ID as UPHID, urks.UZY_ID as URKSID
into TMP_KLIENT_PH_RKS
from dbo.OBIEKT 
inner join dbo.OBIEKT_RELACJA terklient on  terklient.OBR_ID_OB2 = OB_ID and terklient.OBR_ID_SLO_TYP = @TypRelacji
inner join dbo.UZYTKOWNIK uph on uph.UZY_ID_TERYTORIUM = terklient.OBR_ID_OB1 --and uph.UZY_HIERARCHIA = 1
inner join dbo.OBIEKT_RELACJA terrks on  terrks.OBR_ID_OB2 = terklient.OBR_ID_OB1 and terrks.OBR_ID_SLO_TYP = 211
inner join dbo.UZYTKOWNIK urks on urks.UZY_ID_TERYTORIUM = terrks.OBR_ID_OB1 --and urks.UZY_HIERARCHIA = 1
where OB_ID_SLO_TYP = 102 and OB_AKTYWNY = 1

INSERT INTO [dbo].[UPRAWNIENIA]
           ([UPR_ID_UZYTKOWNIK]
           ,[UPR_ID_OBIEKT]
           ,[UPR_WIDOCZNOSC]
           ,[UPR_ZARZADZANIE]
  )
  select UPHID,KLIENTID, 1,1  from dbo.OBIEKT
  inner join dbo.OBIEKT_RELACJA on OBR_ID_OB2 = OB_ID and OBR_ID_SLO_TYP = @TypRelacji
  inner join dbo.TMP_KLIENT_PH_RKS on KLIENTID = OB_ID 
  left join dbo.UPRAWNIENIA on UPR_ID_UZYTKOWNIK = UPHID and KLIENTID = UPR_ID_OBIEKT
  where OB_ID_SLO_TYP = 102 and OB_AKTYWNY = 1 and (UPR_ID_OBIEKT is null)
  group by KLIENTID, UPHID 


INSERT INTO [dbo].[UPRAWNIENIA]
           ([UPR_ID_UZYTKOWNIK]
           ,[UPR_ID_OBIEKT]
           ,[UPR_WIDOCZNOSC]
           ,[UPR_ZARZADZANIE]
  )
  select URKSID, KLIENTID, 1, 1  from dbo.OBIEKT
  inner join dbo.OBIEKT_RELACJA on OBR_ID_OB2 = OB_ID and OBR_ID_SLO_TYP = @TypRelacji
  inner join dbo.TMP_KLIENT_PH_RKS on KLIENTID = OB_ID 
  left join dbo.UPRAWNIENIA on UPR_ID_UZYTKOWNIK = URKSID and KLIENTID = UPR_ID_OBIEKT
  where OB_ID_SLO_TYP = 102 and OB_AKTYWNY = 1 and (UPR_ID_OBIEKT is null)
  group by KLIENTID, URKSID
  
  
  
delete upr from UPRAWNIENIA upr
inner join dbo.UZYTKOWNIK on UZY_ID = UPR_ID_UZYTKOWNIK
left join TMP_KLIENT_PH_RKS on UPHID = UPR_ID_UZYTKOWNIK and KLIENTID = UPR_ID_OBIEKT
where UZY_AKTYWNY = 1 and UZY_ID_SLO_TYP in (703)  and (UPHID is null)


delete upr from UPRAWNIENIA upr
inner join dbo.UZYTKOWNIK on UZY_ID = UPR_ID_UZYTKOWNIK
left join TMP_KLIENT_PH_RKS on URKSID = UPR_ID_UZYTKOWNIK and KLIENTID = UPR_ID_OBIEKT
where UZY_AKTYWNY = 1 and UZY_ID_SLO_TYP in (702)  and (URKSID is null)



if exists (select * from dbo.sysobjects where id = object_id(N'dbo.TMP_KLIENT_PH_RKS') and OBJECTPROPERTY(id, N'IsTable') = 1)
  drop table dbo.TMP_KLIENT_PH_RKS;
