drop table if exists #tabla
select To_ [To] ,From_ [From],Body,DateCreated,DateSent,DateUpdated,Status_,Direction into #tabla from Paso1 where convert(datetime,left(replace(DateCreated,'/','-'),19),103) >'2021-05-28 23:59:59' and Status_ not in('failed')
and (From_='whatsapp:+14157022948' or To_='whatsapp:+14157022948')
and From_ !='whatsapp:+5218261065393'

order by DateCreated,To_,From_ asc

select * from #tabla

select * from #tabla where Direction='inbound' and [From] !='whatsapp:+5218261065393'



select * from #tabla where Direction='inbound' and [From] !='whatsapp:+5218261065393' and Body='Si'