WITH dc_saldo_awal AS (
	-- saldo awal 
	SELECT 
		CURRENT_DATE as tanggal,
		stockers,
		buyer,
		act_costing_ws,
		color,
		so_det_id,
		panel,
		panel_status,
		part_detail_id,
		nama_part,
		part_status, 
		0 saldo_awal,
		qty_in,
		kirim_secondary_dalam,
		terima_repaired_secondary_dalam,
		terima_good_secondary_dalam,
		kirim_secondary_luar,
		terima_repaired_secondary_luar,
		terima_good_secondary_luar,
		loading_qty,
		qty_in-kirim_secondary_dalam+terima_repaired_secondary_dalam+terima_good_secondary_dalam-kirim_secondary_luar+terima_repaired_secondary_luar+terima_good_secondary_luar-loading_qty saldo_akhir,
		CURRENT_TIMESTAMP created_at,
		CURRENT_TIMESTAMP updated_at
	FROM (
		SELECT 
			GROUP_CONCAT(dc.id_qr_stocker) as stockers,
			dc.buyer,
			dc.act_costing_ws,
			dc.color,
			dc.so_det_id,
			dc.panel,
			dc.panel_status,
			dc.part_detail_id,
			GROUP_CONCAT(dc.nama_part) as nama_part,
			GROUP_CONCAT(dc.part_status) as part_status,
			(CASE WHEN panel_status = 'main' THEN COALESCE(SUM(COALESCE(dc.qty_in_main, 0)), SUM(COALESCE(dc.qty_in, 0))) ELSE SUM(COALESCE(dc.qty_in, 0)) END) as qty_in,
			(CASE WHEN panel_status = 'main' THEN COALESCE(SUM(COALESCE(sii_in.qty_in_main, 0)), SUM(COALESCE(sii_in.qty, 0))) ELSE SUM(COALESCE(sii_in.qty, 0))END) kirim_secondary_dalam,
			(CASE WHEN panel_status = 'main' THEN COALESCE(SUM(COALESCE(sii.qty_replace_main, 0)), SUM(COALESCE(sii.qty_replace, 0))) ELSE SUM(COALESCE(sii.qty_replace, 0)) END) terima_repaired_secondary_dalam,
			(CASE WHEN panel_status = 'main' THEN COALESCE(SUM(COALESCE(sii.qty_in_main, 0)), SUM(COALESCE(sii.qty, 0))) ELSE SUM(COALESCE(sii.qty, 0)) END) terima_good_secondary_dalam,
			(CASE WHEN panel_status = 'main' THEN COALESCE(SUM(COALESCE(wod.qty_in_main, 0)), SUM(COALESCE(wod.qty, 0))) ELSE SUM(COALESCE(wod.qty, 0)) END) kirim_secondary_luar,
			(CASE WHEN panel_status = 'main' THEN COALESCE(SUM(COALESCE(si.qty_replace_main, 0)), SUM(COALESCE(si.qty_replace, 0))) ELSE SUM(COALESCE(si.qty_replace, 0)) END) terima_repaired_secondary_luar,
			(CASE WHEN panel_status = 'main' THEN COALESCE(SUM(COALESCE(si.qty_in_main, 0)), SUM(COALESCE(si.qty, 0))) ELSE SUM(COALESCE(si.qty, 0)) END) terima_good_secondary_luar,
	-- 		loading.stockers,
			loading.loading_qty loading_qty
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
						a.tgl_trans > '2026-01-01' AND
						a.tgl_trans < '2026-01-25' AND
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
						a.tgl_trans > '2026-01-01' AND
						a.tgl_trans < '2026-01-25' AND
						s.id is not null AND
						(s.cancel IS NULL OR s.cancel != 'y') and 
						(pd.part_status != 'main' OR pd.part_status IS NULL) 
			) dc 
			LEFT JOIN (
				SELECT
					sii_in.id_qr_stocker, 
					pd.id,
					s.so_det_id,			
					sii_in.qty_in qty_in_main,
					null qty 
				FROM 
					secondary_inhouse_in_input sii_in 
					left join stocker_input s on s.id_qr_stocker = sii_in.id_qr_stocker
					left join part_detail pd on pd.id = s.part_detail_id
				WHERE 
					sii_in.tgl_trans > '2026-01-01' AND
					sii_in.tgl_trans < '2026-01-25' AND
					s.id is not null AND
					(s.cancel IS NULL OR s.cancel != 'y') and 
					pd.part_status = 'main'
				UNION ALL
				SELECT
					sii_in.id_qr_stocker, 
					pd.id,
					s.so_det_id,
					null qty_in_main,
					sii_in.qty_in qty 
				FROM 
					secondary_inhouse_in_input sii_in 
					left join stocker_input s on s.id_qr_stocker = sii_in.id_qr_stocker
					left join part_detail pd on pd.id = s.part_detail_id
				WHERE 
					sii_in.tgl_trans > '2026-01-01' AND
					sii_in.tgl_trans < '2026-01-25' AND
					s.id is not null AND
					(s.cancel IS NULL OR s.cancel != 'y') and 
					(pd.part_status != 'main' OR pd.part_status IS NULL)
				) sii_in ON sii_in.id_qr_stocker = dc.id_qr_stocker
				LEFT JOIN (
					SELECT
						sii.id_qr_stocker, 
						pd.id,
						s.so_det_id,
						sii.qty_replace as qty_replace_main,
						null qty_replace,
						sii.qty_in qty_in_main,
						null qty 
					FROM 
						secondary_inhouse_input sii
						left join stocker_input s on s.id_qr_stocker = sii.id_qr_stocker
						left join part_detail pd on pd.id = s.part_detail_id
					WHERE 
						sii.tgl_trans > '2026-01-01' AND
						sii.tgl_trans < '2026-01-25' AND
						s.id is not null AND
						(s.cancel IS NULL OR s.cancel != 'y') and 
						pd.part_status= 'main'
					UNION ALL
					SELECT
						sii.id_qr_stocker, 
						pd.id,
						s.so_det_id,
						null qty_replace_main,
						sii.qty_replace qty_replace,
						null qty_in_main,
						sii.qty_in qty 
					FROM 
						secondary_inhouse_input sii
						left join stocker_input s on s.id_qr_stocker = sii.id_qr_stocker
						left join part_detail pd on pd.id = s.part_detail_id
					WHERE 
						sii.tgl_trans > '2026-01-01' AND
						sii.tgl_trans < '2026-01-25' AND
						s.id is not null AND
						(s.cancel IS NULL OR s.cancel != 'y') and 
						(pd.part_status != 'main' OR pd.part_status IS NULL)
				) sii ON sii.id_qr_stocker = dc.id_qr_stocker
				LEFT JOIN (
					SELECT
						wod.id_qr_stocker, 
						pd.id,
						s.so_det_id,
						wod.qty qty_in_main,
						null qty 
					FROM 
						wip_out_det wod
						left join stocker_input s on s.id_qr_stocker = wod.id_qr_stocker
						left join part_detail pd on pd.id = s.part_detail_id
					WHERE 
						wod.updated_at > '2026-01-01 00:00:00' AND
						wod.updated_at < '2026-01-25 00:00:00' AND
						s.id is not null AND
						(s.cancel IS NULL OR s.cancel != 'y') and 
						pd.part_status= 'main'
					UNION ALL
					SELECT
						wod.id_qr_stocker, 
						pd.id,
						s.so_det_id,
						null qty_in_main,
						wod.qty qty 
					FROM 
						wip_out_det wod
						left join stocker_input s on s.id_qr_stocker = wod.id_qr_stocker
						left join part_detail pd on pd.id = s.part_detail_id
					WHERE 
						wod.updated_at > '2026-01-01 00:00:00' AND
						wod.updated_at < '2026-01-25 00:00:00' AND
						s.id is not null AND
						(s.cancel IS NULL OR s.cancel != 'y') and 
						(pd.part_status != 'main' OR pd.part_status IS NULL)
				) wod ON wod.id_qr_stocker = dc.id_qr_stocker
				LEFT JOIN (
					SELECT
						si.id_qr_stocker, 
						pd.id,
						s.so_det_id,
						si.qty_replace qty_replace_main,
						null qty_replace,
						si.qty_in qty_in_main,
						null qty 
					FROM 
						secondary_in_input si
						left join stocker_input s on s.id_qr_stocker = si.id_qr_stocker
						left join part_detail pd on pd.id = s.part_detail_id
					WHERE 
						si.tgl_trans > '2026-01-01' AND
						si.tgl_trans < '2026-01-25' AND
						s.id is not null AND
						(s.cancel IS NULL OR s.cancel != 'y') and 
						pd.part_status= 'main'
					UNION ALL
					SELECT
						si.id_qr_stocker, 
						pd.id,
						s.so_det_id,
						null qty_replace_main,
						si.qty_replace qty_replace,
						null qty_in_main,
						si.qty_in qty 
					FROM 
						secondary_in_input si
						left join stocker_input s on s.id_qr_stocker = si.id_qr_stocker
						left join part_detail pd on pd.id = s.part_detail_id
					WHERE 
						si.tgl_trans > '2026-01-01' AND
						si.tgl_trans < '2026-01-25' AND
						s.id is not null AND
						(s.cancel IS NULL OR s.cancel != 'y') and 
						(pd.part_status != 'main' OR pd.part_status IS NULL)
				) si ON si.id_qr_stocker = dc.id_qr_stocker
				LEFT JOIN (
					select 
						panel,
						so_det_id,
						GROUP_CONCAT(stocker_id) stockers,
						SUM(loading_qty) loading_qty
					from (
						select 
							p.panel as panel,
							GROUP_CONCAT(ll.stocker_id) stocker_id,
							s.so_det_id,
							MIN(ll.qty) loading_qty
						from
							loading_line ll
							left join stocker_input s on s.id = ll.stocker_id
							left join part_detail pd on pd.id = s.part_detail_id 
							left join part p on p.id = pd.part_id
						where 
							ll.tanggal_loading > '2026-01-01' AND
							ll.tanggal_loading < '2026-01-25' AND
							(s.cancel IS NULL OR s.cancel != 'y')
						group by 
							p.panel,
							s.form_cut_id,
							s.so_det_id,
							s.group_stocker,
							s.ratio  
					) as loading
					group by 
						panel,
						so_det_id 
				) loading on loading.so_det_id = dc.so_det_id and loading.panel = dc.panel
		where 
			loading.loading_qty > 0
		group by 
			dc.so_det_id,
			dc.part_detail_id
		order by 
			dc.so_det_id, 
			dc.part_detail_id
	) dc 
	group by 
		so_det_id, 
		part_detail_id
),

