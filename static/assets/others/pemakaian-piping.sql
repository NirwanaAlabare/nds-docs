SELECT 
	id_roll, 
	MAX(qty_in) qty_in, 
	SUM(total_pemakaian_roll) total_pemakaian_roll,
	MIN(sisa_kain) sisa_kain,
	SUM(short_roll) as short_roll,
	unit_roll
FROM (
	select
		COALESCE(scanned_item.qty_in, form_cut_piping.qty) qty_in,
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