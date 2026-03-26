---
title: Report Sewing
---

Report yang sering dilihat di Modul Sewing

## Report Efficiency

User seringkali mengecek report efficiency sebagai dasar dari data output harian.

![Report Efficiency View](/assets/images/sewing-module/report-efficiency.png)

Untuk letak kodenya ada di ```app\Http\Controllers\Sewing\ReportEfficiencyNewController.php``` di function ```index()```. Dan untuk export excel ada di ```app\Exports\Report_eff_new_export.php```. Dengan query yang digunakan sebagai berikut :

```
SELECT
    a.tgl_trans,
    concat((DATE_FORMAT(a.tgl_trans,  '%d')), '-',left(DATE_FORMAT(a.tgl_trans,  '%M'),3),'-',DATE_FORMAT(a.tgl_trans,  '%Y')) tgl_trans_fix,
    concat((DATE_FORMAT(mp.tgl_plan,  '%d')), '-',left(DATE_FORMAT(mp.tgl_plan,  '%M'),3),'-',DATE_FORMAT(mp.tgl_plan,  '%Y')) tgl_plan_fix,
    ul.username sewing_line,
    ms.supplier buyer,
    ac.kpno,
    ac.styleno,
    mp.color,
    mp.id,
    mp.smv,
    mp.man_power man_power_ori,
    cmp.man_power,
    mp.jam_kerja_awal,
    istirahat,
    op.jam_akhir_input_line,
    round(TIME_TO_SEC(TIMEDIFF(TIMEDIFF(jam_akhir_input_line, istirahat), mp.jam_kerja_awal)) / 3600,2) AS jam_kerja_act_line,
    round(((((sum(a.tot_output) / op.tot_output_line) * (TIME_TO_SEC(TIMEDIFF(TIMEDIFF(jam_akhir_input_line, istirahat), mp.jam_kerja_awal)) / 3600)) * 60) * cmp.man_power) / mp.smv) target,
    sum(a.tot_output) tot_output,
    sum(d_rfts.tot_rfts) tot_rfts,
    op.tot_output_line,
    so.curr,
    CASE when so.curr = 'IDR' THEN if(acm.jenis_rate = 'J', acm.price * COALESCE(konv_sb.rate_jual, last_konv_sb.rate_jual), acm.price)
    ELSE acm.price end AS cm_price,
    round(
    sum(a.tot_output) * CASE when so.curr = 'IDR' THEN if(acm.jenis_rate = 'J', acm.price * COALESCE(konv_sb.rate_jual, last_konv_sb.rate_jual), acm.price)
    ELSE acm.price end,2) AS earning,
    COALESCE(mr.kurs_tengah,mkb.kurs_tengah) kurs_tengah,
    round(
    if (so.curr = 'IDR',
    sum(a.tot_output) * CASE when so.curr = 'IDR' THEN if(acm.jenis_rate = 'J', acm.price * COALESCE(konv_sb.rate_jual, last_konv_sb.rate_jual), acm.price)
    ELSE acm.price end,
    sum(a.tot_output) * CASE when so.curr = 'IDR' THEN if(acm.jenis_rate = 'J', acm.price * COALESCE(konv_sb.rate_jual, last_konv_sb.rate_jual), acm.price)
    ELSE acm.price end * COALESCE(mr.kurs_tengah,mkb.kurs_tengah)
    ),2) tot_earning_rupiah,
    round((cmp.man_power * (sum(a.tot_output) / op.tot_output_line) * (TIME_TO_SEC(TIMEDIFF(TIMEDIFF(jam_akhir_input_line, istirahat), mp.jam_kerja_awal)) / 3600) * 60),2) mins_avail,
    round(sum(a.tot_output) * mp.smv,2) mins_prod,
    round((((sum(a.tot_output) * mp.smv) / ( (cmp.man_power * (sum(a.tot_output) / op.tot_output_line) * (TIME_TO_SEC(TIMEDIFF(TIMEDIFF(jam_akhir_input_line, istirahat), mp.jam_kerja_awal)) / 3600) * 60)))*100),2) eff_line,
    round(((sum(a.tot_output) / op.tot_output_line) * (TIME_TO_SEC(TIMEDIFF(TIMEDIFF(jam_akhir_input_line, istirahat), mp.jam_kerja_awal)) / 3600)),2) jam_kerja_act,
    round((sum(d_rfts.tot_rfts) / sum(a.tot_output)) * 100,2) rfts
from
(
    select
    date(a.updated_at)tgl_trans,
    so_det_id,
    master_plan_id,
    count(so_det_id) tot_output,
    time(max(a.updated_at)) jam_akhir_input,
    userpassword.username
    from output_rfts a
    left join user_sb_wip on user_sb_wip.id = a.created_by
    left join userpassword on userpassword.line_id = user_sb_wip.line_id
    where a.updated_at >= '$start_date' and a.updated_at <= '$end_date'
    group by master_plan_id, userpassword.username, date(a.updated_at)
) a
inner join so_det sd on a.so_det_id = sd.id
inner join so on sd.id_so = so.id
inner join act_costing ac on so.id_cost = ac.id
inner join userpassword ul on ul.username = a.username
inner join master_plan mp on a.master_plan_id = mp.id
inner join mastersupplier ms on ac.id_buyer = ms.Id_Supplier
left join (
    select date(output_rfts.updated_at) tgl_trans_line,max(time(output_rfts.updated_at)) jam_akhir_input_line,count(output_rfts.so_det_id) tot_output_line,
            case
            when time(max(output_rfts.updated_at)) >= '12:00:00' and time(max(output_rfts.updated_at)) <= '18:44:59' THEN '01:00:00'
            when time(max(output_rfts.updated_at)) <= '12:00:00'  THEN '00:00:00'
            when time(max(output_rfts.updated_at)) >= '18:45:00'  THEN '01:30:00'
            END as istirahat,
    userpassword.username
    from output_rfts
    left join user_sb_wip on user_sb_wip.id = output_rfts.created_by
    left join userpassword on userpassword.line_id = user_sb_wip.line_id
    where output_rfts.updated_at >= '$start_date' and output_rfts.updated_at <= '$end_date' group by userpassword.username, date(output_rfts.updated_at)
) op on a.tgl_trans = op.tgl_trans_line and ul.username = op.username
left join (
    select * from act_costing_mfg where id_item = '8' group by id_act_cost
) acm on ac.id = acm.id_act_cost
left join (
    select * from masterrate where  curr='USD' and v_codecurr IN('COSTING3','COSTING6','COSTING8','COSTING12') group by tanggal
) konv_sb on ac.deldate = konv_sb.tanggal
left join (
    select * from masterrate where  curr='USD' and v_codecurr IN('COSTING3','COSTING6','COSTING8','COSTING12') group by tanggal ORDER BY tanggal DESC limit 1
) last_konv_sb on ac.deldate >= last_konv_sb.tanggal
left join (
    SELECT
            master_plan_id,
            tgl_trans_rfts,
            sum(tot_rfts)tot_rfts
    from
    (
            select
            date(a.updated_at)tgl_trans_rfts,
            master_plan_id,
            count(so_det_id) tot_rfts,
            userpassword.username
            from output_rfts a
            left join user_sb_wip on user_sb_wip.id = a.created_by
            left join userpassword on userpassword.line_id = user_sb_wip.line_id
            where a.updated_at >= '$start_date' and a.updated_at <= '$end_date' and status = 'NORMAL'
            group by master_plan_id, userpassword.username, date(a.updated_at)
    ) a
    inner join master_plan mp on a.master_plan_id = mp.id
    group by tgl_trans_rfts, master_plan_id
) d_rfts on a.tgl_trans = d_rfts.tgl_trans_rfts and a.master_plan_id = d_rfts.master_plan_id
left join
(
    select min(id), man_power, sewing_line, tgl_plan from master_plan
    where tgl_plan >= '$tgl_awal_n' and  tgl_plan <= '$tgl_akhir_n' and cancel = 'N'
    group by sewing_line, tgl_plan
) cmp on a.tgl_trans = cmp.tgl_plan and ul.username = cmp.sewing_line

-- Kurs join for pre-MySQL 8
LEFT JOIN (
    SELECT x.tgl_trans, x.max_kurs_date, k.kurs_tengah
    FROM (
            SELECT a_dates.tgl_trans, MAX(mkb.tanggal_kurs_bi) AS max_kurs_date
            FROM (
                    SELECT DISTINCT date(updated_at) AS tgl_trans
                    FROM output_rfts
                    WHERE updated_at >= '$start_date' AND updated_at <= '$end_date'
            ) a_dates
            JOIN master_kurs_bi mkb
            ON mkb.tanggal_kurs_bi <= a_dates.tgl_trans
            GROUP BY a_dates.tgl_trans
    ) x
    JOIN master_kurs_bi k
    ON k.tanggal_kurs_bi = x.max_kurs_date
) mkb ON a.tgl_trans = mkb.tgl_trans

LEFT JOIN (
    SELECT x.tgl_trans, x.max_kurs_date, k.rate as kurs_tengah
    FROM (
        SELECT a_dates.tgl_trans, MAX(mr.tanggal) AS max_kurs_date
        FROM (
            SELECT DISTINCT date(updated_at) AS tgl_trans
            FROM output_rfts
            WHERE updated_at >= '$start_date' AND updated_at <= '$end_date'
        ) a_dates
        JOIN masterrate mr
        ON mr.tanggal <= a_dates.tgl_trans
        GROUP BY a_dates.tgl_trans
    ) x
    JOIN masterrate k
    ON k.tanggal = x.max_kurs_date
    WHERE k.v_codecurr = 'HARIAN'
) mr ON a.tgl_trans = mr.tgl_trans

group by ul.username, ac.kpno, ac.Styleno, a.tgl_trans
order by a.tgl_trans asc, ul.username asc, ac.kpno asc;
```

Query ini merupakan dasar untuk mendapatkan output.

## Track Order Output

Untuk mendapatkan data output secara detail atau dengan grouping daily-line-ws-style-color-size

![Track Order Output](/assets/images/sewing-module/track-order-output.png)

Dikarenakan mengambil data secara detail, modul ini memiliki kelemahan, yaitu ketika menarik banyak data performa-nya akan drop ditambah modul ini menggunakan livewire yang performanya agak kurang. Query dasar yang digunakan :

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

Untuk letak kodenya ada di ```app\Http\Livewire\Sewing\TrackOrderOutput.php``` di function ```index()```. Dan untuk export excel ada di ```app\Exports\Sewing\OrderOutputExport.php```. 