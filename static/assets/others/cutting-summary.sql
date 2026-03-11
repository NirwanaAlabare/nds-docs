SELECT
	buyer,
	ws,
	color,
	size,
	styleno_prod,
	reff_no,
	id_so_det,
	MIN( qty_cut ) AS qty_cut 
FROM
	(
		SELECT
			master_sb_ws.buyer,
			master_sb_ws.ws,
			master_sb_ws.color,
			master_sb_ws.size,
			master_sb_ws.styleno_prod,
			master_sb_ws.reff_no,
			master_sb_ws.id_so_det,
			SUM( cutting.qty ) AS qty_cut 
		FROM
			(
				SELECT
					marker_cutting.tgl_form_cut tanggal,
					marker_cutting.panel,
					marker_cutting.so_det_id,
					SUM((marker_cutting.form_gelar * marker_cutting.ratio ) + COALESCE ( marker_cutting.diff, 0 )) qty 
				FROM
					(
						-- FORM CUT
						SELECT
							form_cut.tgl_form_cut,
							marker_input.panel,
							marker_input_detail.so_det_id,
							marker_input_detail.ratio,
							COALESCE ( marker_input.notes, form_cut.notes ) notes,
							marker_input.gelar_qty marker_gelar,
							SUM( form_cut.qty_ply ) spreading_gelar,
							SUM(COALESCE ( form_cut.detail, form_cut.total_lembar )) form_gelar,
							SUM( modify_size_qty.difference_qty ) diff 
						FROM
							laravel_nds.marker_input
							INNER JOIN laravel_nds.marker_input_detail ON marker_input_detail.marker_id = marker_input.id
							INNER JOIN laravel_nds.master_sb_ws ON master_sb_ws.id_so_det = marker_input_detail.so_det_id
							INNER JOIN (
							SELECT
								form_cut_input.no_meja id_meja,
								meja.`name` meja,
								COALESCE ( DATE ( form_cut_input.waktu_selesai ), DATE ( form_cut_input.waktu_mulai ),
								DATE ( form_cut_input.tgl_input )) tgl_form_cut,
								form_cut_input.id_marker,
								form_cut_input.id,
								form_cut_input.no_form,
								form_cut_input.qty_ply,
								form_cut_input.total_lembar,
								form_cut_input.notes,
								SUM( form_cut_input_detail.lembar_gelaran ) detail 
							FROM
								laravel_nds.form_cut_input
								LEFT JOIN laravel_nds.users meja ON meja.id = form_cut_input.no_meja
								INNER JOIN laravel_nds.form_cut_input_detail ON form_cut_input_detail.form_cut_id = form_cut_input.id 
							WHERE
								form_cut_input.`status` = 'SELESAI PENGERJAAN' 
								AND form_cut_input.waktu_mulai IS NOT NULL 
								AND COALESCE ( DATE ( waktu_selesai ), DATE ( waktu_mulai ), tgl_form_cut ) >= '2025-01-01' 
							GROUP BY
								form_cut_input.id 
							) form_cut ON form_cut.id_marker = marker_input.kode
							LEFT JOIN laravel_nds.modify_size_qty ON modify_size_qty.form_cut_id = form_cut.id 
							AND modify_size_qty.so_det_id = marker_input_detail.so_det_id 
						WHERE
							( marker_input.cancel IS NULL OR marker_input.cancel != 'Y' ) 
							AND marker_input_detail.ratio > 0 
						GROUP BY
							marker_input.id,
							marker_input_detail.so_det_id,
							form_cut.id 
						
						UNION ALL
						
						-- FORM CUT REJECT
						SELECT COALESCE
							( DATE ( form_cut_reject.updated_at ), DATE ( form_cut_reject.created_at ), form_cut_reject.tanggal ) tgl_form_cut,
							form_cut_reject.panel,
							form_cut_reject_detail.so_det_id,
							1 AS ratio,
							COALESCE ( 'REJECT' ) notes,
							SUM( form_cut_reject_detail.qty ) marker_gelar,
							SUM( form_cut_reject_detail.qty ) spreading_gelar,
							SUM( form_cut_reject_detail.qty ) form_gelar,
							NULL diff 
						FROM
							laravel_nds.`form_cut_reject`
							LEFT JOIN laravel_nds.`form_cut_reject_detail` ON `form_cut_reject_detail`.`form_id` = `form_cut_reject`.`id`
							LEFT JOIN laravel_nds.`master_sb_ws` ON `form_cut_reject_detail`.`so_det_id` = `master_sb_ws`.`id_so_det` 
						WHERE
							form_cut_reject_detail.`qty` > 0 
							AND COALESCE ( DATE ( form_cut_reject.updated_at ), DATE ( form_cut_reject.created_at ), form_cut_reject.tanggal ) >= '2025-05-01' 
							AND form_cut_reject.tanggal >= DATE ( NOW()- INTERVAL 2 YEAR ) 
						GROUP BY
							form_cut_reject.id,
							form_cut_reject_detail.so_det_id 
						
						UNION ALL
						
						-- FORM CUT PIECE
						SELECT COALESCE
							( DATE ( form_cut_piece.updated_at ), DATE ( form_cut_piece.created_at ), form_cut_piece.tanggal ) tgl_form_cut,
							form_cut_piece.panel,
							form_cut_piece_detail_size.so_det_id,
							1 AS ratio,
							COALESCE ( form_cut_piece.keterangan, 'PIECE' ) notes,
							SUM( form_cut_piece_detail_size.qty ) marker_gelar,
							SUM( form_cut_piece_detail_size.qty ) spreading_gelar,
							SUM( form_cut_piece_detail_size.qty ) form_gelar,
							NULL diff 
						FROM
							laravel_nds.`form_cut_piece`
							LEFT JOIN laravel_nds.`form_cut_piece_detail` ON `form_cut_piece_detail`.`form_id` = `form_cut_piece`.`id`
							LEFT JOIN laravel_nds.`form_cut_piece_detail_size` ON `form_cut_piece_detail_size`.`form_detail_id` = `form_cut_piece_detail`.`id`
							LEFT JOIN laravel_nds.`master_sb_ws` ON `form_cut_piece_detail_size`.`so_det_id` = `master_sb_ws`.`id_so_det` 
						WHERE
							form_cut_piece.`status` = 'complete' 
							AND COALESCE ( form_cut_piece_detail_size.qty ) > 0 
							AND COALESCE ( DATE ( form_cut_piece.updated_at ), DATE ( form_cut_piece.created_at ), form_cut_piece.tanggal ) >= '2025-01-01' 
							AND form_cut_piece.tanggal >= DATE ( NOW()- INTERVAL 2 YEAR ) 
						GROUP BY
							form_cut_piece.id,
							form_cut_piece_detail_size.so_det_id 
					) marker_cutting 
				GROUP BY
					marker_cutting.panel,
					marker_cutting.so_det_id 
			) cutting
			LEFT JOIN laravel_nds.master_sb_ws ON master_sb_ws.id_so_det = cutting.so_det_id 
		GROUP BY
			panel,
			ws,
			color,
			size,
			styleno_prod,
			reff_no 
	) cutting 
GROUP BY
	ws,
	color,
	size,
	styleno_prod,
	reff_no