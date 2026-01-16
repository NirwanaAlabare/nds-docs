select
		COALESCE(b.qty) qty_in,
		a.waktu_mulai,
		a.waktu_selesai,
		b.id,
		DATE_FORMAT(b.created_at, '%M') bulan,
		DATE_FORMAT(b.created_at, '%d-%m-%Y') tgl_input,
		b.no_form_cut_input,
		UPPER(meja.name) nama_meja,
		mrk.act_costing_ws,
		master_sb_ws.buyer,
		mrk.style,
		mrk.color,
		COALESCE(b.color_act, '-') color_act,
		mrk.panel,
		master_sb_ws.qty,
		cons_ws,
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
		ROUND((CASE WHEN b.status != 'extension complete' THEN ((CASE WHEN b.unit = 'KGM' THEN b.berat_amparan ELSE a.p_act + (a.comma_p_act/100) END) * b.lembar_gelaran) ELSE b.sambungan END) + (b.sisa_gelaran ) + (b.sambungan_roll ) , 2) pemakaian_lembar,
		ROUND((CASE WHEN b.status != 'extension complete' THEN ((CASE WHEN b.unit = 'KGM' THEN b.berat_amparan ELSE a.p_act + (a.comma_p_act/100) END) * b.lembar_gelaran) ELSE b.sambungan END) + (b.sisa_gelaran) + (b.sambungan_roll) + (b.kepala_kain) + (b.sisa_tidak_bisa) + (b.reject) + (b.piping), 2) total_pemakaian_roll,
		ROUND(((CASE WHEN b.status != 'extension complete' THEN ((CASE WHEN b.unit = 'KGM' THEN b.berat_amparan ELSE a.p_act + (a.comma_p_act/100) END) * b.lembar_gelaran) ELSE b.sambungan END) + (b.sisa_gelaran) + (b.sambungan_roll) + (b.kepala_kain) + (b.sisa_tidak_bisa) + (b.reject) + (b.piping))+(ROUND(MIN(CASE WHEN b.status != 'extension' AND b.status != 'extension complete' THEN (b.sisa_kain) ELSE (b.qty - b.total_pemakaian_roll) END), 2))-b.qty, 2) short_roll,
		ROUND((((CASE WHEN b.status != 'extension complete' THEN ((CASE WHEN b.unit = 'KGM' THEN b.berat_amparan ELSE a.p_act + (a.comma_p_act/100) END) * b.lembar_gelaran) ELSE b.sambungan END) + (b.sisa_gelaran) + (b.sambungan_roll) + (b.kepala_kain) + (b.sisa_tidak_bisa) + (b.reject) + (b.piping)+(ROUND(MIN(CASE WHEN b.status != 'extension' AND b.status != 'extension complete' THEN (b.sisa_kain) ELSE (b.qty - b.total_pemakaian_roll) END), 2)))-b.qty)/b.qty*100, 2) short_roll_percentage,
		b.status,
		a.operator,
		a.tipe_form_cut,
		b.created_at,
		b.updated_at,
		(CASE WHEN d.id is null and e.id is null THEN 'latest' ELSE 'not latest' END) roll_status
	from
		form_cut_input a
		left join form_cut_input_detail b on a.id = b.form_cut_id
		left join form_cut_input_detail c ON c.form_cut_id = b.form_cut_id and c.id_roll = b.id_roll and (c.status = 'extension' OR c.status = 'extension complete')
		LEFT JOIN form_cut_input_detail d on d.id_roll = b.id_roll AND b.id != d.id AND d.created_at > b.created_at and d.created_at >= '2026-01-01 00:00:00' and d.created_at <= '2026-01-14 23:59:59'
		LEFT JOIN form_cut_piping e on e.id_roll = b.id_roll AND e.created_at > b.created_at and e.created_at >= '2026-01-01 00:00:00' and e.created_at <= '2026-01-14 23:59:59'
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
		and b.created_at >= '2026-01-01 00:00:00' and b.created_at <= '2026-01-14 23:59:59'
	group by
		b.id