dc_current_saldo AS (
-- current saldo
SELECT 
	*, 
	qty_in-kirim_secondary_dalam+terima_repaired_secondary_dalam+terima_good_secondary_dalam-kirim_secondary_luar+terima_repaired_secondary_luar+terima_good_secondary_luar-loading_qty saldo_akhir
FROM (
	SELECT 
		GROUP_CONCAT(dc.id_qr_stocker) as stockers,
		dc.buyer,
		dc.act_costing_ws,
		dc.color,
		dc.so_det_id,
		dc.panel,
		dc.panel_status,
		dc.part_detail_id,
		GROUP_CONCAT(dc.nama_part) as nama_part,
		GROUP_CONCAT(dc.part_status) as part_status,
		(CASE WHEN panel_status = 'main' THEN COALESCE(SUM(COALESCE(dc.qty_in_main, 0)), SUM(COALESCE(dc.qty_in,0))) ELSE SUM(COALESCE(dc.qty_in, 0)) END) as qty_in,
		(CASE WHEN panel_status = 'main' THEN COALESCE(SUM(COALESCE(sii_in.qty_in_main, 0)), SUM(COALESCE(sii_in.qty,0))) ELSE SUM(COALESCE(sii_in.qty, 0)) END) kirim_secondary_dalam,
		(CASE WHEN panel_status = 'main' THEN COALESCE(SUM(COALESCE(sii.qty_replace_main, 0)), SUM(COALESCE(sii.qty_replace,0))) ELSE SUM(COALESCE(sii.qty_replace, 0)) END) terima_repaired_secondary_dalam,
		(CASE WHEN panel_status = 'main' THEN COALESCE(SUM(COALESCE(sii.qty_in_main, 0)), SUM(COALESCE(sii.qty,0))) ELSE SUM(COALESCE(sii.qty, 0)) END) terima_good_secondary_dalam,
		(CASE WHEN panel_status = 'main' THEN COALESCE(SUM(COALESCE(wod.qty_in_main, 0)), SUM(COALESCE(wod.qty,0))) ELSE SUM(COALESCE(wod.qty, 0)) END) kirim_secondary_luar,
		(CASE WHEN panel_status = 'main' THEN COALESCE(SUM(COALESCE(si.qty_replace_main, 0)), SUM(COALESCE(si.qty_replace,0))) ELSE SUM(COALESCE(si.qty_replace,0)) END) terima_repaired_secondary_luar,
		(CASE WHEN panel_status = 'main' THEN COALESCE(SUM(COALESCE(si.qty_in_main, 0)), SUM(COALESCE(si.qty,0))) ELSE SUM(COALESCE(si.qty, 0)) END) terima_good_secondary_luar,
-- 		loading.stockers,
		loading.loading_qty
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
					a.tgl_trans between '2026-01-26' AND '2026-02-03' AND
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
					a.tgl_trans between '2026-01-26' AND '2026-02-03' AND
					s.id is not null AND
					(s.cancel IS NULL OR s.cancel != 'y') and 
					(pd.part_status != 'main' OR pd.part_status IS NULL) 
		) dc 
		LEFT JOIN (
			SELECT
				sii_in.id_qr_stocker, 
				pd.id,
				s.so_det_id,			
				sii_in.qty_in qty_in_main,
				null qty 
			FROM 
				secondary_inhouse_in_input sii_in 
				left join stocker_input s on s.id_qr_stocker = sii_in.id_qr_stocker
				left join part_detail pd on pd.id = s.part_detail_id
			WHERE 
				sii_in.tgl_trans between '2026-01-26' AND '2026-02-03' AND
				s.id is not null AND
				(s.cancel IS NULL OR s.cancel != 'y') and 
				pd.part_status = 'main'
			UNION ALL
			SELECT
				sii_in.id_qr_stocker, 
				pd.id,
				s.so_det_id,
				null qty_in_main,
				sii_in.qty_in qty 
			FROM 
				secondary_inhouse_in_input sii_in 
				left join stocker_input s on s.id_qr_stocker = sii_in.id_qr_stocker
				left join part_detail pd on pd.id = s.part_detail_id
			WHERE 
				sii_in.tgl_trans between '2026-01-26' AND '2026-02-03' AND
				s.id is not null AND
				(s.cancel IS NULL OR s.cancel != 'y') and 
				(pd.part_status != 'main' OR pd.part_status IS NULL)
			) sii_in ON sii_in.id_qr_stocker = dc.id_qr_stocker
			LEFT JOIN (
				SELECT
					sii.id_qr_stocker, 
					pd.id,
					s.so_det_id,
					sii.qty_replace as qty_replace_main,
					null qty_replace,
					sii.qty_in qty_in_main,
					null qty 
				FROM 
					secondary_inhouse_input sii
					left join stocker_input s on s.id_qr_stocker = sii.id_qr_stocker
					left join part_detail pd on pd.id = s.part_detail_id
				WHERE 
					sii.tgl_trans between '2026-01-26' AND '2026-02-03' AND
					s.id is not null AND
					(s.cancel IS NULL OR s.cancel != 'y') and 
					pd.part_status= 'main'
				UNION ALL
				SELECT
					sii.id_qr_stocker, 
					pd.id,
					s.so_det_id,
					null qty_replace_main,
					sii.qty_replace qty_replace,
					null qty_in_main,
					sii.qty_in qty 
				FROM 
					secondary_inhouse_input sii
					left join stocker_input s on s.id_qr_stocker = sii.id_qr_stocker
					left join part_detail pd on pd.id = s.part_detail_id
				WHERE 
					sii.tgl_trans between '2026-01-26' AND '2026-02-03' AND
					(s.cancel IS NULL OR s.cancel != 'y') and 
					(pd.part_status != 'main' OR pd.part_status IS NULL)
			) sii ON sii.id_qr_stocker = sii_in.id_qr_stocker
			LEFT JOIN (
				SELECT
					wod.id_qr_stocker, 
					pd.id,
					s.so_det_id,
					wod.qty qty_in_main,
					null qty 
				FROM 
					wip_out_det wod
					left join stocker_input s on s.id_qr_stocker = wod.id_qr_stocker
					left join part_detail pd on pd.id = s.part_detail_id
				WHERE 
					wod.updated_at between '2026-01-26 00:00:00' AND '2026-02-03 23:59:59' and
					s.id is not null AND
					(s.cancel IS NULL OR s.cancel != 'y') and 
					pd.part_status= 'main'
				UNION ALL
				SELECT
					wod.id_qr_stocker, 
					pd.id,
					s.so_det_id,
					null qty_in_main,
					wod.qty qty 
				FROM 
					wip_out_det wod
					left join stocker_input s on s.id_qr_stocker = wod.id_qr_stocker
					left join part_detail pd on pd.id = s.part_detail_id
				WHERE 
					wod.updated_at between '2026-01-26 00:00:00' AND '2026-02-03 23:59:59' and
					s.id is not null AND
					(s.cancel IS NULL OR s.cancel != 'y') and 
					(pd.part_status != 'main' OR pd.part_status IS NULL)
			) wod ON wod.id_qr_stocker = dc.id_qr_stocker
			LEFT JOIN (
				SELECT
					si.id_qr_stocker, 
					pd.id,
					s.so_det_id,
					si.qty_replace qty_replace_main,
					null qty_replace,
					si.qty_in qty_in_main,
					null qty 
				FROM 
					secondary_in_input si
					left join stocker_input s on s.id_qr_stocker = si.id_qr_stocker
					left join part_detail pd on pd.id = s.part_detail_id
				WHERE 
					si.tgl_trans between '2026-01-26' AND '2026-02-03' AND
					s.id is not null AND
					(s.cancel IS NULL OR s.cancel != 'y') and 
					pd.part_status= 'main'
				UNION ALL
				SELECT
					si.id_qr_stocker, 
					pd.id,
					s.so_det_id,
					null qty_replace_main,
					si.qty_replace qty_replace,
					null qty_in_main,
					si.qty_in qty 
				FROM 
					secondary_in_input si
					left join stocker_input s on s.id_qr_stocker = si.id_qr_stocker
					left join part_detail pd on pd.id = s.part_detail_id
				WHERE 
					si.tgl_trans between '2026-01-26' AND '2026-02-03' AND
					s.id is not null AND
					(s.cancel IS NULL OR s.cancel != 'y') and 
					(pd.part_status != 'main' OR pd.part_status IS NULL)
			) si ON si.id_qr_stocker = dc.id_qr_stocker
			LEFT JOIN (
				select 
					panel,
					so_det_id,
					GROUP_CONCAT(stocker_id) stockers,
					SUM(loading_qty) loading_qty
				from (
					select 
						p.panel as panel,
						GROUP_CONCAT(ll.stocker_id) stocker_id,
						s.so_det_id,
						MIN(ll.qty) loading_qty
					from
						loading_line ll
						left join stocker_input s on s.id = ll.stocker_id
						left join part_detail pd on pd.id = s.part_detail_id 
						left join part p on p.id = pd.part_id
					where 
						ll.tanggal_loading between '2026-01-26' AND '2026-02-03' AND
						(s.cancel IS NULL OR s.cancel != 'y')
					group by 
						p.panel,
						s.form_cut_id,
						s.so_det_id,
						s.group_stocker,
						s.ratio  
				) as loading
				group by 
					panel,
					so_det_id 
			) loading on loading.so_det_id = dc.so_det_id and loading.panel = dc.panel
	where 
		loading.loading_qty > 0
	group by 
		dc.so_det_id,
		dc.part_detail_id
	order by 
		dc.so_det_id, 
		dc.part_detail_id
) dc 
group by 
	so_det_id, 
	part_detail_id
)