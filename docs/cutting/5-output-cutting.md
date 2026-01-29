---
title: Output Cutting
---

# Output Cutting

Output Cutting adalah hasil secara **kuantitas** panel yang didapat dari proses cutting. Output Cutting didapat dari data **<u>[form_cut_input_detail](/docs/cutting/2-struktur.md#form_cut_input_detail-table)</u>**, sama dengan pemakaian kain, hanya saja yang diambil oleh output cutting ini lebih mengarah ke output secara hasil (kuantitas panel yang dihasilkan) dari proses cutting tersebut. Untuk perhitungan output cutting kurang lebih akan terlihat seperti :

```
Output Cutting = form->marker->marker_details->ratio * form->form_details->ply
```

Form akan mengambil data dari marker untuk mendapatkan **panel, beserta detail size(so_det_id) dan rasionya**, setelah didapatkan size dan rasio, form perlu menghitung berapa total lembar yang dihasilkan form dengan **menjumlahkan lembar gelaran di form detail(tabel form_cut_input_detail)**, lalu **setiap size akan mendapatkan qty-nya dengan mengkalikan rasio dengan total lembaran/gelaran dari form** yang sudah disimpan.


```sql title='output-cutting.sql'
SELECT
	marker_cutting.tgl_form_cut tanggal,
	GROUP_CONCAT(marker_cutting.id_meja) id_meja,
	GROUP_CONCAT(UPPER(marker_cutting.meja)) meja,
	marker_cutting.act_costing_ws ws,
	marker_cutting.style,
	marker_cutting.color,
	marker_cutting.panel,
	marker_cutting.so_det_id, 
	marker_cutting.size,
	SUM((marker_cutting.form_gelar * marker_cutting.ratio) + COALESCE(marker_cutting.diff, 0)) qty
FROM
	(
		SELECT
			marker_input.kode,
			form_cut.no_form,
			form_cut.id_meja,
			form_cut.meja,
			form_cut.tgl_form_cut,
			marker_input.buyer,
			marker_input.act_costing_id,
			marker_input.act_costing_ws,
			marker_input.style,
			marker_input.color,
			marker_input.panel,
			marker_input.cons_ws,
			marker_input.unit_panjang_marker unit,
			marker_input_detail.so_det_id,
			CONCAT(master_sb_ws.size, CASE WHEN master_sb_ws.dest != '-' AND master_sb_ws.dest IS NOT NULL THEN CONCAT(' - ', master_sb_ws.dest) ELSE '' END) size,
			marker_input_detail.ratio,
			COALESCE(marker_input.notes, form_cut.notes) notes,
			marker_input.gelar_qty marker_gelar,
			SUM(form_cut.qty_ply) spreading_gelar,
			SUM(COALESCE(form_cut.detail, form_cut.total_lembar)) form_gelar,
			SUM(modify_size_qty.difference_qty) diff
		FROM
			marker_input
			INNER JOIN
				marker_input_detail on marker_input_detail.marker_id = marker_input.id
			INNER JOIN
				master_sb_ws on master_sb_ws.id_so_det = marker_input_detail.so_det_id
			INNER JOIN
				(
					SELECT
						form_cut_input.no_meja id_meja,
						meja.`name` meja,
						COALESCE(DATE(form_cut_input.waktu_selesai), DATE(form_cut_input.waktu_mulai), DATE(form_cut_input.tgl_input)) tgl_form_cut,
						form_cut_input.id_marker,
						form_cut_input.id,
						form_cut_input.no_form,
						form_cut_input.qty_ply,
						form_cut_input.total_lembar,
						form_cut_input.notes,
						SUM(form_cut_input_detail.lembar_gelaran) detail
					FROM
						form_cut_input
						LEFT JOIN users meja ON meja.id = form_cut_input.no_meja
						INNER JOIN form_cut_input_detail ON form_cut_input_detail.form_cut_id = form_cut_input.id
					WHERE
						form_cut_input.`status` = 'SELESAI PENGERJAAN'
						AND form_cut_input.waktu_mulai is not null
						and COALESCE(DATE(waktu_selesai), DATE(waktu_mulai), tgl_form_cut) between '2025-01-01' and '2025-01-10'
					GROUP BY
						form_cut_input.id
				) form_cut on form_cut.id_marker = marker_input.kode
			LEFT JOIN
				modify_size_qty ON modify_size_qty.form_cut_id = form_cut.id AND modify_size_qty.so_det_id = marker_input_detail.so_det_id
		where
			(marker_input.cancel IS NULL OR marker_input.cancel != 'Y')
			AND marker_input_detail.ratio > 0
		group by
			marker_input.id,
			marker_input_detail.so_det_id,
			form_cut.id
		union
		SELECT
			'-' as kode,
			form_cut_reject.no_form,
			'reject' as id_meja,
			'reject' as meja,
			COALESCE ( DATE ( form_cut_reject.updated_at ), DATE ( form_cut_reject.created_at ), form_cut_reject.tanggal ) tgl_form_cut,
			form_cut_reject.buyer,
			form_cut_reject.act_costing_id,
			form_cut_reject.act_costing_ws,
			form_cut_reject.style,
			form_cut_reject.color,
			form_cut_reject.panel,
			'-' cons_ws,
			'PCS' unit,
			form_cut_reject_detail.so_det_id,
			CONCAT(master_sb_ws.size, CASE WHEN master_sb_ws.dest != '-' AND master_sb_ws.dest IS NOT NULL THEN CONCAT(' - ', master_sb_ws.dest) ELSE '' END) size,
			1 as ratio,
			COALESCE('REJECT') notes,
			SUM(form_cut_reject_detail.qty) marker_gelar,
			SUM(form_cut_reject_detail.qty) spreading_gelar,
			SUM(form_cut_reject_detail.qty) form_gelar,
			null diff
		FROM
			`form_cut_reject`
			LEFT JOIN `form_cut_reject_detail` ON `form_cut_reject_detail`.`form_id` = `form_cut_reject`.`id`
			LEFT JOIN `master_sb_ws` ON `form_cut_reject_detail`.`so_det_id` = `master_sb_ws`.`id_so_det`
		WHERE
			form_cut_reject_detail.`qty` > 0
			AND COALESCE ( DATE ( form_cut_reject.updated_at ), DATE ( form_cut_reject.created_at ), form_cut_reject.tanggal ) >= '2025-01-01'
			AND COALESCE ( DATE ( form_cut_reject.updated_at ), DATE ( form_cut_reject.created_at ), form_cut_reject.tanggal ) <= '2025-01-10' AND form_cut_reject.tanggal >= DATE ( NOW()- INTERVAL 2 YEAR )
		GROUP BY
			form_cut_reject.id,
			form_cut_reject_detail.so_det_id
		union
		SELECT
			'-' as kode,
			form_cut_piece.no_form,
			'piece' as id_meja,
			'piece' as meja,
			COALESCE ( DATE ( form_cut_piece.updated_at ), DATE ( form_cut_piece.created_at ), form_cut_piece.tanggal ) tgl_form_cut,
			form_cut_piece.buyer,
			form_cut_piece.act_costing_id,
			form_cut_piece.act_costing_ws,
			form_cut_piece.style,
			form_cut_piece.color,
			form_cut_piece.panel,
			form_cut_piece.cons_ws,
			'PCS' unit,
			form_cut_piece_detail_size.so_det_id,
			CONCAT(master_sb_ws.size, CASE WHEN master_sb_ws.dest != '-' AND master_sb_ws.dest IS NOT NULL THEN CONCAT(' - ', master_sb_ws.dest) ELSE '' END) size,
			1 as ratio,
			COALESCE(form_cut_piece.keterangan, 'PIECE') notes,
			SUM(form_cut_piece_detail_size.qty) marker_gelar,
			SUM(form_cut_piece_detail_size.qty) spreading_gelar,
			SUM(form_cut_piece_detail_size.qty) form_gelar,
			null diff
		FROM
			`form_cut_piece`
			LEFT JOIN `form_cut_piece_detail` ON `form_cut_piece_detail`.`form_id` = `form_cut_piece`.`id`
			LEFT JOIN `form_cut_piece_detail_size` ON `form_cut_piece_detail_size`.`form_detail_id` = `form_cut_piece_detail`.`id`
			LEFT JOIN `master_sb_ws` ON `form_cut_piece_detail_size`.`so_det_id` = `master_sb_ws`.`id_so_det`
		WHERE
			form_cut_piece.`status` = 'complete'
			AND COALESCE ( form_cut_piece_detail_size.qty ) > 0
			AND COALESCE ( DATE ( form_cut_piece.updated_at ), DATE ( form_cut_piece.created_at ), form_cut_piece.tanggal ) >= '2025-01-01'
			AND COALESCE ( DATE ( form_cut_piece.updated_at ), DATE ( form_cut_piece.created_at ), form_cut_piece.tanggal ) <= '2025-01-10' 
			AND form_cut_piece.tanggal >= DATE ( NOW()- INTERVAL 2 YEAR )
		GROUP BY
			form_cut_piece.id,
			form_cut_piece_detail_size.so_det_id
	) marker_cutting
GROUP BY
	marker_cutting.act_costing_id,
	marker_cutting.color,
	marker_cutting.panel,
	marker_cutting.so_det_id, marker_cutting.size,
	marker_cutting.tgl_form_cut
ORDER BY
	marker_cutting.act_costing_id,
	marker_cutting.color,
	marker_cutting.panel,
	marker_cutting.so_det_id, marker_cutting.size,
	marker_cutting.tgl_form_cut
```

Query diatas adalah query untuk mendapatkan total output cutting yang dikelompokkan berdasarkan **order(act_costing_id), color, panel, size dan tanggal output(tanggal form)**. Sumber utama dari query diatas adalah <b><u>[form_cut_input](/docs/cutting/2-struktur.md#1-form_cut_input-table)</u></b> , <b><u>[form_cut_reject](/docs/cutting/2-struktur.md#1-form_cut_reject-table)</u></b> dan <b><u>[form_cut_piece](/docs/cutting/2-struktur.md#1-form_cut_piece-table)</u></b>