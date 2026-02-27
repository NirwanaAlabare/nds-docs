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