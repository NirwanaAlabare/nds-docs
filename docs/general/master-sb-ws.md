---
title: Master SB WS
---

**Laravel NDS** memiliki satu tabel yang dibuat untuk menampung data master order hingga detailnya dari **signalbit**. Datanya perlu disinkronkan secara rutin. 

## Pentaho Data Integration ( PDI )

Untuk menyinkronkan data **signalbit_erp** ke database lokal di **laravel_nds.master_sb_ws**, sebagai penampung data Order (WS) beserta detail-nya, (Color, Size, Destination). 

![PDI](/assets/images/pdi.png)

Menggunakan query berikut sebagai dasar : 

```sql master-sb-ws.sql
select
    ac.id id_act_cost,
    ac.kpno as ws,
    ac.cost_no,
    ac.deldate tgl_kirim,
    ac.styleno,
    ac.main_dest,
    ac.brand,
    so.so_no,
    mb.supplier buyer,
    sd.id id_so_det,
    sd.dest,
    sd.color,
    sd.size,
    sd.qty,
    sd.price,
    sd.reff_no,
    sd.styleno_prod,
    mp.product_group,
    mp.product_item,
    ac.curr
from signalbit_erp.jo_det jd
inner join signalbit_erp.so on jd.id_so = so.id
inner join signalbit_erp.act_costing ac on so.id_cost = ac.id
inner join signalbit_erp.so_det sd on so.id = sd.id_so
inner join signalbit_erp.mastersupplier mb on ac.id_buyer = mb.id_supplier
left join signalbit_erp.masterproduct mp on ac.id_product = mp.id
where
    jd.cancel = 'N' and ac.cost_date >= '2019-01-01' and ac.type_ws = 'STD'
UNION
select
    ac.id id_act_cost,
    ac.kpno as ws,
    ac.cost_no,
    ac.deldate tgl_kirim,
    ac.styleno,
    ac.main_dest,
    ac.brand,
    so.so_no,
    mb.supplier buyer,
    sd.id id_so_det,
    sd.dest,
    sd.color,
    sd.size,
    sd.qty,
    sd.price,
    sd.reff_no,
    sd.styleno_prod,
    mp.product_group,
    mp.product_item,
    ac.curr
from
(select so.*,jd.id_so from signalbit_erp.so left join signalbit_erp.jo_det jd on so.id = jd.id_so where jd.id_so is null) so
inner join signalbit_erp.act_costing ac on so.id_cost = ac.id
inner join signalbit_erp.so_det sd on so.id = sd.id_so
inner join signalbit_erp.mastersupplier mb on ac.id_buyer = mb.id_supplier
left join signalbit_erp.masterproduct mp on ac.id_product = mp.id
where
    ac.cost_date >= '2019-01-01' and ac.type_ws = 'STD'
order by
    tgl_kirim desc, ws asc
```
**<u><a href="/assets/others/master-sb-ws.sql" download>Download Query Master SB WS</a></u>**

PDI akan menarik data dari query diatas lalu disimpan ke tabel yang dituju yaitu **laravel_nds.master_sb_ws**, dengan metode **scheduler/jadwal**, Saat ini PDI diatur agar mengupdate data setiap 3 jam sekali.

## User Action

Jika user ingin mengeksekusi (meng-update) data **master_sb_ws**, user bisa mengakses ```Home -> General Tools```

![Home](/assets/images/home-general-tools.png) 

Lalu Klik **Update Master SB**.

![General Tools](/assets/images/general-tools.png) 