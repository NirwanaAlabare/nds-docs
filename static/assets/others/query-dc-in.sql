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