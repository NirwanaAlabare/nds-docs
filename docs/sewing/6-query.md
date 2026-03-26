---
title: Query
---

Beberapa query penting di modul Sewing.

## Detail Output

Untuk setiap output di sewing memiliki data inti yang menentukan identitas lengkap dari suatu produk dengan detail. Untuk mendapatkan data itu biasa digunakan query dibawah ini : 

```
select 
    act_costing.kpno, 
    act_costing.styleno, 
    so_det.color, 
    so_det.size, 
    output_rfts.created_by, 
    user_sb_wip.name as created_by_name, 
    userpassword.username as sewing_line, 
    output_rfts.created_at, 
    output_rfts.updated_at 
from 
    output_rfts 
    left join so_det on so_det.id = output_rfts.so_det_id
    left join so on so.id = so_det.id_so 
    left join act_costing on act_costing.id = so.id_cost 
    left join user_sb_wip on user_sb_wip.id = output_rfts.created_by
    left join userpassword on userpassword.line_id = user_sb_wip.line_id 
order by 
    output_rfts.id desc
limit 
    100
```

## Daily Defect by Line, Style and Defect Type Query

Terkadang user akan meminta suatu data secara custom. Jika data yang diminta adalah data Defect yang di-Grouping berdasarkan **Line**, **Style** dan **Defect Type**. Bisa digunakan Query dibawah ini :

```
select 
    DATE(defect.updated_at),
    ms.Supplier,
    ac.styleno, 
    up.username, 
    COUNT(defect.id) total_defect,
    dt.id,
    dt.defect_type 
from output_defects defect
left join so_det sd on sd.id = defect.so_det_id 
left join so on so.id = sd.id_so 
left join act_costing ac on ac.id = so.id_cost 
left join mastersupplier ms on ms.Id_Supplier = ac.id_buyer
left join user_sb_wip usb on usb.id = defect.created_by 
left join userpassword up on up.line_id = usb.line_id 
left join output_defect_types dt on dt.id = defect.defect_type_id 
where defect.updated_at between '2025-01-01 00:00:00' and '2025-12-31 23:59:59'
group by 
    DATE(defect.updated_at),
    ms.Supplier, 
    ac.styleno,
    up.username,
    dt.id
order by 
    DATE(defect.updated_at) asc, 
    COUNT(defect.id) desc
```

Namun sebaiknya dibuat satu modul untuk generate report yang grouping-nya dapat diatur secara custom. Karena permintaan user biasanya mendadak dan format-nya tidak selalu sama.

## Tracking Daily Output by SO Detail

Untuk meng-track output sewing yang di-grouping berdasarkan Detail SO.

```
SELECT
    act_costing.kpno,
    act_costing.styleno,
    so_det.color,
    so_det.size,
    COALESCE ( userpassword.username, master_plan.sewing_line ) created_by, 
    coalesce( date( rfts.updated_at ), master_plan.tgl_plan ) tanggal,
    max( rfts.updated_at ) last_rft,
    count( rfts.id ) rft,
    master_plan.id master_plan_id,
    master_plan.id_ws master_plan_id_ws,
    rfts.so_det_id 
FROM
    output_rfts rfts
    INNER JOIN master_plan ON master_plan.id = rfts.master_plan_id 
    LEFT JOIN user_sb_wip ON user_sb_wip.id = rfts.created_by 
    LEFT JOIN userpassword ON userpassword.line_id = user_sb_wip.line_id 
    LEFT JOIN so_det ON so_det.id = rfts.so_det_id 
    LEFT JOIN so ON so.id = so_det.id_so 
    LEFT JOIN act_costing ON act_costing.id = so.id_cost 
WHERE
    rfts.updated_at  between '2026-03-18 00:00:00' and '2026-03-18 23:59:59'
    AND master_plan.tgl_plan  between '2026-03-08' and '2026-03-18'
GROUP BY
    master_plan.id_ws,
    master_plan.color,
    DATE ( rfts.updated_at ),
    COALESCE ( userpassword.username, master_plan.sewing_line ), 
    rfts.so_det_id 
```