---
title: Pemakaian Kain
---

# Pemakaian Kain

Pemakaian Kain didasarkan pada 3 jenis pemakaian. <b>Cutting</b>, <b>Piping</b> dan <b>Cutting Piece</b>. Semuanya memiliki cara perhitungan yang berbeda.

## Pemakaian Kain Cutting 

Pemakaian kain di cutting didapat dari data **<u>[form_cut_input_detail](/docs/cutting/2-struktur.md#form_cut_input_detail-table)</u>**. Dihitung berdasarkan hasil input user (*Meja*) yang nantinya dihitung dengan rumus yang sudah ditentukan, Modul cutting menampung pemakaian dengan unit **Meter/KGM**. Berikut query-nya : 

```sql title='pemakaian-cutting.sql'
SELECT 
    id_roll, 
    MAX(qty_in) qty_in, 
    SUM(total_pemakaian_roll) total_pemakaian_roll,
    MIN(sisa_kain) sisa_kain,
    SUM(short_roll) as short_roll,
    unit_roll
FROM (
    select
        COALESCE(b.qty) qty_in,
        a.waktu_mulai,
        a.waktu_selesai,
        b.id,
        DATE_FORMAT(b.created_at, '%M') bulan,
        DATE_FORMAT(b.created_at, '%d-%m-%Y') tgl_input,
        b.no_form_cut_input,
        UPPER(meja.name) nama_meja,
        cons_marker,
        a.cons_ampar,
        a.cons_act,
        (CASE WHEN a.cons_pipping > 0 THEN a.cons_pipping ELSE mrk.cons_piping END) cons_piping,
        panjang_marker,
        unit_panjang_marker,
        comma_marker,
        unit_comma_marker,
        lebar_marker,
        unit_lebar_marker,
        a.p_act panjang_actual,
        a.unit_p_act unit_panjang_actual,
        a.comma_p_act comma_actual,
        a.unit_comma_p_act unit_comma_actual,
        a.l_act lebar_actual,
        a.unit_l_act unit_lebar_actual,
        COALESCE(b.id_roll, '-') id_roll,
        b.id_item,
        b.detail_item,
        COALESCE(b.roll_buyer, b.roll) roll,
        COALESCE(b.lot, '-') lot,
        COALESCE(b.group_roll, '-') group_roll,
        (
                CASE WHEN
                        b.status != 'extension' AND b.status != 'extension complete'
                THEN
                        (CASE WHEN COALESCE(scanned_item.qty_in, b.qty) > b.qty AND c.id IS NULL THEN 'Sisa Kain' ELSE 'Roll Utuh' END)
                ELSE
                        'Sambungan'
                END
        ) status_roll,
        COALESCE(c.qty, b.qty) qty_awal,
        b.qty qty_roll,
        b.unit unit_roll,
        COALESCE(b.berat_amparan, '-') berat_amparan,
        b.est_amparan,
        b.lembar_gelaran,
        mrk.total_ratio,
        (mrk.total_ratio * b.lembar_gelaran) qty_cut,
        b.average_time,
        b.sisa_gelaran,
        b.sambungan,
        b.sambungan_roll,
        b.kepala_kain,
        b.sisa_tidak_bisa,
        b.reject,
        b.piping,
        ROUND(MIN(CASE WHEN b.status != 'extension' AND b.status != 'extension complete' THEN (b.sisa_kain) ELSE (b.qty - b.total_pemakaian_roll) END), 2) sisa_kain,
		CASE WHEN b.status = 'extension' OR b.status = 'extension complete' THEN null ELSE ROUND((CASE WHEN b.status != 'extension complete' THEN ((CASE WHEN b.unit = 'KGM' THEN b.berat_amparan ELSE a.p_act + (a.comma_p_act/100) END) * b.lembar_gelaran) ELSE b.sambungan END) + (b.sisa_gelaran + COALESCE(c.sisa_gelaran, 0)) + (b.sambungan_roll + COALESCE(c.sisa_gelaran, 0)) + (CASE WHEN c.id is null THEN 0 ELSE c.sambungan END), 2) END pemakaian_lembar,
		CASE WHEN b.status = 'extension' OR b.status = 'extension complete' THEN null ELSE ROUND(ROUND((CASE WHEN b.status != 'extension complete' THEN ((CASE WHEN b.unit = 'KGM' THEN b.berat_amparan ELSE a.p_act + (a.comma_p_act/100) END) * b.lembar_gelaran) ELSE b.sambungan END) + (b.sisa_gelaran + COALESCE(c.sisa_gelaran, 0)) + (b.sambungan_roll + COALESCE(c.sisa_gelaran, 0)) + (CASE WHEN c.id is null THEN 0 ELSE c.sambungan END), 2) + (b.kepala_kain + COALESCE(c.kepala_kain, 0)) + (b.sisa_tidak_bisa + COALESCE(c.sisa_tidak_bisa, 0)) + (b.reject + COALESCE(c.reject, 0)) + (b.piping + COALESCE(c.piping, 0)), 2) END total_pemakaian_roll,
		CASE WHEN b.status = 'extension' OR b.status = 'extension complete' THEN null ELSE (CASE WHEN c.id IS NULL THEN round(((ROUND(ROUND((CASE WHEN b.status != 'extension complete' THEN ((CASE WHEN b.unit = 'KGM' THEN b.berat_amparan ELSE a.p_act + (a.comma_p_act/100) END) * b.lembar_gelaran) ELSE b.sambungan END) + (b.sisa_gelaran + COALESCE(c.sisa_gelaran, 0)) + (b.sambungan_roll + COALESCE(c.sisa_gelaran, 0)) + (CASE WHEN c.id is null THEN 0 ELSE c.sambungan END), 2) + (b.kepala_kain + COALESCE(c.kepala_kain, 0)) + (b.sisa_tidak_bisa + COALESCE(c.sisa_tidak_bisa, 0)) + (b.reject + COALESCE(c.reject, 0)) + (b.piping + COALESCE(c.piping, 0)), 2)+b.sisa_kain)-b.qty), 2) ELSE round(((ROUND(ROUND((CASE WHEN b.status != 'extension complete' THEN ((CASE WHEN b.unit = 'KGM' THEN b.berat_amparan ELSE a.p_act + (a.comma_p_act/100) END) * b.lembar_gelaran) ELSE b.sambungan END) + (b.sisa_gelaran + COALESCE(c.sisa_gelaran, 0)) + (b.sambungan_roll + COALESCE(c.sisa_gelaran, 0)) + (CASE WHEN c.id is null THEN 0 ELSE c.sambungan END), 2) + (b.kepala_kain + COALESCE(c.kepala_kain, 0)) + (b.sisa_tidak_bisa + COALESCE(c.sisa_tidak_bisa, 0)) + (b.reject + COALESCE(c.reject, 0)) + (b.piping + COALESCE(c.piping, 0)), 2)+b.sisa_kain)-c.qty), 2) END) END short_roll,
		CASE WHEN b.status = 'extension' OR b.status = 'extension complete' THEN null ELSE (CASE WHEN c.id IS NULL THEN (round((CASE WHEN c.id IS NULL THEN round(((ROUND(ROUND((CASE WHEN b.status != 'extension complete' THEN ((CASE WHEN b.unit = 'KGM' THEN b.berat_amparan ELSE a.p_act + (a.comma_p_act/100) END) * b.lembar_gelaran) ELSE b.sambungan END) + (b.sisa_gelaran + COALESCE(c.sisa_gelaran, 0)) + (b.sambungan_roll + COALESCE(c.sisa_gelaran, 0)) + (CASE WHEN c.id is null THEN 0 ELSE c.sambungan END), 2) + (b.kepala_kain + COALESCE(c.kepala_kain, 0)) + (b.sisa_tidak_bisa + COALESCE(c.sisa_tidak_bisa, 0)) + (b.reject + COALESCE(c.reject, 0)) + (b.piping + COALESCE(c.piping, 0)), 2)+b.sisa_kain)-b.qty), 2) ELSE round(((ROUND(ROUND((CASE WHEN b.status != 'extension complete' THEN ((CASE WHEN b.unit = 'KGM' THEN b.berat_amparan ELSE a.p_act + (a.comma_p_act/100) END) * b.lembar_gelaran) ELSE b.sambungan END) + (b.sisa_gelaran + COALESCE(c.sisa_gelaran, 0)) + (b.sambungan_roll + COALESCE(c.sisa_gelaran, 0)) + (CASE WHEN c.id is null THEN 0 ELSE c.sambungan END), 2) + (b.kepala_kain + COALESCE(c.kepala_kain, 0)) + (b.sisa_tidak_bisa + COALESCE(c.sisa_tidak_bisa, 0)) + (b.reject + COALESCE(c.reject, 0)) + (b.piping + COALESCE(c.piping, 0)), 2)+b.sisa_kain)-c.qty), 2) END)/b.qty*100)) ELSE (round((CASE WHEN c.id IS NULL THEN round(((ROUND(ROUND((CASE WHEN b.status != 'extension complete' THEN ((CASE WHEN b.unit = 'KGM' THEN b.berat_amparan ELSE a.p_act + (a.comma_p_act/100) END) * b.lembar_gelaran) ELSE b.sambungan END) + (b.sisa_gelaran + COALESCE(c.sisa_gelaran, 0)) + (b.sambungan_roll + COALESCE(c.sisa_gelaran, 0)) + (CASE WHEN c.id is null THEN 0 ELSE c.sambungan END), 2) + (b.kepala_kain + COALESCE(c.kepala_kain, 0)) + (b.sisa_tidak_bisa + COALESCE(c.sisa_tidak_bisa, 0)) + (b.reject + COALESCE(c.reject, 0)) + (b.piping + COALESCE(c.piping, 0)), 2)+b.sisa_kain)-b.qty), 2) ELSE round(((ROUND(ROUND((CASE WHEN b.status != 'extension complete' THEN ((CASE WHEN b.unit = 'KGM' THEN b.berat_amparan ELSE a.p_act + (a.comma_p_act/100) END) * b.lembar_gelaran) ELSE b.sambungan END) + (b.sisa_gelaran + COALESCE(c.sisa_gelaran, 0)) + (b.sambungan_roll + COALESCE(c.sisa_gelaran, 0)) + (CASE WHEN c.id is null THEN 0 ELSE c.sambungan END), 2) + (b.kepala_kain + COALESCE(c.kepala_kain, 0)) + (b.sisa_tidak_bisa + COALESCE(c.sisa_tidak_bisa, 0)) + (b.reject + COALESCE(c.reject, 0)) + (b.piping + COALESCE(c.piping, 0)), 2)+b.sisa_kain)-c.qty), 2) END)/c.qty*100, 2)) END) END short_roll_percentage,
        b.status,
        a.operator,
        a.tipe_form_cut,
        b.created_at,
        b.updated_at
    from
        form_cut_input a
        left join form_cut_input_detail b on a.id = b.form_cut_id
        left join form_cut_input_detail c ON c.form_cut_id = b.form_cut_id and c.id_roll = b.id_roll and (c.status = 'extension' OR c.status = 'extension complete')
        left join users meja on meja.id = a.no_meja
        left join (SELECT marker_input.*, SUM(marker_input_detail.ratio) total_ratio FROM marker_input LEFT JOIN marker_input_detail ON marker_input_detail.marker_id = marker_input.id GROUP BY marker_input.id) mrk on a.id_marker = mrk.kode
        left join (SELECT * FROM master_sb_ws GROUP BY id_act_cost) master_sb_ws on master_sb_ws.id_act_cost = mrk.act_costing_id
        left join scanned_item on scanned_item.id_roll = b.id_roll
    where
        (a.cancel = 'N'  OR a.cancel IS NULL)
        AND (mrk.cancel = 'N'  OR mrk.cancel IS NULL)
        AND a.status = 'SELESAI PENGERJAAN'
        and b.status != 'not complete'
        and b.id_item is not null
        AND a.tgl_form_cut >= DATE(NOW()-INTERVAL 6 MONTH)
        AND b.created_at >= DATE(NOW()-INTERVAL 6 MONTH)
        and b.created_at >= '2026-01-12 00:00:00' and b.created_at <= '2026-01-14 23:59:59'
    group by
        b.id
) cutting
where cutting.id_roll is not null and cutting.id_roll != '-' 
group by 
    id_roll
```

Query diatas merupakan query untuk mengambil data pemakaian kain dari modul cutting, dengan kolom **qty_in sebagai Qty yang masuk ke Cutting**, **total_pemakaian_roll sebagai Qty yang digunakan Cutting**, **sisa_kain sebagai sisa dari Kain (*Roll*) yang sudah dipakai Cutting** dan **short_roll sebagai selisih dari total_pemakaian_roll dan sisa_kain dengan qty_in**. Dan id_roll sebagai dasar dan identitas dari pemakaian <code>group by id_roll</code>. **<u><a href="/assets/others/pemakaian-cutting.sql" download>Download Pemakaian Cutting Query</a></u>**.

## Pemakaian Kain Piping 

Pemakaian kain di piping didapat dari data **<u>[form_cut_piping](/docs/cutting/2-struktur.md#piping)</u>**. Berikut query-nya : 

```sql title='pemakaian-piping.sql'
SELECT 
	id_roll, 
	MAX(qty_in) qty_in, 
	SUM(total_pemakaian_roll) total_pemakaian_roll,
	MIN(sisa_kain) sisa_kain,
	SUM(short_roll) as short_roll,
	unit_roll
FROM (
	select
		COALESCE(form_cut_piping.qty) qty_in,
		form_cut_piping.created_at waktu_mulai,
		form_cut_piping.updated_at waktu_selesai,
		form_cut_piping.id,
		DATE_FORMAT(form_cut_piping.created_at, '%M') bulan,
		DATE_FORMAT(form_cut_piping.created_at, '%d-%m-%Y') tgl_input,
		'PIPING' no_form_cut_input,
		'-' nama_meja,
		form_cut_piping.act_costing_ws,
		master_sb_ws.buyer,
		form_cut_piping.style,
		form_cut_piping.color,
		form_cut_piping.color color_act,
		form_cut_piping.panel,
		master_sb_ws.qty,
		'0' cons_ws,
		0 cons_marker,
		'0' cons_ampar,
		0 cons_act,
		form_cut_piping.cons_piping cons_piping,
		0 panjang_marker,
		'-' unit_panjang_marker,
		0 comma_marker,
		'-' unit_comma_marker,
		0 lebar_marker,
		'-' unit_lebar_marker,
		0 panjang_actual,
		'-' unit_panjang_actual,
		0 comma_actual,
		'-' unit_comma_actual,
		0 lebar_actual,
		'-' unit_lebar_actual,
		form_cut_piping.id_roll,
		scanned_item.id_item,
		scanned_item.detail_item,
		COALESCE(scanned_item.roll_buyer, scanned_item.roll) roll,
		scanned_item.lot,
		'-' group_roll,
		'Piping' status_roll,
		COALESCE(scanned_item.qty_in, form_cut_piping.qty) qty_awal,
		form_cut_piping.qty qty_roll,
		form_cut_piping.unit unit_roll,
		0 berat_amparan,
		0 est_amparan,
		0 lembar_gelaran,
		0 total_ratio,
		0 qty_cut,
		'00:00' average_time,
		'0' sisa_gelaran,
		0 sambungan,
		0 sambungan_roll,
		0 kepala_kain,
		0 sisa_tidak_bisa,
		0 reject,
		form_cut_piping.piping piping,
		form_cut_piping.qty_sisa sisa_kain,
		form_cut_piping.piping pemakaian_lembar,
		form_cut_piping.piping total_pemakaian_roll,
		ROUND((form_cut_piping.piping + form_cut_piping.qty_sisa) - form_cut_piping.qty, 2) short_roll,
		ROUND(((form_cut_piping.piping + form_cut_piping.qty_sisa) - form_cut_piping.qty)/coalesce(scanned_item.qty_in, form_cut_piping.qty) * 100, 2) short_roll_percentage,
		null `status`,
		form_cut_piping.operator,
		'PIPING' tipe_form_cut,
		form_cut_piping.created_at,
		form_cut_piping.updated_at
	from
		form_cut_piping
		left join (SELECT * FROM master_sb_ws GROUP BY id_act_cost) master_sb_ws on master_sb_ws.id_act_cost = form_cut_piping.act_costing_id
		left join scanned_item on scanned_item.id_roll = form_cut_piping.id_roll
	where
		id_item is not null
		and form_cut_piping.created_at >= '2026-01-12 00:00:00' and form_cut_piping.created_at <= '2026-01-14 23:59:59'
	group by
		form_cut_piping.id
) cutting
where cutting.id_roll is not null and cutting.id_roll != '-' 
group by 
	id_roll
```

Query diatas merupakan query untuk mengambil data pemakaian kain dari modul piping, berdasarkan id_roll <code>group by id_roll</code>. **<u><a href="/assets/others/pemakaian-piping.sql" download>Download Pemakaian Piping Query</a></u>**.

## Pemakaian Kain Cutting Piece 

Pemakaian kain di piping didapat dari data form_cut_piece. Berikut query-nya : 

```sql title='pemakaian-cutting-piece.sql'
SELECT 
	id_roll, 
	MAX(qty_in) qty_in, 
	SUM(total_pemakaian_roll) total_pemakaian_roll,
	MIN(sisa_kain) sisa_kain,
	SUM(short_roll) as short_roll,
	unit_roll
FROM (
	SELECT 
		form_cut_piece_detail.qty qty_in,
		form_cut_piece.created_at waktu_mulai,
		form_cut_piece.updated_at waktu_selesai,
		form_cut_piece.id,
		DATE_FORMAT( form_cut_piece.created_at, '%M' ) bulan,
		DATE_FORMAT( form_cut_piece.created_at, '%d-%m-%Y' ) tgl_input,
		form_cut_piece.no_form no_form_cut_input,
		'-' nama_meja,
		form_cut_piece.act_costing_ws,
		master_sb_ws.buyer,
		form_cut_piece.style,
		form_cut_piece.color,
		form_cut_piece.color color_act,
		form_cut_piece.panel,
		master_sb_ws.qty,
		form_cut_piece.cons_ws cons_ws,
		form_cut_piece.cons_ws cons_marker,
		'0' cons_ampar,
		0 cons_act,
		0 cons_piping,
		0 panjang_marker,
		'-' unit_panjang_marker,
		0 comma_marker,
		'-' unit_comma_marker,
		0 lebar_marker,
		'-' unit_lebar_marker,
		0 panjang_actual,
		'-' unit_panjang_actual,
		0 comma_actual,
		'-' unit_comma_actual,
		0 lebar_actual,
		'-' unit_lebar_actual,
		form_cut_piece_detail.id_roll,
		scanned_item.id_item,
		scanned_item.detail_item,
		COALESCE ( scanned_item.roll_buyer, scanned_item.roll ) roll,
		scanned_item.lot,
		'-' group_roll,
		( CASE WHEN form_cut_piece_detail.qty >= COALESCE ( scanned_item.qty_in, 0 ) THEN 'Roll Utuh' ELSE 'Sisa Kain' END ) status_roll,
		COALESCE ( scanned_item.qty_in, form_cut_piece_detail.qty ) qty_awal,
		form_cut_piece_detail.qty qty_roll,
		form_cut_piece_detail.qty_unit unit_roll,
		0 berat_amparan,
		0 est_amparan,
		0 lembar_gelaran,
		0 total_ratio,
		0 qty_cut,
		'00:00' average_time,
		'0' sisa_gelaran,
		0 sambungan,
		0 sambungan_roll,
		0 kepala_kain,
		0 sisa_tidak_bisa,
		0 reject,
		0 piping,
		form_cut_piece_detail.qty_sisa sisa_kain,
		form_cut_piece_detail.qty_pemakaian pemakaian_lembar,
		form_cut_piece_detail.qty_pemakaian total_pemakaian_roll,
		ROUND(form_cut_piece_detail.qty - ( form_cut_piece_detail.qty_pemakaian + form_cut_piece_detail.qty_sisa )) short_roll,
		ROUND((form_cut_piece_detail.qty - ( form_cut_piece_detail.qty_pemakaian + form_cut_piece_detail.qty_sisa ))/ COALESCE ( scanned_item.qty_in, form_cut_piece_detail.qty ) * 100, 2 ) short_roll_percentage,
		form_cut_piece_detail.STATUS `status`,
		form_cut_piece.employee_name,
		'PCS' tipe_form_cut,
		form_cut_piece.created_at,
		form_cut_piece.updated_at 
	FROM
		form_cut_piece
		LEFT JOIN form_cut_piece_detail ON form_cut_piece_detail.form_id = form_cut_piece.id
		LEFT JOIN ( SELECT * FROM master_sb_ws GROUP BY id_act_cost ) master_sb_ws ON master_sb_ws.id_act_cost = form_cut_piece.act_costing_id
		LEFT JOIN scanned_item ON scanned_item.id_roll = form_cut_piece_detail.id_roll 
	WHERE
		scanned_item.id_item IS NOT NULL 
		AND form_cut_piece_detail.STATUS = 'complete' 
	GROUP BY
		form_cut_piece_detail.id
) cutting
where cutting.id_roll is not null and cutting.id_roll != '-' 
group by 
	id_roll
```

Query diatas merupakan query untuk mengambil data pemakaian kain dari modul form cutting piece, berdasarkan id_roll <code>group by id_roll</code>. **<u><a href="/assets/others/pemakaian-cutting-piece.sql" download>Download Pemakaian Cutting Piece Query</a></u>**.