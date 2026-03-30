---
title: Reporting DC
---

Terdapat beberapa rekap dalam reporting di modul DC, diantaranya :

## Qty DC

Untuk mendapatkan qty dc in didapatkan rumus seperti berikut, seperti yang sebelumnya disebutkan di <u>**[Struktur Database](/docs/dc/2-struktur.md#1-dc_in_input-table)**</u> : 

```
dc_qty = qty_awal - qty_reject + qty_replace 
```

Karena stocker adalah qty per-panel maka untuk menghitung secara per-size harus digunakan grouping dalam query-nya.

```sql title='dc-in-qty.sql'
SELECT 
	GROUP_CONCAT(id_qr_stocker) as stockers,
	buyer,
	act_costing_ws,
	color,
	so_det_id,
	panel,
	panel_status,
	GROUP_CONCAT(nama_part) as nama_part,
	GROUP_CONCAT(part_status) as part_status,
	CASE WHEN panel_status = 'main' THEN COALESCE(qty_in_main, qty_in) ELSE MIN(qty_in) END as qty_in
FROM
	(
		SELECT
            UPPER(a.id_qr_stocker) id_qr_stocker,
            DATE_FORMAT(a.tgl_trans, '%d-%m-%Y') tgl_trans_fix,
            a.tgl_trans,
            s.act_costing_ws,
            s.color,
            p.buyer,
            p.style,
            p.panel,
            p.id part_id,
            p.panel_status,
            s.so_det_id,
            s.ratio,
            a.qty_awal,
            a.qty_reject,
            a.qty_replace,
            CONCAT(s.range_awal, ' - ', s.range_akhir) stocker_range,
            (a.qty_awal - a.qty_reject + a.qty_replace) qty_in_main,
            null qty_in,
            a.tujuan,
            a.lokasi,
            a.tempat,
            a.created_at,
            a.user,
            COALESCE(f.no_cut, fp.no_cut, '-') no_cut,
            COALESCE(msb.size, s.size) size,
            mp.nama_part,
            pd.id as part_detail_id,
            pd.part_status
		from
            dc_in_input a
            left join stocker_input s on a.id_qr_stocker = s.id_qr_stocker
            left join master_sb_ws msb on msb.id_so_det = s.so_det_id
            left join form_cut_input f on f.id = s.form_cut_id
            left join form_cut_reject fr on fr.id = s.form_reject_id
            left join form_cut_piece fp on fp.id = s.form_piece_id
            left join part_detail pd on s.part_detail_id = pd.id
            left join part p on pd.part_id = p.id
            left join master_part mp on mp.id = pd.master_part_id
		where
            a.tgl_trans between '2026-01-01' AND '2026-01-26' AND
            s.id is not null AND
            (s.cancel IS NULL OR s.cancel != 'y') and 
            pd.part_status = 'main'
		UNION ALL
		SELECT
            UPPER(a.id_qr_stocker) id_qr_stocker,
            DATE_FORMAT(a.tgl_trans, '%d-%m-%Y') tgl_trans_fix,
            a.tgl_trans,
            s.act_costing_ws,
            s.color,
            CASE WHEN pd.part_status = 'complement' THEN pcom.buyer ELSE p.buyer END as buyer,
            CASE WHEN pd.part_status = 'complement' THEN pcom.style ELSE p.style END as style,
            CASE WHEN pd.part_status = 'complement' THEN pcom.panel ELSE p.panel END as panel,
            CASE WHEN pd.part_status = 'complement' THEN pcom.id ELSE p.id  END as part_id,
            CASE WHEN pd.part_status = 'complement' THEN pcom.panel_status ELSE p.panel_status END as panel_status,
            s.so_det_id,
            s.ratio,
            a.qty_awal,
            a.qty_reject,
            a.qty_replace,
            CONCAT(s.range_awal, ' - ', s.range_akhir) stocker_range,
            null qty_in_main,
            (a.qty_awal - a.qty_reject + a.qty_replace) qty_in,
            a.tujuan,
            a.lokasi,
            a.tempat,
            a.created_at,
            a.user,
            COALESCE(f.no_cut, fp.no_cut, '-') no_cut,
            COALESCE(msb.size, s.size) size,
            mp.nama_part,
            pd.id as part_detail_id,
            pd.part_status
		from
            dc_in_input a
            left join stocker_input s on a.id_qr_stocker = s.id_qr_stocker
            left join master_sb_ws msb on msb.id_so_det = s.so_det_id
            left join form_cut_input f on f.id = s.form_cut_id
            left join form_cut_reject fr on fr.id = s.form_reject_id
            left join form_cut_piece fp on fp.id = s.form_piece_id
            left join part_detail pd on s.part_detail_id = pd.id
            left join part p on pd.part_id = p.id
            left join part_detail pdcom on pdcom.id = pd.from_part_detail
            left join part pcom on pcom.id = pdcom.part_id 
            left join master_part mp on mp.id = pd.master_part_id
		where
            a.tgl_trans between '2026-01-01' AND '2026-01-31' AND
            s.id is not null AND
            (s.cancel IS NULL OR s.cancel != 'y') and 
            (pd.part_status != 'main' OR pd.part_status IS NULL)
	) dc
group by 
	dc.part_id,
	dc.so_det_id,
	dc.stocker_range
```

**<u>[Download query dc per-size](/assets/others/query-dc-in.sql)</u>**

## Loading Line Qty

```sql
SELECT
    loading_stock.tanggal_loading,
    loading_line_plan.id,
    loading_line_plan.line_id,
    loading_stock.nama_line,
    loading_line_plan.act_costing_ws,
    loading_line_plan.style,
    loading_line_plan.color,
    loading_stock.size size,
    sum( loading_stock.qty ) loading_qty
FROM
    loading_line_plan
    LEFT JOIN (
        SELECT
            MAX(COALESCE ( loading_line.tanggal_loading, DATE ( loading_line.updated_at ) )) tanggal_loading,
            loading_line.loading_plan_id,
            loading_line.nama_line,
            (
                COALESCE ( dc_in_input.qty_awal, stocker_input.qty_ply_mod, stocker_input.qty_ply ) -
                ( COALESCE ( dc_in_input.qty_reject, 0 )) + ( COALESCE ( dc_in_input.qty_replace, 0 )) -
                ( COALESCE ( secondary_in_input.qty_reject, 0 )) + ( COALESCE ( secondary_in_input.qty_replace, 0 )) -
                ( COALESCE ( secondary_inhouse_input.qty_reject, 0 )) + (COALESCE ( secondary_inhouse_input.qty_replace, 0 ))
            ) qty_old,
            MIN(loading_line.qty) qty,
            trolley.id trolley_id,
            trolley.nama_trolley,
            stocker_input.so_det_id,
            COALESCE(master_sb_ws.size, stocker_input.size) size,
            master_size_new.urutan
        FROM
            loading_line
            LEFT JOIN stocker_input ON stocker_input.id = loading_line.stocker_id
            LEFT JOIN part_detail ON part_detail.id = stocker_input.part_detail_id
            LEFT JOIN dc_in_input ON dc_in_input.id_qr_stocker = stocker_input.id_qr_stocker
            LEFT JOIN secondary_in_input ON secondary_in_input.id_qr_stocker = stocker_input.id_qr_stocker
            LEFT JOIN secondary_inhouse_input ON secondary_inhouse_input.id_qr_stocker = stocker_input.id_qr_stocker
            LEFT JOIN trolley_stocker ON stocker_input.id = trolley_stocker.stocker_id
            LEFT JOIN trolley ON trolley.id = trolley_stocker.trolley_id
            LEFT JOIN master_sb_ws ON master_sb_ws.id_so_det = stocker_input.so_det_id
            LEFT JOIN master_size_new ON master_size_new.size = master_sb_ws.size
        WHERE
            loading_line.tanggal_loading >= '2026-01-01' AND
            loading_line.tanggal_loading <= '2026-01-19'
        GROUP BY
            stocker_input.form_cut_id,
            stocker_input.form_reject_id,
            stocker_input.form_piece_id,
            stocker_input.so_det_id,
            stocker_input.group_stocker,
            stocker_input.ratio,
            stocker_input.stocker_reject
        ORDER BY
            FIELD(part_detail.part_status, 'main', 'regular', 'complement') ASC
    ) loading_stock ON loading_stock.loading_plan_id = loading_line_plan.id
WHERE
    loading_stock.tanggal_loading IS NOT NULL
GROUP BY
    loading_stock.tanggal_loading,
    loading_line_plan.id,
    loading_stock.size
HAVING 
    loading_stock.tanggal_loading >= '2026-01-01' AND 
    loading_stock.tanggal_loading <= '2026-01-30' 
ORDER BY
    loading_stock.tanggal_loading,
    loading_line_plan.line_id,
    loading_line_plan.act_costing_ws,
    loading_line_plan.color,
    loading_stock.so_det_id,
    loading_stock.urutan
```

**<u>[Download loading qty query](/assets/others/loading-line.sql)</u>**

## Mutasi DC

Dan untuk kebutuhan reporting mutasinya digunakan query dc per-size dan part_detail. Klik **<u>[disini](/assets/others/dc-mutasi.sql)</u>** untuk mengunduh query mutasi dc. Query tersebut mencakup **semua transaksi di DC dari mulai DC In sampai ke Loading Line**.