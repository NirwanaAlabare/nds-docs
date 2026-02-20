---
title: Modul DC
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

Terdapat beberapa modul utama dalam DC, yaitu **DC IN, Secondary INHOUSE, Secondary IN, Trolley Allocation dan Line Loading**. Proses-proses tadi adalah proses setelah cutting selesai dan stocker dibentuk. Untuk merekam data proses panel dari suatu produk sebelum akhirnya masuk ke line (sewing).

## DC IN

Merupakan gerbang masuk ke modul DC. Setelah suatu Stocker masuk ke DC IN maka stocker dapat dialokasi ke proses lain, sesuai alokasi yang terdaftar berdasarkan ```part_detail```. 

<Tabs groupId="dc-process">
  <TabItem value="single-process" label="Single Process">
    ```
    stocker_input.part_detail_id->part_detail.id
    part_detail.master_secondary_id->master_secondary.id
    master_secondary.*
    ```
  </TabItem>

  <TabItem value="multi-process" label="Multi Process">
    ```
    stocker_input.part_detail_id->part_detail.id
    part_detail.id->part_detail_secondary.part_detail_id
    part_detail_secondary.master_secondary_id->master_secondary.id
    master_secondary.*
    ```
  </TabItem>
</Tabs>

Code diatas adalah relasi yang dilalui untuk mendapatkan data proses selanjutnya (secondary process) dari stocker. Ada yang memiliki hanya satu proses (struktur pertama) dan ada yang bisa memiliki lebih dari satu proses (struktur baru).

### Scan DC

Untuk memasukkan suatu stock akan discan qr-nya dari stocker di modul ```create-dc-in``` 

![Scan DC IN](/assets/images/dc-module/create-dc-in.png)

Setelah stocker discan akan muncul detail stocker dari mulai informasi tentang detail produk sampai ke prosesnya.

<Tabs groupId="dc-code">
  <TabItem value="dc-controller" label="Create DC IN Controller">
    ```php title='App\Http\Controllers\DC\DCInController.php'
    public function create(Request $request)
    {
        return view('dc.dc-in.create-dc-in', ['page' => 'dashboard-dc', "subPageGroup" => "dcin-dc", "subPage" => "dc-in"]);
    }

    ```
  </TabItem>
  <TabItem value="create-dc-view" label="Create DC IN View">
    Berikut code dari view-nya, tetapi untuk lengkapnya langsung buka di project saja di ```resources\views\dc\create-dc-in.php```.
    <details>
        <summary>Code</summary>
        ```php title='resources\views\dc\create-dc-in.php'
            ... 
            
            @section('content')
                {{-- Mass Update Lokasi --}}
                <div class="modal fade" id="updateMassTmpDcModal" tabindex="-1" role="dialog" aria-labelledby="updateMassTmpDcModalLabel" aria-hidden="true">
                    <form action="{{ route('update_mass_tmp_dc_in') }}" method="post" name='mass_form_modal' onsubmit="submitForm(this, event)">
                        @method('PUT')
                        <div class="modal-dialog modal-lg modal-dialog-scrollable">
                            <div class="modal-content">
                                <div class="modal-header bg-sb text-light">
                                    <div style="max-width: 80%; max-height: 100%; overflow: auto;" class="text-nowrap">
                                        <h1 class="modal-title fs-5" id="updateMassTmpDcModalLabel"></h1>
                                    </div>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <div class='row'>
                                        <div class='col-sm-3'>
                                            <div class='form-group'>
                                                <label class='form-label'><small>Tujuan</small></label>
                                                <input type='text' class='form-control' name='mass_txttuj' id='mass_txttuj' value='' readonly>
                                                <input type='hidden' class='form-control' id='mass_id_c' name='mass_id_c' value=''>
                                                <input type='hidden' class='form-control' id='mass_id_kode' name='mass_id_kode' value=''>
                                            </div>
                                        </div>
                                        <div class='col-sm-3'>
                                            <div class='form-group'>
                                                <label class='form-label'><small>Tempat</small></label>
                                                <select class='form-control' style='width: 100%;' name='mass_cbotempat' id='mass_cbotempat' onchange='getmasslokasi();' readonly></select>
                                            </div>
                                        </div>
                                        <div class='col-sm-3'>
                                            <div class='form-group'>
                                                <label class='form-label'><small>Lokasi</small></label>
                                                <select class='form-control' style='width: 100%;' name='mass_cbolokasi' id='mass_cbolokasi' readonly></select>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Tutup</button>
                                    <button type="submit" class="btn btn-sb">Simpan</button>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>

                {{-- Update Lokasi --}}
                <div class="modal fade" id="updateTmpDcModal" tabindex="-1" role="dialog" aria-labelledby="updateTmpDcModalLabel" aria-hidden="true">
                    <form action="{{ route('update_tmp_dc_in') }}" method="post" name='form_modal' onsubmit="submitForm(this, event)">
                        @method('PUT')
                        <div class="modal-dialog modal-lg modal-dialog-scrollable">
                            <div class="modal-content">
                                <div class="modal-header bg-sb text-light">
                                    <h1 class="modal-title fs-5" id="updateTmpDcModalLabel"></h1>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <div class='row'>
                                        <div class='col-sm-3'>
                                            <div class='form-group'>
                                                <label class='form-label'><small>Qty In</small></label>
                                                <input type='hidden' class='form-control' id='txtqtyply' name='txtqtyply' value='' readonly>
                                                <input type='text' class='form-control' id='txtqty' name='txtqty' value='' readonly>
                                            </div>
                                        </div>
                                        <div class='col-sm-3'>
                                            <div class='form-group'>
                                                <label class='form-label'><small>Reject</small></label>
                                                <input type='number' class='form-control' id='txtqtyreject' name='txtqtyreject' oninput='sum();' autocomplete='off'>
                                            </div>
                                        </div>
                                        <div class='col-sm-3'>
                                            <div class='form-group'>
                                                <label class='form-label'><small>Replacement</small></label>
                                                <input type='number' class='form-control' id='txtqtyreplace' name='txtqtyreplace' oninput='sum();' autocomplete='off'>
                                            </div>
                                        </div>
                                        <div class='col-sm-3'>
                                            <div class='form-group'>
                                                <label class='form-label'><small>Keterangan</small></label>
                                                <input type='text' class='form-control' id='txtket' name='txtket' value=''>
                                                <input type='hidden' class='form-control' id='id_c' name='id_c' value=''>
                                                <input type='hidden' class='form-control' id='id_kode' name='id_kode' value=''>
                                            </div>
                                        </div>
                                    </div>
                                    <div class='row'>
                                        <div class='col-sm-3'>
                                            <div class='form-group'>
                                                <label class='form-label'><small>Tujuan</small></label>
                                                <input type='text' class='form-control' id='txttuj' name='txttuj' value='' readonly>
                                            </div>
                                        </div>
                                        <div class='col-sm-3'>
                                            <div class='form-group'>
                                                <label class='form-label'><small>Tempat</small></label>
                                                <select class='form-control select2bs4' style='width: 100%;' name='cbotempat' id='cbotempat' onchange='getlokasi();'></select>
                                            </div>
                                        </div>
                                        <div class='col-sm-3'>
                                            <div class='form-group'>
                                                <label class='form-label'><small>Lokasi</small></label>
                                                <select class='form-control select2bs4' style='width: 100%;' name='cbolokasi' id='cbolokasi'></select>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Tutup</button>
                                    <button type="submit" class="btn btn-sb">Simpan </button>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>

                {{-- Store DC In --}}
                <form action="{{ route('store-dc-in') }}" method="post" id="store-dc-in" name='form' onsubmit="submitForm(this, event)">
                    @csrf
                    <div class="card card-sb">
                        <div class="card-header">
                            <div class="d-flex justify-content-between align-items-center">
                                <h5 class="card-title fw-bold mb-0"><i class="fa fa-qrcode fa-sm"></i> Scan DC IN</h5>
                                <a href="{{ route('dc-in') }}" class="btn btn-primary btn-sm">
                                    <i class="fa fa-reply fa-sm"></i> Kembali ke DC IN
                                </a>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="row justify-content-center align-items-end">
                                <div class="col-md-12">
                                    <div class="mb-3">
                                        <label class="form-label label-input"><small><b>Stocker</b></small></label>
                                        <div class="input-group">
                                            <input type="text" class="form-control form-control-sm border-input" name="txtqr" id="txtqr" data-prevent-submit="true" autocomplete="off" enterkeyhint="go" autofocus>
                                            <button class="btn btn-sm btn-primary" type="button" id="scan_qr" onclick="scanqr()">Scan</button>
                                            <button class="btn btn-sm btn-success d-none" type="button" id="mass_scan_qr" onclick="massscanqr()">Mass Scan</button>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-2">
                                    <div></div>
                                </div>
                                <div class="col-8">
                                    <div id="reader"></div>
                                </div>
                                <div class="col-2">
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-3">
                                    <label class="form-label label-input"><small><b>WS</b></small></label>
                                    <div class="input-group">
                                        <input type='text' class='form-control form-control-sm border-input' id='txtws' name='txtws' value='' readonly>
                                    </div>
                                </div>
                                <div class="col-3">
                                    <label class="form-label label-input"><small><b>Buyer</b></small></label>
                                    <div class="input-group">
                                        <input type='text' class='form-control form-control-sm border-input' id='txtbuyer' name='txtbuyer' value='' readonly>
                                    </div>
                                </div>
                                <div class="col-3">
                                    <label class="form-label label-input"><small><b>Style</b></small></label>
                                    <div class="input-group">
                                        <input type='text' class='form-control form-control-sm border-input' id='txtstyle' name='txtstyle' value='' readonly>
                                    </div>
                                </div>
                                <div class="col-3">
                                    <label class="form-label label-input"><small><b>Color</b></small></label>
                                    <div class="input-group">
                                        <input type='text' class='form-control form-control-sm border-input' id='txtcolor' name='txtcolor' value='' readonly>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-3">
                                    <label class="form-label label-input"><small><b>Panel/Shell</b></small></label>
                                    <div class="input-group">
                                        <input type='text' class='form-control form-control-sm border-input' id='txtshell' name='txtshell' value='' readonly>
                                    </div>
                                </div>
                                <div class="col-3">
                                    <label class="form-label label-input"><small><b>Part</b></small></label>
                                    <div class="input-group">
                                        <input type='text' class='form-control form-control-sm border-input' id='txtpart' name='txtpart' value='' readonly>
                                    </div>
                                </div>
                                <div class="col-3">
                                    <label class="form-label label-input"><small><b>No Cut</b></small></label>
                                    <div class="input-group">
                                        <input type='text' class='form-control form-control-sm border-input' id='txtnocut' name='txtnocut' value='' readonly>
                                    </div>
                                </div>
                                <div class="col-3">
                                    <label class="form-label label-input"><small><b>Size</b></small></label>
                                    <div class="input-group">
                                        <input type='text' class='form-control form-control-sm border-input' id='txtsize' name='txtsize' value='' readonly>
                                    </div>
                                </div>
                                <div class="col-3">
                                    <label class="form-label label-input"><small><b>Group/Lot</b></small></label>
                                    <div class="input-group">
                                        <input type='text' class='form-control form-control-sm border-input' id='txtgroup' name='txtgroup' value='' readonly>
                                    </div>
                                </div>
                                <div class="col-3">
                                    <label class="form-label label-input"><small><b>Qty</b></small></label>
                                    <div class="input-group">
                                        <input type='text' class='form-control form-control-sm border-input' id='txtqtyply_h' name='txtqtyply_h' value='' readonly>
                                    </div>
                                </div>
                                <div class="col-3">
                                    <label class="form-label label-input"><small><b>Range Awal</b></small></label>
                                    <div class="input-group">
                                        <input type='text' class='form-control form-control-sm border-input' id='txtrange_awal' name='txtrange_awal' value='' readonly>
                                    </div>
                                </div>
                                <div class="col-3">
                                    <label class="form-label label-input"><small><b>Range Akhir</b></small></label>
                                    <div class="input-group">
                                        <input type='text' class='form-control form-control-sm border-input' id='txtrange_akhir' name='txtrange_akhir' value='' readonly>
                                    </div>
                                    <input type='hidden' class='form-control form-control-sm border-input' id='txtkode' name='txtkode' value='' readonly>
                                    <input type='hidden' class='form-control form-control-sm border-input' id='txttuj_h' name='txttuj_h' value='' readonly>
                                    <input type='hidden' class='form-control form-control-sm border-input' id='txtlok_h' name='txtlok_h' value='' readonly>
                                    <input type='hidden' class='form-control form-control-sm border-input' id='txttempat_h' name='txttempat_h' value='' readonly>
                                </div>
                            </div>

                        </div>
                    </div>

                    <div class="card card-sb">
                        <div class="card-header">
                            <h5 class="card-title fw-bold mb-0">List Data</h5>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table id="datatable-scan" class="table table-bordered table w-100 display nowrap">
                                    <thead>
                                        <tr>
                                            <th>Action</th>
                                            <th>
                                                <div class="d-flex justify-content-center ms-3">
                                                    <div class="form-check mt-1 mb-0">
                                                        <input class="form-check-input" type="checkbox" id="check-all-stocker" onchange="checkAll(this)" style="scale: 1.5;">
                                                    </div>
                                                </div>
                                            </th>
                                            <th>Stocker</th>
                                            <th>Size</th>
                                            <th>Panel</th>
                                            <th>Part</th>
                                            <th>Tujuan</th>
                                            <th>Tempat</th>
                                            <th>Proses / Lokasi</th>
                                            <th>Qty In</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    </tbody>
                                </table>
                                <div class="d-flex justify-content-between">
                                    <p class="my-3">
                                        Selected : <span id="checked-stocker-count" class="fw-bold">0</span>
                                    </p>
                                    <div class="d-flex gap-3">
                                        <button type="button" data-bs-toggle="modal" data-bs-target="#updateMassTmpDcModal" class="btn btn-primary btn-sm my-3" onclick="editCheckedTmpDcIn()">
                                            <i class="fa fa-edit"></i> Edit Selected Stocker
                                        </button>
                                        <button type="button"  class="btn btn-danger btn-sm my-3" onclick="deleteCheckedTmpDcIn()">
                                            <i class="fa fa-trash"></i> Delete Selected Stocker
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <button type="submit" class="btn btn-success btn-block"><i class="fa fa-save"></i> Simpan DC IN</button>
                        </div>
                    </div>
                </form>
            @endsection

            ...
        ```
    </details>
  </TabItem>
</Tabs>

Ketika user meng-scan stocker ke DC IN maka **id dari stocker itu akan dikirim untuk mendapatkan detail-nya** ( termasuk proses tujuannya berdasarkan alokasi di **<u>[part detail](/docs/part/1-penjelasan-singkat.md#part)</u>** ) dengan cara...

```php title='App\Http\Controllers\DC\DCInController'
public function show_data_header(Request $request)
    {
        $data_header = DB::select("
            SELECT
                a.act_costing_ws,
                COALESCE(msb.buyer, m.buyer, fp.buyer, fr.buyer) buyer,
                COALESCE(msb.styleno, m.style, fp.style, fr.style) styleno,
                a.color,
                COALESCE(msb.size, a.size) size,
                COALESCE(CONCAT(p_com.panel, (CASE WHEN p_com.panel_status IS NOT NULL THEN CONCAT(' - ', p_com.panel_status) ELSE '' END)), CONCAT(p.panel, (CASE WHEN p.panel_status IS NOT NULL THEN CONCAT(' - ', p.panel_status) ELSE '' END))) panel,
                CONCAT(mp.nama_part, (CASE WHEN pd.part_status IS NOT NULL THEN CONCAT(' - ', pd.part_status) ELSE '' END)) nama_part,
                COALESCE(f.no_cut, fp.no_cut, '-') no_cut,
                COALESCE(f.id, fr.id, fp.id) id,
                a.shade,
                a.qty_ply,
                a.range_awal,
                a.range_akhir,
                concat(so_det_id,'_',range_awal,'_',range_akhir,'_',shade) kode,
                COALESCE(ms.tujuan, ms_old.tujuan) tujuan,
                CASE WHEN pds.id is null THEN (IF(ms_old.tujuan = 'non secondary', a.lokasi, ms_old.proses)) ELSE (IF(ms.tujuan = 'non secondary', '-', ms.proses)) END lokasi,
                CASE WHEN pds.id is null THEN (IF(ms_old.tujuan = 'non secondary', ms_old.proses, '-')) ELSE (IF(ms.tujuan = 'non secondary', ms.proses, '-')) END tempat
            FROM
                `stocker_input` a
                left join master_sb_ws msb on msb.id_so_det = a.so_det_id
                left join form_cut_input f on a.form_cut_id = f.id
                left join form_cut_reject fr on a.form_reject_id = fr.id
                left join form_cut_piece fp on a.form_piece_id = fp.id
                left JOIN marker_input m ON m.kode = f.id_marker
                left join part_detail pd on a.part_detail_id = pd.id
                left join part p on p.id = pd.part_id
                left join part_detail pd_com on pd_com.id = pd.from_part_detail and pd.part_status = 'complement'
                left join part p_com on p_com.id = pd_com.part_id
                left join part_detail_secondary pds on pds.part_detail_id = pd.id
                left join master_part mp on mp.id = pd.master_part_id
                left join master_secondary ms on pds.master_secondary_id = ms.id
                left join master_secondary ms_old on pd.master_secondary_id = ms_old.id
            WHERE
                a.id_qr_stocker = '$request->txtqrstocker'
                and (a.cancel != 'y' or a.cancel IS NULL)
                and (CASE WHEN pds.id IS NOT NULL THEN pds.urutan = 1 ELSE pd.id IS NOT NULL END)
            GROUP BY
                a.id
        ");

        return json_encode($data_header ? $data_header[0] : null);
    }
```

Setelah didapatkan detail-nya stocker akan langsung disimpan ke temporary table di database.

```php title='App\Http\Controllers\DC\DCInController'
...
public function insert_tmp_dc_in(Request $request)
{
    $user = Auth::user()->name;
    if ($request->txttuj_h == 'NON SECONDARY') {
        $tujuan = $request->txttuj_h;
        $lokasi = $request->txtlok_h;
        $tempat = $request->txttempat_h;
    } else {
        $tujuan = $request->txttuj_h;
        $lokasi = $request->txtlok_h;
        $tempat = '-';
    }

    $cekdata =  DB::select("
        select
            *
        from
            tmp_dc_in_input_new
            left join dc_in_input on dc_in_input.id_qr_stocker = tmp_dc_in_input_new.id_qr_stocker
        where
            tmp_dc_in_input_new.id_qr_stocker = '" . $request->txtqrstocker . "' and tmp_dc_in_input_new.user = '".Auth::user()->username."'
    ");

    $cekdata_fix = $cekdata ? $cekdata[0] : null;
    if ($cekdata_fix ==  null) {

        DB::insert("
            insert into tmp_dc_in_input_new
            (
                id_qr_stocker,
                qty_reject,
                qty_replace,
                tujuan,
                tempat,
                lokasi,
                user
            )
            values
            (
                '" . $request->txtqrstocker . "',
                '0',
                '0',
                '$tujuan',
                '$tempat',
                '$lokasi',
                '$user'
            )
        ");

        DB::update(
            "update stocker_input set status = 'dc' where id_qr_stocker = '" . $request->txtqrstocker . "'"
        );
    }
}
...
```

Setelah masuk ke data temporary dc user, maka akan dapat ditentukan qty dan alokasinya. Berikut tampilannya :

![Scan DC IN 1](/assets/images/dc-module/create-dc-in-1.png)

<Tabs groupId="dc-process">
  <TabItem value="single-assign" label="Single Assignment">
    Setelah klik icon search di tabel (single assignment)

    ![Single Assign](/assets/images/dc-module/create-dc-in-assign.png)

    Akan muncul tampilan seperti diatas, dan dapat ditentukanlah qty-nya dan lokasi/proses selanjutnya (berdasarkan spesifikasi ```part_detail```), jika non-secondary maka akan ditampilkan pilihan rak dan detail lokasinya bisa juga langsung ke troli. Dan jika secondary maka akan ditampilkan pilihan proses secondary yang perlu dilalui selanjutnya. 

    ```php title='App\Http\Controllers\DC\DCInController.php'
    ...
    public function update_tmp_dc_in(Request $request)
    {
        if ($request->txttuj == 'NON SECONDARY') {
            $update_stocker_input = DB::update("
                update
                    stocker_input
                set
                    tempat = '" . $request->cbotempat . "',
                    tujuan = '" . $request->txttuj . "',
                    lokasi = '" . $request->cbolokasi . "'
                where
                    concat(so_det_id,'_',range_awal,'_',range_akhir,'_',shade) = '" . $request->id_kode . "'
            ");
        }

        $update_tmp_dc_in = DB::table("tmp_dc_in_input_new")->
            where("id_qr_stocker", $request->id_c )->
            update([
                "qty_reject" => $request->txtqtyreject,
                "qty_replace" => $request->txtqtyreplace,
                "tujuan" => $request->txttuj,
                "tempat" => $request->cbotempat,
                "lokasi" => $request->cbolokasi,
                "ket" => $request->txtket
            ]);

        if (!(is_nan($update_tmp_dc_in))) {
            return array(
                'status' => 300,
                'message' => 'Data Stocker "' . $request->id_c . '" berhasil diubah',
                'redirect' => '',
                'table' => 'datatable-scan',
                'additional' => [],
                'callback' => 'resetCheckedStocker()'
            );
        }
    }
    ...
    ```
  </TabItem>
  <TabItem value="mass-assign" label="Mass Assignment">
    Setelah menceklis stocker dan klik **'edit selected stocker'** (mass assignment)

    ![Mass Assign](/assets/images/dc-module/create-dc-in-assign-1.png)

    Akan muncul tampilan seperti diatas, tidak terdapat kolom untuk menginput qty-nya karena tiap stocker dapat berbeda qty-nya, hanya ada kolom untuk menentukan lokasi/proses selanjutnya (berdasarkan spesifikasi ```part_detail```), jika non-secondary maka akan ditampilkan pilihan rak dan detail lokasinya bisa juga langsung ke troli. Dan jika secondary maka akan ditampilkan pilihan proses secondary yang perlu dilalui selanjutnya. 

    ```php title='App\Http\Controllers\DC\DCInController.php'
    ...
    public function update_mass_tmp_dc_in(Request $request)
    {
        ini_set('max_execution_time', 36000);

        $massStockerIds = explode(",", $request->mass_id_c);

        if (count($massStockerIds) > 0) {
            $stockerCodes = Stocker::selectRaw("concat(so_det_id,'_',range_awal,'_',range_akhir,'_',shade) kode")->whereIn("id_qr_stocker", $massStockerIds)->pluck('kode')->toArray();
            $stockerCodeRaw = "(";
            for ($i = 0; $i < count($stockerCodes); $i++) {
                if ($i > 0) {
                    $stockerCodeRaw .= ", '".$stockerCodes[$i]."'";
                } else {
                    $stockerCodeRaw .= "'".$stockerCodes[$i]."'";
                }
            }
            $stockerCodeRaw .= ")";

            if ($request->mass_txttuj == 'NON SECONDARY') {
                $update_stocker_input = DB::update("
                    update
                        stocker_input
                    set
                        tempat = '" . $request->mass_cbotempat . "',
                        tujuan = '" . $request->mass_txttuj . "',
                        lokasi = '" . $request->mass_cbolokasi . "'
                    where
                        concat(so_det_id,'_',range_awal,'_',range_akhir,'_',shade) in " . $stockerCodeRaw . "
                ");
            }

            $update_tmp_dc_in = DB::table("tmp_dc_in_input_new")->
                whereIn("id_qr_stocker", $massStockerIds)->
                update([
                    "tujuan" => $request->mass_txttuj,
                    "tempat" => $request->mass_cbotempat,
                    "lokasi" => $request->mass_cbolokasi,
                ]);

            if (!(is_nan($update_tmp_dc_in))) {
                return array(
                    'status' => 300,
                    'message' => 'Data Stocker "' . $request->mass_id_c . '" berhasil diubah',
                    'redirect' => '',
                    'table' => 'datatable-scan',
                    'additional' => [],
                    'callback' => 'resetCheckedStocker()'
                );
            }
        }

        return array(
            'status' => 400,
            'message' => 'Data Stocker "' . $request->mass_id_c . '" gagal diubah',
            'redirect' => '',
            'table' => 'datatable-scan',
            'additional' => [],
            'callback' => 'resetCheckedStocker()'
        );
    }   
    ...
    ```
  </TabItem>
  <TabItem value="delete-temp-dc" label="Cancel DC Scan">
    Untuk membatalkan scan ke dc cukup dengan menceklis stocker yang akan dibatalkan lalu klik button **'Delete Selected Stocker'**. 
    
    ```php title='App\HttpControllers\DCInInputController'
    ...
    public function delete_mass_tmp_dc_in(Request $request)
    {
        ini_set('max_execution_time', 36000);

        $massStockerIds = explode(",", $request->ids);

        if (count($massStockerIds) > 0) {
            $delete_tmp_dc_in = DB::table("tmp_dc_in_input_new")->
                whereIn("id_qr_stocker", $massStockerIds)->
                delete();

            if ($delete_tmp_dc_in) {
                return array(
                    "status" => 200,
                    "message" => "Stock DC berhasil dihapus"
                );
            }
        }

        return array(
            "status" => 200,
            "message" => "Stock DC gagal dihapus"
        );
    }
    ...
    ```
  </TabItem>
</Tabs>

#### Save DC IN

Setelah stocker sudah di-assign dan ditentukan qty-nya dengan benar maka tinggal klik **'SIMPAN DC IN'** untuk menyimpan data-nya. Dengan mengeksekusi fungsi berikut :

```php title='App\Http\Controllers\DC\DCInController'
public function store(Request $request)
{
    $tgltrans = date('Y-m-d');
    $timestamp = Carbon::now();
    $user = Auth::user()->name;

    // DC In Input Insert
    DB::insert("
        REPLACE INTO dc_in_input
        (
            id_qr_stocker,
            tgl_trans,
            tujuan,
            lokasi,
            tempat,
            qty_awal,
            qty_reject,
            qty_replace,
            user,
            status,
            created_by,
            created_by_username,
            created_at,
            updated_at
        )
        select
            tmp.id_qr_stocker,
            '$tgltrans',
            tmp.tujuan,
            tmp.lokasi,
            tmp.tempat,
            (case when ms.qty_ply_mod > 0 THEN ms.qty_ply_mod ELSE ms.qty_ply END),
            qty_reject,
            qty_replace,
            user,
            'N',
            '".Auth::user()->id."',
            '".Auth::user()->username."',
            '$timestamp',
            '$timestamp'
        from
            tmp_dc_in_input_new tmp
            left join stocker_input ms on tmp.id_qr_stocker = ms.id_qr_stocker
        where
            tmp.tujuan > '' and
            tmp.lokasi > '' and
            tmp.tempat > '' and
            user = '$user'
    ");

    // Update Stocker Location
    $data_tmp_dc_in = DB::select("
        SELECT
            s.id_qr_stocker,
            (case when s.qty_ply_mod > 0 THEN s.qty_ply_mod ELSE s.qty_ply END) - coalesce(tmp.qty_reject,0) + coalesce(tmp.qty_replace,0) qty_in,
            tmp.qty_reject,
            tmp.qty_replace,
            COALESCE(ms.tujuan, ms_old.tujuan) tujuan,
            tmp.tempat,
            tmp.lokasi,
            tmp.ket,
            concat(so_det_id,'_',range_awal,'_',range_akhir,'_',shade) kode
        from
            stocker_input s
            left join part_detail pd on s.part_detail_id = pd.id
            left join part_detail_secondary pds on pds.part_detail_id = pd.id
            left join master_secondary ms on pds.master_secondary_id = ms.id
            left join master_secondary ms_old on ms_old.id = pd.master_secondary_id
            left join tmp_dc_in_input_new tmp on s.id_qr_stocker = tmp.id_qr_stocker
        where
            (s.cancel is null or s.cancel != 'y') and
            (CASE WHEN pds.id IS NOT NULL THEN pds.urutan = 1 ELSE pd.id IS NOT NULL END) and
            tmp.user = '".$user."' and
            ms.tujuan = 'NON SECONDARY'
        group by
            concat(so_det_id,'_',range_awal,'_',range_akhir,'_',shade)
    ");
    foreach ($data_tmp_dc_in as $data_tmp) {
        if ($data_tmp) {
            Stocker::whereRaw("concat(so_det_id,'_',range_awal,'_',range_akhir,'_',shade) = '".$data_tmp->kode."'")->update([
                "tempat" => $data_tmp->tempat,
                "lokasi" => $data_tmp->lokasi,
            ]);
        }
    }

    // Rack Detail Stocker Insert when it's tujuan is RAK
    DB::insert("
        INSERT INTO rack_detail_stocker
        (
            detail_rack_id,
            nm_rak,
            stocker_id,
            qty_in,
            created_at,
            updated_at
        )
        select
            r.id,nama_detail_rak,
            tmp.id_qr_stocker,
            (case when s.qty_ply_mod > 0 THEN s.qty_ply_mod ELSE s.qty_ply END) - qty_reject + qty_replace qty_in,
            '$timestamp',
            '$timestamp'
        from
            tmp_dc_in_input_new tmp
            left join rack_detail r on tmp.lokasi = r.nama_detail_rak
            left join stocker_input s on tmp.id_qr_stocker = s.id_qr_stocker
        where
            tmp.tujuan = 'NON SECONDARY' and
            tmp.tempat = 'RAK' and
            tmp.tujuan > '' and
            tmp.lokasi > '' and
            tmp.tempat > '' and
            (s.cancel is null or s.cancel != 'y') and
            user = '$user'
        "
    );

    return array(
        'status' => 999,
        'message' => 'Data Sudah Disimpan',
        'redirect' => 'reload',
        'table' => '',
        'additional' => [],
        'callback' => 'cleard()',
    );
}
```

### Qty DC

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

### Mutasi DC

Dan untuk kebutuhan reporting mutasinya digunakan query dc per-size dan part_detail. Klik **<u>[disini](/assets/others/dc-mutasi.sql)</u>** untuk mengunduh query mutasi dc. Query tersebut mencakup **semua transaksi di DC dari mulai DC In sampai ke Loading Line**.

## Secondary Inhouse

Terdapat dua tahap dalam proses secondary inhouse, yaitu **Secondary Inhouse IN** dan **Secondary Inhouse OUT** tapi saat ini **Secondary Inhouse IN belum mandatory**. Maka user hanya perlu **menginput di Secondary Inhouse OUT**. 

### Secondary Inhouse IN

![secondary-inhouse-in](/assets/images/dc-module/secondary-inhouse-in.png)

Dalam modul secondary inhouse IN user akan meng-scan stocker yang akan masuk ke Secondary Dalam sesuai dengan alokasi yang ditentukan <u>**[part_detail](/docs/part/2-.struktur.md#5-part_detail)**</u> / <u>**[part_detail_secondary](/docs/part/2-.struktur.md#6-part_detail_secondary-table)**</u> yang terdaftar ke stocker yang di-scan.

![create-secondary-inhouse-in](/assets/images/dc-module/create-secondary-inhouse-in.png)

Setelah discan, stocker akan tersimpan di tabel ```secondary_inhouse_in_temp```.

```php title='App\Http\Controller\SecondaryInhouseInController.php'
public function cek_data_stocker_inhouse(Request $request)
{
    $stocker = Stocker::where('id_qr_stocker', $request->txtqrstocker)->first();

    if ($stocker) {
        // Check Part Detail
        $partDetail = $stocker->partDetail;
        if ($partDetail) {

            // Check Part Detail Secondary
            $partDetailSecondary = $partDetail->secondaries;

            if ($partDetailSecondary && $partDetailSecondary->count() > 0) {

                // If there ain't no urutan
                if ($stocker->urutan == null) {
                    $cekdata = DB::select("
                        SELECT
                            dc.id_qr_stocker,
                            s.act_costing_ws,
                            msb.buyer,
                            COALESCE(a.no_cut, c.no_cut, '-') as no_cut,
                            msb.styleno as style,
                            s.color,
                            COALESCE(msb.size, s.size) size,
                            mp.nama_part,
                            dc.tujuan,
                            dc.lokasi,
                            COALESCE(coalesce(s.qty_ply_mod, s.qty_ply) - dc.qty_reject + dc.qty_replace) qty_awal,
                            ifnull(si.id_qr_stocker,'x'),
                            1 as urutan
                        from dc_in_input dc
                            left join stocker_input s on dc.id_qr_stocker = s.id_qr_stocker
                            left join master_sb_ws msb on msb.id_so_det = s.so_det_id
                            left join form_cut_input a on s.form_cut_id = a.id
                            left join form_cut_reject b on s.form_reject_id = b.id
                            left join form_cut_piece c on s.form_piece_id = c.id
                            left join part_detail p on s.part_detail_id = p.id
                            left join master_part mp on p.master_part_id = mp.id
                            left join marker_input mi on a.id_marker = mi.kode
                            left join secondary_inhouse_input si on dc.id_qr_stocker = si.id_qr_stocker
                        where
                            dc.id_qr_stocker =  '" . $request->txtqrstocker . "' and dc.tujuan = 'SECONDARY DALAM'
                    ");
                }
                // If there is urutan
                else {
                    // Current Secondary
                    $currentPartDetailSecondary = $partDetailSecondary->where('urutan', $stocker->urutan)->first();

                    if ($currentPartDetailSecondary && ($currentPartDetailSecondary->secondary && $currentPartDetailSecondary->secondary->tujuan == 'SECONDARY DALAM')) {

                        // Check the one step before
                        $multiSecondaryBefore = DB::table("stocker_input")->selectRaw("
                                stocker_input.id,
                                stocker_input.id_qr_stocker,
                                part_detail_secondary.urutan,
                                master_secondary.tujuan
                            ")->
                            where('id_qr_stocker', $request->txtqrstocker)->
                            leftJoin("part_detail", "part_detail.id", "=", "stocker_input.part_detail_id")->
                            leftJoin("part_detail_secondary", "part_detail_secondary.part_detail_id", "=", "part_detail.id")->
                            leftJoin("master_secondary", "master_secondary.id", "=",  "part_detail_secondary.master_secondary_id")->
                            where("part_detail_secondary.urutan", "<", $currentPartDetailSecondary->urutan)->
                            orderBy("part_detail_secondary.urutan", "desc")->
                            first();

                        // When there is a step before
                        if ($multiSecondaryBefore) {

                            // When the tujuan is different
                            if ($multiSecondaryBefore->tujuan != $currentPartDetailSecondary->secondary->tujuan) {

                                // Check Secondary Before on Secondary In (where the secondary should've finished)
                                $multiSecondaryBeforeSecondaryIn = DB::table("secondary_in_input")->
                                    where("id_qr_stocker", $request->txtqrstocker)->
                                    where("urutan", $multiSecondaryBefore->urutan)->
                                    first();

                                // When there is secondary in on the step before then
                                if ($multiSecondaryBeforeSecondaryIn) {

                                    // Return the data
                                    $cekdata =  DB::select("
                                        SELECT
                                            dc.id_qr_stocker,
                                            s.act_costing_ws,
                                            msb.buyer,
                                            COALESCE(a.no_cut, c.no_cut, '-') as no_cut,
                                            msb.styleno as style,
                                            s.color,
                                            COALESCE(msb.size, s.size) size,
                                            mp.nama_part,
                                            ms.tujuan,
                                            ms.proses lokasi,
                                            ".($multiSecondaryBeforeSecondaryIn->qty_in)." qty_awal,
                                            ifnull(si.id_qr_stocker,'x'),
                                            (pds.urutan) as urutan
                                        from
                                            dc_in_input dc
                                            left join stocker_input s on dc.id_qr_stocker = s.id_qr_stocker
                                            left join master_sb_ws msb on msb.id_so_det = s.so_det_id
                                            left join form_cut_input a on s.form_cut_id = a.id
                                            left join form_cut_reject b on s.form_reject_id = b.id
                                            left join form_cut_piece c on s.form_piece_id = c.id
                                            left join part_detail p on s.part_detail_id = p.id
                                            left join part_detail_secondary pds on pds.part_detail_id = p.id
                                            left join master_part mp on p.master_part_id = mp.id
                                            left join master_secondary ms on pds.master_secondary_id = ms.id
                                            left join marker_input mi on a.id_marker = mi.kode
                                            left join secondary_inhouse_input si on dc.id_qr_stocker = si.id_qr_stocker
                                        where
                                            dc.id_qr_stocker =  '" . $request->txtqrstocker . "' and
                                            ms.tujuan = 'SECONDARY DALAM' and
                                            pds.urutan = '".$currentPartDetailSecondary->urutan."'
                                    ");
                                }
                            }
                            // When the tujuan is the same
                            else {

                                // Check the before tujuan
                                $multiSecondaryBeforeSecondary = null;
                                if ($multiSecondaryBefore->tujuan == 'SECONDARY DALAM') {
                                    $multiSecondaryBeforeSecondary = DB::table("secondary_inhouse_input")->
                                        where("id_qr_stocker", $request->txtqrstocker)->
                                        where("urutan", $multiSecondaryBefore->urutan)->
                                        first();
                                } else {
                                    $multiSecondaryBeforeSecondary = DB::table("secondary_in_input")->
                                        where("id_qr_stocker", $request->txtqrstocker)->
                                        where("urutan", $multiSecondaryBefore->urutan)->
                                        first();
                                }

                                // Return the data
                                $cekdata =  DB::select("
                                    SELECT
                                        dc.id_qr_stocker,
                                        s.act_costing_ws,
                                        msb.buyer,
                                        COALESCE(a.no_cut, c.no_cut, '-') as no_cut,
                                        msb.styleno as style,
                                        s.color,
                                        COALESCE(msb.size, s.size) size,
                                        mp.nama_part,
                                        ms.tujuan,
                                        ms.proses lokasi,
                                        '".($multiSecondaryBeforeSecondary->qty_in)."' qty_awal,
                                        ifnull(si.id_qr_stocker,'x'),
                                        (pds.urutan) as urutan
                                    from
                                        dc_in_input dc
                                        left join stocker_input s on dc.id_qr_stocker = s.id_qr_stocker
                                        left join master_sb_ws msb on msb.id_so_det = s.so_det_id
                                        left join form_cut_input a on s.form_cut_id = a.id
                                        left join form_cut_reject b on s.form_reject_id = b.id
                                        left join form_cut_piece c on s.form_piece_id = c.id
                                        left join part_detail p on s.part_detail_id = p.id
                                        left join part_detail_secondary pds on pds.part_detail_id = p.id
                                        left join master_part mp on p.master_part_id = mp.id
                                        left join master_secondary ms on pds.master_secondary_id = ms.id
                                        left join marker_input mi on a.id_marker = mi.kode
                                        left join secondary_inhouse_input si on dc.id_qr_stocker = si.id_qr_stocker
                                    where
                                        dc.id_qr_stocker =  '" . $request->txtqrstocker . "' and
                                        ms.tujuan = 'SECONDARY DALAM' and
                                        pds.urutan = '".$currentPartDetailSecondary->urutan."'
                                ");
                            }
                        } else {
                            $cekdata =  DB::select("
                                SELECT
                                    dc.id_qr_stocker,
                                    s.act_costing_ws,
                                    msb.buyer,
                                    COALESCE(a.no_cut, c.no_cut, '-') as no_cut,
                                    msb.styleno as style,
                                    s.color,
                                    COALESCE(msb.size, s.size) size,
                                    mp.nama_part,
                                    dc.tujuan,
                                    dc.lokasi,
                                    COALESCE(coalesce(s.qty_ply_mod, s.qty_ply) - dc.qty_reject + dc.qty_replace) qty_awal,
                                    ifnull(si.id_qr_stocker,'x'),
                                    1 as urutan
                                from dc_in_input dc
                                    left join stocker_input s on dc.id_qr_stocker = s.id_qr_stocker
                                    left join master_sb_ws msb on msb.id_so_det = s.so_det_id
                                    left join form_cut_input a on s.form_cut_id = a.id
                                    left join form_cut_reject b on s.form_reject_id = b.id
                                    left join form_cut_piece c on s.form_piece_id = c.id
                                    left join part_detail p on s.part_detail_id = p.id
                                    left join master_part mp on p.master_part_id = mp.id
                                    left join marker_input mi on a.id_marker = mi.kode
                                    left join secondary_inhouse_input si on dc.id_qr_stocker = si.id_qr_stocker
                                where
                                    dc.id_qr_stocker =  '" . $request->txtqrstocker . "' and
                                    dc.tujuan = 'SECONDARY DALAM' and
                            ");
                        }
                    } else {
                        return array(
                            "message" => 400,
                            "message" => "Part Detail Secondary tidak sesuai."
                        );
                    }
                }
            }
            // Default
            else {
                $cekdata =  DB::select("
                    SELECT
                        dc.id_qr_stocker,
                        s.act_costing_ws,
                        msb.buyer,
                        COALESCE(a.no_cut, c.no_cut, '-') as no_cut,
                        msb.styleno as style,
                        s.color,
                        COALESCE(msb.size, s.size) size,
                        mp.nama_part,
                        dc.tujuan,
                        dc.lokasi,
                        COALESCE(coalesce(s.qty_ply_mod, s.qty_ply) - dc.qty_reject + dc.qty_replace) qty_awal,
                        ifnull(si.id_qr_stocker,'x'),
                        1 as urutan
                    from dc_in_input dc
                        left join stocker_input s on dc.id_qr_stocker = s.id_qr_stocker
                        left join master_sb_ws msb on msb.id_so_det = s.so_det_id
                        left join form_cut_input a on s.form_cut_id = a.id
                        left join form_cut_reject b on s.form_reject_id = b.id
                        left join form_cut_piece c on s.form_piece_id = c.id
                        left join part_detail p on s.part_detail_id = p.id
                        left join master_part mp on p.master_part_id = mp.id
                        left join marker_input mi on a.id_marker = mi.kode
                        left join secondary_inhouse_input si on dc.id_qr_stocker = si.id_qr_stocker
                    where
                        dc.id_qr_stocker =  '" . $request->txtqrstocker . "'
                        and dc.tujuan = 'SECONDARY DALAM'
                ");
            }
        } else {
            return array(
                "message" => 400,
                "message" => "No Part Detail Found."
            );
        }
    }

    if ($cekdata && $cekdata[0]) {
        // Check Secondary Inhouse
        $checkSecInhouseIn = SecondaryInhouseIn::where("id_qr_stocker", $request->txtqrstocker)->first();
        if ($checkSecInhouseIn) {
            return array(
                "status" => 400,
                "message" => "Stocker sudah discan di transaksi IN Secondary Dalam."
            );
        }

        // Check Secondary Inhouse Temp
        $checkSecInhouseInTemp = SecondaryInhouseInTemp::where("id_qr_stocker", $request->txtqrstocker)->first();
        if ($checkSecInhouseInTemp) {
            return array(
                "status" => 400,
                "message" => "Stocker sudah discan di temporary IN Secondary Dalam."
            );
        }

        // Insert to Secondary Inhouse to Temporary
        $storeSecondaryInhouseInTemp = SecondaryInhouseInTemp::updateOrCreate([
                "id_qr_stocker" => $request->txtqrstocker,
                "urutan" => $cekdata[0]->urutan,
                "created_by" => Auth::user()->id,
            ], [
                "qty" => $cekdata[0]->qty_awal,
                "created_by_username" => Auth::user()->username,
            ]);
        if ($storeSecondaryInhouseInTemp) {
            return array(
                "status" => 200,
                "message" => "Stocker Berhasil disimpan ke temporary"
            );
        }
    }

    return array(
        "status" => 400,
        "message" => "Stocker tidak ditemukan."
    );
}
```

Dikarenakan sebuah stocker melalui **satu**(ketentuan awal) atau **lebih**(ketentuan baru) maka disediakan beberapa **conditional** untuk mengecek urutan proses dari stocker agar dapat terekam secara berurutan. Setelah discan stocker_temp bisa disimpan dengan cara klik button **Simpan**. 

```php title='App\Http\Controller\SecondaryInhouseInController.php'
public function storeSecondaryInhouseIn(Request $request)
{
    // Get user's temporary data
    $batch = Str::uuid();
    $dataStockerInhouseInTemp = SecondaryInhouseInTemp::selectRaw("
            CURRENT_DATE() tgl_trans,
            secondary_inhouse_in_temp.id_qr_stocker,
            form_cut_input.no_form,
            secondary_inhouse_in_temp.qty qty_in,
            secondary_inhouse_in_temp.created_by_username as user,
            secondary_inhouse_in_temp.urutan,
            '".$batch."' as batch
        ")->
        leftJoin("stocker_input", "stocker_input.id_qr_stocker", "=", "secondary_inhouse_in_temp.id_qr_stocker")->
        leftJoin("form_cut_input", "form_cut_input.id", "=", "stocker_input.form_cut_id")->
        where("created_by", Auth::user()->id)->
        get();

    if ($dataStockerInhouseInTemp && $dataStockerInhouseInTemp->count() > 0) {
        // Insert to stocker inhouse in
        $storeStockerInhouseIn = SecondaryInhouseIn::upsert($dataStockerInhouseInTemp->toArray(), ["id_qr_stocker", "no_form", "urutan"]);

        if ($storeStockerInhouseIn) {
            // Delete user's temporary data
            SecondaryInhouseInTemp::where("created_by", Auth::user()->id)->delete();

            // Get stored data
            $storedStocker = SecondaryInhouseIn::select("id_qr_stocker")->where("batch", $batch)->pluck("id_qr_stocker");
            $storedStockerStr = "";
            if ($storedStocker) {
                foreach ($storedStocker as $stocker) {
                    $storedStockerStr .= $stocker." berhasil disimpan. <br>";
                }
            }

            return array(
                "status" => 200,
                "message" => $storedStockerStr,
                "callback" => "datatableReload()"
            );
        }
    } else {
        return  array(
            "status" => 400,
            "message" => "Data temporary tidak ditemukan.",
        );
    }

    return  array(
        "status" => 400,
        "message" => "Data tidak berhasil disimpan.",
    );
}
```

### Secondary Inhouse OUT

![secondary-inhouse-out](/assets/images/dc-module/secondary-inhouse-out.png)

Setelah user meng-scan Stocker di **DC IN Input** maka stocker yang terdaftar ke proses **Secondary Dalam** (melalui ```stocker_input > part_detail > (optional:part_detail_secondary) > master_secondary```) dapat memasuki proses ini, dengan atau tanpa Secondary Inhouse IN (Secondary Inhouse IN belum mandatory).

![create-secondary-inhouse-out](/assets/images/dc-module/create-secondary-inhouse-out.png)

Setelah stocker discan dalam proses ini, user akan menentukan qty reject jika ada reject dan qty replace jika ada replacement.

<Tabs>
  <TabItem value="scan-stocker" label="Scan Stocker" default>
    Seperti Secondary Inhouse IN, di Secondary Inhouse OUT juga menyediakan **conditional** untuk stocker yang melalui **satu**(ketentuan awal) ataupun **lebih**(ketentuan baru), serta untuk **pengecekan proses urutan stocker** agar prosesnya tidak tumpang tindih satu sama lain. Setelah didapatkan data stocker-nya user bisa menentukan qty reject dan replace-nya. 

    ```php title='App\Http\Controllers\DC\SecondaryInhouseOutController.php'
    public function cek_data_stocker_inhouse(Request $request)
    {
        $stocker = Stocker::where('id_qr_stocker', $request->txtqrstocker)->first();

        if ($stocker) {
            // Check Part Detail
            $partDetail = $stocker->partDetail;
            if ($partDetail) {

                // Check Part Detail Secondary
                $partDetailSecondary = $partDetail->secondaries;

                if ($partDetailSecondary && $partDetailSecondary->count() > 0) {

                    // If there ain't no urutan
                    if ($stocker->urutan == null) {
                        $cekdata = DB::select("
                            SELECT
                                dc.id_qr_stocker,
                                s.act_costing_ws,
                                msb.buyer,
                                COALESCE(a.no_cut, c.no_cut, '-') as no_cut,
                                msb.styleno as style,
                                s.color,
                                COALESCE(msb.size, s.size) size,
                                COALESCE(CONCAT(p_com.panel, (CASE WHEN p_com.panel_status IS NOT NULL THEN CONCAT(' - ', p_com.panel_status) ELSE '' END)), CONCAT(p.panel, (CASE WHEN p.panel_status IS NOT NULL THEN CONCAT(' - ', p.panel_status) ELSE '' END))) panel,
                                CONCAT(mp.nama_part, (CASE WHEN pd.part_status IS NOT NULL THEN CONCAT(' - ', pd.part_status) ELSE '' END)) nama_part,
                                dc.tujuan,
                                dc.lokasi,
                                COALESCE(sii.id, '-') as in_id,
                                COALESCE(sii.updated_at, sii.created_at, '-') as waktu_in,
                                COALESCE(sii.user, '-') as author_in,
                                COALESCE(sii.qty_in, coalesce(s.qty_ply_mod, s.qty_ply) - dc.qty_reject + dc.qty_replace) qty_awal,
                                ifnull(si.id_qr_stocker,'x'),
                                1 as urutan
                            from dc_in_input dc
                                left join stocker_input s on dc.id_qr_stocker = s.id_qr_stocker
                                left join master_sb_ws msb on msb.id_so_det = s.so_det_id
                                left join form_cut_input a on s.form_cut_id = a.id
                                left join form_cut_reject b on s.form_reject_id = b.id
                                left join form_cut_piece c on s.form_piece_id = c.id
                                left join part_detail pd on s.part_detail_id = pd.id
                                left join part p on p.id = pd.part_id
                                left join part_detail pd_com on pd_com.id = pd.from_part_detail and pd.part_status = 'complement'
                                left join part p_com on p_com.id = pd_com.part_id
                                left join master_part mp on pd.master_part_id = mp.id
                                left join marker_input mi on a.id_marker = mi.kode
                                left join secondary_inhouse_in_input sii on dc.id_qr_stocker = sii.id_qr_stocker
                                left join secondary_inhouse_input si on dc.id_qr_stocker = si.id_qr_stocker
                            where
                                dc.id_qr_stocker =  '" . $request->txtqrstocker . "' and dc.tujuan = 'SECONDARY DALAM'
                                and ifnull(si.id_qr_stocker,'x') = 'x'
                        ");

                        return $cekdata && $cekdata[0] ? json_encode($cekdata[0]) : null;
                    }
                    // If there is urutan
                    else {
                        // Current Secondary
                        $currentPartDetailSecondary = $partDetailSecondary->where('urutan', $stocker->urutan)->first();

                        if ($currentPartDetailSecondary && ($currentPartDetailSecondary->secondary && $currentPartDetailSecondary->secondary->tujuan == 'SECONDARY DALAM')) {

                            // Check the Secondary Inhouse IN first
                            $cekdata =  DB::select("
                                SELECT
                                    dc.id_qr_stocker,
                                    s.act_costing_ws,
                                    msb.buyer,
                                    COALESCE(a.no_cut, c.no_cut, '-') as no_cut,
                                    msb.styleno as style,
                                    s.color,
                                    COALESCE(msb.size, s.size) size,
                                    COALESCE(CONCAT(p_com.panel, (CASE WHEN p_com.panel_status IS NOT NULL THEN CONCAT(' - ', p_com.panel_status) ELSE '' END)), CONCAT(p.panel, (CASE WHEN p.panel_status IS NOT NULL THEN CONCAT(' - ', p.panel_status) ELSE '' END))) panel,
                                    CONCAT(mp.nama_part, (CASE WHEN pd.part_status IS NOT NULL THEN CONCAT(' - ', pd.part_status) ELSE '' END)) nama_part,
                                    ms.tujuan,
                                    ms.proses lokasi,
                                    COALESCE(sii.id, '-') as in_id,
                                    COALESCE(sii.updated_at, sii.created_at, '-') as waktu_in,
                                    COALESCE(sii.user, '-') as author_in,
                                    sii.qty_in qty_awal,
                                    ifnull(si.id_qr_stocker,'x'),
                                    (pds.urutan) as urutan
                                from
                                    dc_in_input dc
                                    left join stocker_input s on dc.id_qr_stocker = s.id_qr_stocker
                                    left join master_sb_ws msb on msb.id_so_det = s.so_det_id
                                    left join form_cut_input a on s.form_cut_id = a.id
                                    left join form_cut_reject b on s.form_reject_id = b.id
                                    left join form_cut_piece c on s.form_piece_id = c.id
                                    left join part_detail pd on s.part_detail_id = pd.id
                                    left join part p on p.id = pd.part_id
                                    left join part_detail pd_com on pd_com.id = pd.from_part_detail and pd.part_status = 'complement'
                                    left join part p_com on p_com.id = pd_com.part_id
                                    left join part_detail_secondary pds on pds.part_detail_id = pd.id
                                    left join master_part mp on pd.master_part_id = mp.id
                                    left join master_secondary ms on pds.master_secondary_id = ms.id
                                    left join marker_input mi on a.id_marker = mi.kode
                                    left join secondary_inhouse_in_input sii on dc.id_qr_stocker = sii.id_qr_stocker and sii.urutan = pds.urutan
                                    left join secondary_inhouse_input si on dc.id_qr_stocker = si.id_qr_stocker
                                where
                                    ms.tujuan = 'SECONDARY DALAM' and
                                    dc.id_qr_stocker =  '" . $request->txtqrstocker . "' and
                                    pds.urutan = '".$currentPartDetailSecondary->urutan."' and
                                    sii.urutan = '".$currentPartDetailSecondary->urutan."' and
                                    sii.id is not null
                            ");

                            if ($cekdata && $cekdata[0]) {
                                return $cekdata && $cekdata[0] ? json_encode( $cekdata[0]) : null;
                            }

                            // Check the one step before
                            $multiSecondaryBefore = DB::table("stocker_input")->selectRaw("
                                    stocker_input.id,
                                    stocker_input.id_qr_stocker,
                                    part_detail_secondary.urutan,
                                    master_secondary.tujuan
                                ")->
                                where('id_qr_stocker', $request->txtqrstocker)->
                                leftJoin("part_detail", "part_detail.id", "=", "stocker_input.part_detail_id")->
                                leftJoin("part_detail_secondary", "part_detail_secondary.part_detail_id", "=", "part_detail.id")->
                                leftJoin("master_secondary", "master_secondary.id", "=",  "part_detail_secondary.master_secondary_id")->
                                where("part_detail_secondary.urutan", "<", $currentPartDetailSecondary->urutan)->
                                orderBy("part_detail_secondary.urutan", "desc")->
                                first();

                            // When there is a step before
                            if ($multiSecondaryBefore) {

                                // When the tujuan is different
                                if ($multiSecondaryBefore->tujuan != $currentPartDetailSecondary->secondary->tujuan) {

                                    // Check Secondary Before on Secondary In (where the secondary should've finished)
                                    $multiSecondaryBeforeSecondaryIn = DB::table("secondary_in_input")->
                                        where("id_qr_stocker", $request->txtqrstocker)->
                                        where("urutan", $multiSecondaryBefore->urutan)->
                                        first();

                                    // When there is secondary in on the step before then
                                    if ($multiSecondaryBeforeSecondaryIn) {

                                        // Return the data
                                        $cekdata =  DB::select("
                                            SELECT
                                                dc.id_qr_stocker,
                                                s.act_costing_ws,
                                                msb.buyer,
                                                COALESCE(a.no_cut, c.no_cut, '-') as no_cut,
                                                msb.styleno as style,
                                                s.color,
                                                COALESCE(msb.size, s.size) size,
                                                COALESCE(CONCAT(p_com.panel, (CASE WHEN p_com.panel_status IS NOT NULL THEN CONCAT(' - ', p_com.panel_status) ELSE '' END)), CONCAT(p.panel, (CASE WHEN p.panel_status IS NOT NULL THEN CONCAT(' - ', p.panel_status) ELSE '' END))) panel,
                                                CONCAT(mp.nama_part, (CASE WHEN pd.part_status IS NOT NULL THEN CONCAT(' - ', pd.part_status) ELSE '' END)) nama_part,
                                                ms.tujuan,
                                                ms.proses lokasi,
                                                COALESCE(sii.id, '-') as in_id,
                                                COALESCE(sii.updated_at, sii.created_at, '-') as waktu_in,
                                                COALESCE(sii.user, '-') as author_in,
                                                ".($multiSecondaryBeforeSecondaryIn->qty_in)." qty_awal,
                                                ifnull(si.id_qr_stocker,'x'),
                                                (pds.urutan) as urutan
                                            from
                                                dc_in_input dc
                                                left join stocker_input s on dc.id_qr_stocker = s.id_qr_stocker
                                                left join master_sb_ws msb on msb.id_so_det = s.so_det_id
                                                left join form_cut_input a on s.form_cut_id = a.id
                                                left join form_cut_reject b on s.form_reject_id = b.id
                                                left join form_cut_piece c on s.form_piece_id = c.id
                                                left join part_detail pd on s.part_detail_id = pd.id
                                                left join part p on p.id = pd.part_id
                                                left join part_detail pd_com on pd_com.id = pd.from_part_detail and pd.part_status = 'complement'
                                                left join part p_com on p_com.id = pd_com.part_id
                                                left join part_detail_secondary pds on pds.part_detail_id = pd.id
                                                left join master_part mp on pd.master_part_id = mp.id
                                                left join master_secondary ms on pds.master_secondary_id = ms.id
                                                left join marker_input mi on a.id_marker = mi.kode
                                                left join secondary_inhouse_in_input sii on dc.id_qr_stocker = sii.id_qr_stocker and sii.urutan = pds.urutan
                                                left join secondary_inhouse_input si on dc.id_qr_stocker = si.id_qr_stocker
                                            where
                                                dc.id_qr_stocker =  '" . $request->txtqrstocker . "' and
                                                ms.tujuan = 'SECONDARY DALAM' and
                                                pds.urutan = '".$currentPartDetailSecondary->urutan."'
                                        ");

                                        return $cekdata && $cekdata[0] ? json_encode( $cekdata[0]) : null;
                                    }
                                }
                                // When the tujuan is the same
                                else {

                                    // Check the before tujuan
                                    $multiSecondaryBeforeSecondary = null;
                                    if ($multiSecondaryBefore->tujuan == 'SECONDARY DALAM') {
                                        $multiSecondaryBeforeSecondary = DB::table("secondary_inhouse_input")->
                                            where("id_qr_stocker", $request->txtqrstocker)->
                                            where("urutan", $multiSecondaryBefore->urutan)->
                                            first();
                                    } else {
                                        $multiSecondaryBeforeSecondary = DB::table("secondary_in_input")->
                                            where("id_qr_stocker", $request->txtqrstocker)->
                                            where("urutan", $multiSecondaryBefore->urutan)->
                                            first();
                                    }

                                    // Return the data
                                    $cekdata =  DB::select("
                                        SELECT
                                            dc.id_qr_stocker,
                                            s.act_costing_ws,
                                            msb.buyer,
                                            COALESCE(a.no_cut, c.no_cut, '-') as no_cut,
                                            msb.styleno as style,
                                            s.color,
                                            COALESCE(msb.size, s.size) size,
                                            COALESCE(CONCAT(p_com.panel, (CASE WHEN p_com.panel_status IS NOT NULL THEN CONCAT(' - ', p_com.panel_status) ELSE '' END)), CONCAT(p.panel, (CASE WHEN p.panel_status IS NOT NULL THEN CONCAT(' - ', p.panel_status) ELSE '' END))) panel,
                                            CONCAT(mp.nama_part, (CASE WHEN pd.part_status IS NOT NULL THEN CONCAT(' - ', pd.part_status) ELSE '' END)) nama_part,
                                            ms.tujuan,
                                            ms.proses lokasi,
                                            COALESCE(sii.id, '-') as in_id,
                                            COALESCE(sii.updated_at, sii.created_at, '-') as waktu_in,
                                            COALESCE(sii.user, '-') as author_in,
                                            '".($multiSecondaryBeforeSecondary->qty_in)."' qty_awal,
                                            ifnull(si.id_qr_stocker,'x'),
                                            (pds.urutan) as urutan
                                        from
                                            dc_in_input dc
                                            left join stocker_input s on dc.id_qr_stocker = s.id_qr_stocker
                                            left join master_sb_ws msb on msb.id_so_det = s.so_det_id
                                            left join form_cut_input a on s.form_cut_id = a.id
                                            left join form_cut_reject b on s.form_reject_id = b.id
                                            left join form_cut_piece c on s.form_piece_id = c.id
                                            left join part_detail pd on s.part_detail_id = pd.id
                                            left join part p on p.id = pd.part_id
                                            left join part_detail pd_com on pd_com.id = pd.from_part_detail and pd.part_status = 'complement'
                                            left join part p_com on p_com.id = pd_com.part_id
                                            left join part_detail_secondary pds on pds.part_detail_id = pd.id
                                            left join master_part mp on pd.master_part_id = mp.id
                                            left join master_secondary ms on pds.master_secondary_id = ms.id
                                            left join marker_input mi on a.id_marker = mi.kode
                                            left join secondary_inhouse_in_input sii on dc.id_qr_stocker = sii.id_qr_stocker and sii.urutan = pds.urutan
                                            left join secondary_inhouse_input si on dc.id_qr_stocker = si.id_qr_stocker
                                        where
                                            dc.id_qr_stocker =  '" . $request->txtqrstocker . "' and
                                            ms.tujuan = 'SECONDARY DALAM' and
                                            pds.urutan = '".$currentPartDetailSecondary->urutan."'
                                    ");

                                    return $cekdata && $cekdata[0] ? json_encode( $cekdata[0]) : null;
                                }
                            } else {
                                $cekdata =  DB::select("
                                    SELECT
                                        dc.id_qr_stocker,
                                        s.act_costing_ws,
                                        msb.buyer,
                                        COALESCE(a.no_cut, c.no_cut, '-') as no_cut,
                                        msb.styleno as style,
                                        s.color,
                                        COALESCE(msb.size, s.size) size,
                                        COALESCE(CONCAT(p_com.panel, (CASE WHEN p_com.panel_status IS NOT NULL THEN CONCAT(' - ', p_com.panel_status) ELSE '' END)), CONCAT(p.panel, (CASE WHEN p.panel_status IS NOT NULL THEN CONCAT(' - ', p.panel_status) ELSE '' END))) panel,
                                        CONCAT(mp.nama_part, (CASE WHEN pd.part_status IS NOT NULL THEN CONCAT(' - ', pd.part_status) ELSE '' END)) nama_part,
                                        dc.tujuan,
                                        dc.lokasi,
                                        COALESCE(sii.id, '-') as in_id,
                                        COALESCE(sii.updated_at, sii.created_at, '-') as waktu_in,
                                        COALESCE(sii.user, '-') as author_in,
                                        COALESCE(sii.qty_in, coalesce(s.qty_ply_mod, s.qty_ply) - dc.qty_reject + dc.qty_replace) qty_awal,
                                        ifnull(si.id_qr_stocker,'x'),
                                        1 as urutan
                                    from dc_in_input dc
                                        left join stocker_input s on dc.id_qr_stocker = s.id_qr_stocker
                                        left join master_sb_ws msb on msb.id_so_det = s.so_det_id
                                        left join form_cut_input a on s.form_cut_id = a.id
                                        left join form_cut_reject b on s.form_reject_id = b.id
                                        left join form_cut_piece c on s.form_piece_id = c.id
                                        left join part_detail pd on s.part_detail_id = pd.id
                                        left join part p on p.id = pd.part_id
                                        left join part_detail pd_com on pd_com.id = pd.from_part_detail and pd.part_status = 'complement'
                                        left join part p_com on p_com.id = pd_com.part_id
                                        left join master_part mp on pd.master_part_id = mp.id
                                        left join marker_input mi on a.id_marker = mi.kode
                                        left join secondary_inhouse_in_input sii on dc.id_qr_stocker = sii.id_qr_stocker and sii.urutan = 1
                                        left join secondary_inhouse_input si on dc.id_qr_stocker = si.id_qr_stocker
                                    where
                                        dc.id_qr_stocker =  '" . $request->txtqrstocker . "' and dc.tujuan = 'SECONDARY DALAM'
                                        and ifnull(si.id_qr_stocker,'x') = 'x'
                                ");

                                return $cekdata && $cekdata[0] ? json_encode( $cekdata[0]) : null;
                            }
                        } else {
                            return "Part Detail Secondary tidak sesuai.";
                        }
                    }
                }
                // Default
                else {
                    $cekdata =  DB::select("
                        SELECT
                            dc.id_qr_stocker,
                            s.act_costing_ws,
                            msb.buyer,
                            COALESCE(a.no_cut, c.no_cut, '-') as no_cut,
                            msb.styleno as style,
                            s.color,
                            COALESCE(msb.size, s.size) size,
                            COALESCE(CONCAT(p_com.panel, (CASE WHEN p_com.panel_status IS NOT NULL THEN CONCAT(' - ', p_com.panel_status) ELSE '' END)), CONCAT(p.panel, (CASE WHEN p.panel_status IS NOT NULL THEN CONCAT(' - ', p.panel_status) ELSE '' END))) panel,
                            CONCAT(mp.nama_part, (CASE WHEN pd.part_status IS NOT NULL THEN CONCAT(' - ', pd.part_status) ELSE '' END)) nama_part,
                            dc.tujuan,
                            dc.lokasi,
                            COALESCE(sii.id, '-') as in_id,
                            COALESCE(sii.updated_at, sii.created_at, '-') as waktu_in,
                            COALESCE(sii.user, '-') as author_in,
                            COALESCE(sii.qty_in, coalesce(s.qty_ply_mod, s.qty_ply) - dc.qty_reject + dc.qty_replace) qty_awal,
                            ifnull(si.id_qr_stocker,'x'),
                            1 as urutan
                        from dc_in_input dc
                            left join stocker_input s on dc.id_qr_stocker = s.id_qr_stocker
                            left join master_sb_ws msb on msb.id_so_det = s.so_det_id
                            left join form_cut_input a on s.form_cut_id = a.id
                            left join form_cut_reject b on s.form_reject_id = b.id
                            left join form_cut_piece c on s.form_piece_id = c.id
                            left join part_detail pd on s.part_detail_id = pd.id
                            left join part p on p.id = pd.part_id
                            left join part_detail pd_com on pd_com.id = pd.from_part_detail and pd.part_status = 'complement'
                            left join part p_com on p_com.id = pd_com.part_id
                            left join master_part mp on pd.master_part_id = mp.id
                            left join marker_input mi on a.id_marker = mi.kode
                            left join secondary_inhouse_in_input sii on dc.id_qr_stocker = sii.id_qr_stocker and sii.urutan = 1
                            left join secondary_inhouse_input si on dc.id_qr_stocker = si.id_qr_stocker
                        where
                            dc.id_qr_stocker =  '" . $request->txtqrstocker . "' and dc.tujuan = 'SECONDARY DALAM'
                            and ifnull(si.id_qr_stocker,'x') = 'x'
                    ");

                    return $cekdata && $cekdata[0] ? json_encode( $cekdata[0]) : null;
                }
            } else {
                return "No Part Detail Found.";
            }
        }

        return "No Stocker Data Found.";
    }
    ```
  </TabItem>
  <TabItem value="saveStocker" label="Simpan Stocker">
    Setelah stocker discan dan **ditentukan qty reject dan replace-nya**  
    ```php title='app\Http\Controllers\DC\SecondaryInhouseOutControllers.php'
    public function store(Request $request)
    {
        $tgltrans = date('Y-m-d');
        $timestamp = Carbon::now();

        $validatedRequest = $request->validate([
            "txtqtyreject" => "required"
        ]);

        $saveinhouse = SecondaryInhouse::create([
            'tgl_trans' => $tgltrans,
            'id_qr_stocker' => $request['txtno_stocker'],
            'qty_awal' => $request['txtqtyawal'],
            'qty_reject' => $request['txtqtyreject'],
            'qty_replace' => $request['txtqtyreplace'],
            'qty_in' => $request['txtqtyawal'] - $request['txtqtyreject'] + $request['txtqtyreplace'],
            'user' => Auth::user()->name,
            'urutan' => $request['txturutan'],
            'ket' => $request['txtket'],
            'created_at' => $timestamp,
            'updated_at' => $timestamp,
        ]);

        DB::update(
            "update stocker_input set status = 'secondary' ".($request->txturutan ? ", urutan = '" . ($request->txturutan + 1) . "'" : "")." where id_qr_stocker = '" . $request->txtno_stocker . "'"
        );

        return array(
            'status' => 300,
            'message' => 'Data Sudah Disimpan',
            'redirect' => '',
            'table' => 'datatable-input',
            'additional' => [],
        );
    }
    ```
  </TabItem>
</Tabs>

:::info

**Proses Stocker** didasarkan pada alokasi yang ditentukan user saat membuat data **Part Detail di modul [Part](/docs/part/1-penjelasan-singkat.md#part)** 

:::

## Secondary IN

![Secondary IN](/assets/images/dc-module/secondary-in.png)

Setelah suatu proses secondary (secondary dalam (inhouse) ataupun secondary luar) dari stocker selesai, stocker akan di-scan di **Secondary IN**.  

![Create Secondary IN](/assets/images/dc-module/create-secondary-in.png)

<Tabs>
  <TabItem value="scanSecondaryIn" label="Scan Secondary IN" default>
    Seperti di Secondary Inhouse, Secondary IN juga menyediakan **conditional** untuk stocker yang melalui **satu**(ketentuan awal) ataupun **lebih**(ketentuan baru) dikarenakan secondary in menampung semua proses secondary (secondary dalam(inhouse) ataupun secondary luar) maka **conditional-nya akan cukup berbeda**, contohnya ketika secondary dalam sudah discan dalam urutan misalnya 2, serta untuk **pengecekan proses urutan stocker** agar prosesnya tidak tumpang tindih satu sama lain. Setelah didapatkan data stocker-nya user bisa menentukan qty reject dan replace-nya. 

    ```php title='App\Http\Controllers\DC\SecondaryInController.php'
    public function cek_data_stocker_in(Request $request)
    {
        $stocker = Stocker::where('id_qr_stocker', $request->txtqrstocker)->first();

        if ($stocker) {
            // Check Part Detail
            $partDetail = $stocker->partDetail;
            if ($partDetail) {


                // Check Part Detail Secondary
                $partDetailSecondary = $partDetail->secondaries;
                if ($partDetailSecondary && $partDetailSecondary->count() > 0) {

                    // If there ain't no urutan
                    if ($stocker->urutan == null) {
                        $cekdata = DB::select("
                            select
                                s.id_qr_stocker,
                                s.act_costing_ws,
                                msb.buyer,
                                COALESCE(a.no_cut, c.no_cut, '-') as no_cut,
                                msb.styleno as style,
                                s.color,
                                COALESCE(msb.size, s.size) size,
                                dc.tujuan,
                                dc.lokasi,
                                COALESCE(CONCAT(p_com.panel, (CASE WHEN p_com.panel_status IS NOT NULL THEN CONCAT(' - ', p_com.panel_status) ELSE '' END)), CONCAT(p.panel, (CASE WHEN p.panel_status IS NOT NULL THEN CONCAT(' - ', p.panel_status) ELSE '' END))) panel,
                                CONCAT(mp.nama_part, (CASE WHEN pd.part_status IS NOT NULL THEN CONCAT(' - ', pd.part_status) ELSE '' END)) nama_part,
                                if(dc.tujuan = 'SECONDARY LUAR', (dc.qty_awal - dc.qty_reject + dc.qty_replace), (si.qty_awal - si.qty_reject + si.qty_replace)) qty_awal,
                                s.lokasi lokasi_tujuan,
                                s.tempat tempat_tujuan,
                                1 urutan,
                                (CASE WHEN max_urutan.max_urutan IS NULL OR (max_urutan.max_urutan IS NOT NULL AND 1 >= max_urutan.max_urutan) THEN 'finish' ELSE 'process' END) status,
                                max_urutan.max_urutan,
                                md.sec_in_stocker,
                                md.sec_in_created_at
                            from
                                (
                                    select dc.id_qr_stocker,ifnull(si.id_qr_stocker,'x') cek_1, ifnull(sii.id_qr_stocker,'x') cek_2, sii.id_qr_stocker sec_in_stocker, sii.created_at sec_in_created_at from dc_in_input dc
                                    left join secondary_inhouse_input si on dc.id_qr_stocker = si.id_qr_stocker
                                    left join secondary_in_input sii on dc.id_qr_stocker = sii.id_qr_stocker
                                    where dc.tujuan = 'SECONDARY DALAM' and
                                    ifnull(si.id_qr_stocker,'x') != 'x'
                                    union
                                    select dc.id_qr_stocker, 'x' cek_1, if(sii.id_qr_stocker is null ,dc.id_qr_stocker,'x') cek_2, sii.id_qr_stocker sec_in_stocker, sii.created_at sec_in_created_at from dc_in_input dc
                                    left join secondary_in_input sii on dc.id_qr_stocker = sii.id_qr_stocker
                                    where dc.tujuan = 'SECONDARY LUAR'
                                ) md
                                left join stocker_input s on md.id_qr_stocker = s.id_qr_stocker
                                left join master_sb_ws msb on msb.id_so_det = s.so_det_id
                                left join form_cut_input a on s.form_cut_id = a.id
                                left join form_cut_reject b on s.form_reject_id = b.id
                                left join form_cut_piece c on s.form_piece_id = c.id
                                left join part_detail pd on s.part_detail_id = pd.id
                                left join part p on p.id = pd.part_id
                                left join part_detail pd_com on pd_com.id = pd.from_part_detail and pd.part_status = 'complement'
                                left join part p_com on p_com.id = pd_com.part_id
                                left join (
                                    select
                                        part_detail_id,
                                        MAX(part_detail_secondary.urutan) max_urutan
                                    from
                                        part_detail_secondary
                                    WHERE
                                        part_detail_secondary.urutan IS NOT NULL
                                    group by
                                        part_detail_id
                                ) max_urutan on max_urutan.part_detail_id = pd.id
                                left join master_part mp on pd.master_part_id = mp.id
                                left join marker_input mi on a.id_marker = mi.kode
                                left join dc_in_input dc on s.id_qr_stocker = dc.id_qr_stocker
                                left join secondary_inhouse_input si on s.id_qr_stocker = si.id_qr_stocker
                            where s.id_qr_stocker = '" . $request->txtqrstocker . "'
                        ");

                        return $cekdata && $cekdata[0] ? json_encode( $cekdata[0]) : null;
                    }

                    // If there is urutan
                    else {

                        // Current Secondary
                        $currentPartDetailSecondary = $partDetailSecondary->where('urutan', $stocker->urutan)->first();

                        // Check the one step before
                        $multiSecondaryBefore = DB::table("stocker_input")->selectRaw("
                                stocker_input.id,
                                stocker_input.id_qr_stocker,
                                part_detail_secondary.urutan,
                                master_secondary.tujuan
                            ")->
                            where('id_qr_stocker', $request->txtqrstocker)->
                            leftJoin("part_detail", "part_detail.id", "=", "stocker_input.part_detail_id")->
                            leftJoin("part_detail_secondary", "part_detail_secondary.part_detail_id", "=", "part_detail.id")->
                            leftJoin("master_secondary", "master_secondary.id", "=",  "part_detail_secondary.master_secondary_id")->
                            where("part_detail_secondary.urutan", "<", $stocker->urutan)->
                            orderBy("part_detail_secondary.urutan", "desc")->
                            first();

                        // Check the step after
                        $multiSecondaryAfter = DB::table("stocker_input")->selectRaw("
                                stocker_input.id,
                                stocker_input.id_qr_stocker,
                                part_detail_secondary.urutan,
                                master_secondary.tujuan
                            ")->
                            where('id_qr_stocker', $request->txtqrstocker)->
                            leftJoin("part_detail", "part_detail.id", "=", "stocker_input.part_detail_id")->
                            leftJoin("part_detail_secondary", "part_detail_secondary.part_detail_id", "=", "part_detail.id")->
                            leftJoin("master_secondary", "master_secondary.id", "=",  "part_detail_secondary.master_secondary_id")->
                            where("part_detail_secondary.urutan", ">", $stocker->urutan)->
                            orderBy("part_detail_secondary.urutan", "desc")->
                            first();

                        // If there is another step
                        if ($currentPartDetailSecondary && $currentPartDetailSecondary->secondary) {

                            // If Secondary Dalam
                            if ($currentPartDetailSecondary->secondary->tujuan == "SECONDARY DALAM") {

                                // Check current secondary inhouse
                                $multiSecondaryCurrentSecondary = DB::table("secondary_inhouse_input")->
                                    where("id_qr_stocker", $request->txtqrstocker)->
                                    where("urutan", $currentPartDetailSecondary->secondary->urutan)->
                                    first();

                                // If there is current secondary
                                if ($multiSecondaryCurrentSecondary) {

                                    // If one step after
                                    if ($multiSecondaryAfter) {

                                        // If it wasn't secondary dalam then
                                        if ($multiSecondaryAfter->tujuan != "SECONDARY DALAM") {

                                            // Return the data for Secondary Dalam
                                            $cekdata = DB::select("
                                                select
                                                    s.id_qr_stocker,
                                                    s.act_costing_ws,
                                                    msb.buyer,
                                                    COALESCE(a.no_cut, c.no_cut, '-') as no_cut,
                                                    msb.styleno as style,
                                                    s.color,
                                                    COALESCE(msb.size, s.size) size,
                                                    ms.tujuan,
                                                    ms.proses lokasi,
                                                    COALESCE(CONCAT(p_com.panel, (CASE WHEN p_com.panel_status IS NOT NULL THEN CONCAT(' - ', p_com.panel_status) ELSE '' END)), CONCAT(p.panel, (CASE WHEN p.panel_status IS NOT NULL THEN CONCAT(' - ', p.panel_status) ELSE '' END))) panel,
                                                    CONCAT(mp.nama_part, (CASE WHEN pd.part_status IS NOT NULL THEN CONCAT(' - ', pd.part_status) ELSE '' END)) nama_part,
                                                    ".$multiSecondaryCurrentSecondary->qty_in." qty_awal,
                                                    s.lokasi lokasi_tujuan,
                                                    s.tempat tempat_tujuan,
                                                    ".$multiSecondaryCurrentSecondary->urutan." as urutan,
                                                    (CASE WHEN max_urutan.max_urutan IS NULL OR (max_urutan.max_urutan IS NOT NULL AND ".$multiSecondaryCurrentSecondary->urutan." >= max_urutan.max_urutan) THEN 'finish' ELSE 'process' END) status
                                                from
                                                    stocker_input
                                                    left join master_sb_ws msb on msb.id_so_det = s.so_det_id
                                                    left join form_cut_input a on s.form_cut_id = a.id
                                                    left join form_cut_reject b on s.form_reject_id = b.id
                                                    left join form_cut_piece c on s.form_piece_id = c.id
                                                    left join part_detail pd on s.part_detail_id = pd.id
                                                    left join part p on p.id = pd.part_id
                                                    left join part_detail pd_com on pd_com.id = pd.from_part_detail and pd.part_status = 'complement'
                                                    left join part p_com on p_com.id = pd_com.part_id
                                                    left join part_detail_secondary pds on pds.part_detail_id = pd.id
                                                    left join master_part mp on pd.master_part_id = mp.id
                                                    left join master_secondary ms on ms.id = pds.master_secondary_id
                                                    left join marker_input mi on a.id_marker = mi.kode
                                                    left join dc_in_input dc on s.id_qr_stocker = dc.id_qr_stocker
                                                    left join secondary_inhouse_input si on s.id_qr_stocker = si.id_qr_stocker
                                                    left join (
                                                        select
                                                            part_detail_id,
                                                            MAX(part_detail_secondary.urutan) max_urutan
                                                        from
                                                            part_detail_secondary
                                                        WHERE
                                                            part_detail_secondary.urutan IS NOT NULL
                                                        group by
                                                            part_detail_id
                                                    ) max_urutan on max_urutan.part_detail_id = pd.id
                                                where
                                                    s.id_qr_stocker = '" . $request->txtqrstocker . "' and
                                                    ms.tujuan = 'SECONDARY DALAM' and
                                                    pds.urutan = '".$multiSecondaryCurrentSecondary->urutan."'
                                            ");

                                            return $cekdata && $cekdata[0] ? json_encode( $cekdata[0]) : null;
                                        }
                                        // If it was secondary dalam
                                        else {
                                            return "Harap langsung scan di secondary dalam untuk proses selanjutnya.";
                                        }
                                    } else {
                                        // Return the data for Secondary Dalam
                                        $cekdata = DB::select("
                                            select
                                                s.id_qr_stocker,
                                                s.act_costing_ws,
                                                msb.buyer,
                                                COALESCE(a.no_cut, c.no_cut, '-') as no_cut,
                                                msb.styleno as style,
                                                s.color,
                                                COALESCE(msb.size, s.size) size,
                                                ms.tujuan,
                                                ms.proses lokasi,
                                                COALESCE(CONCAT(p_com.panel, (CASE WHEN p_com.panel_status IS NOT NULL THEN CONCAT(' - ', p_com.panel_status) ELSE '' END)), CONCAT(p.panel, (CASE WHEN p.panel_status IS NOT NULL THEN CONCAT(' - ', p.panel_status) ELSE '' END))) panel,
                                                CONCAT(mp.nama_part, (CASE WHEN pd.part_status IS NOT NULL THEN CONCAT(' - ', pd.part_status) ELSE '' END)) nama_part,
                                                ".$multiSecondaryCurrentSecondary->qty_in." qty_awal,
                                                s.lokasi lokasi_tujuan,
                                                s.tempat tempat_tujuan,
                                                ".$multiSecondaryCurrentSecondary->urutan." as urutan
                                                (CASE WHEN max_urutan.max_urutan IS NULL OR (max_urutan.max_urutan IS NOT NULL AND ".$multiSecondaryCurrentSecondary->urutan." >= max_urutan.max_urutan) THEN 'finish' ELSE 'process' END) status
                                            from
                                                stocker_input s
                                                left join master_sb_ws msb on msb.id_so_det = s.so_det_id
                                                left join form_cut_input a on s.form_cut_id = a.id
                                                left join form_cut_reject b on s.form_reject_id = b.id
                                                left join form_cut_piece c on s.form_piece_id = c.id
                                                left join part_detail pd on s.part_detail_id = pd.id
                                                left join part p on p.id = pd.part_id
                                                left join part_detail pd_com on pd_com.id = pd.from_part_detail and pd.part_status = 'complement'
                                                left join part p_com on p_com.id = pd_com.part_id
                                                left join part_detail_secondary pds on pds.part_detail_id = pd.id
                                                left join master_part mp on pd.master_part_id = mp.id
                                                left join master_secondary ms on ms.id = pds.master_secondary_id
                                                left join marker_input mi on a.id_marker = mi.kode
                                                left join dc_in_input dc on s.id_qr_stocker = dc.id_qr_stocker
                                                left join secondary_inhouse_input si on s.id_qr_stocker = si.id_qr_stocker
                                                left join (
                                                    select
                                                        part_detail_id,
                                                        MAX(part_detail_secondary.urutan) max_urutan
                                                    from
                                                        part_detail_secondary
                                                    WHERE
                                                        part_detail_secondary.urutan IS NOT NULL
                                                    group by
                                                        part_detail_id
                                                ) max_urutan on max_urutan.part_detail_id = pd.id
                                            where
                                                s.id_qr_stocker = '" . $request->txtqrstocker . "' and
                                                ms.tujuan = 'SECONDARY DALAM' and
                                                pds.urutan = '".$multiSecondaryCurrentSecondary->urutan."'
                                        ");

                                        return $cekdata && $cekdata[0] ? json_encode( $cekdata[0]) : null;
                                    }
                                } else {
                                    return "Secondary Inhouse belum ada";
                                }
                            }
                            // If Secondary Luar
                            else if ($currentPartDetailSecondary->secondary->tujuan == "SECONDARY LUAR") {

                                // When there is a step before
                                if ($multiSecondaryBefore) {

                                    // If Secondary Dalam
                                    if ($multiSecondaryBefore->tujuan == "SECONDARY DALAM") {

                                        // Check current secondary inhouse
                                        $multiSecondaryBeforeSecondary = DB::table("secondary_inhouse_input")->
                                            where("id_qr_stocker", $request->txtqrstocker)->
                                            where("urutan", $multiSecondaryBefore->urutan)->
                                            first();

                                        // If there is secondary inhouse (it should always be there)
                                        if ($multiSecondaryBeforeSecondary) {

                                            // Check the secondary in data
                                            $multiSecondaryBeforeSecondaryIn = DB::table("secondary_in_input")->
                                                where("id_qr_stocker", $request->txtqrstocker)->
                                                where("urutan", $multiSecondaryBefore->urutan)->
                                                first();

                                            // If there is secondary in
                                            if ($multiSecondaryBeforeSecondaryIn) {

                                                // Return the data for Secondary Luar
                                                $cekdata = DB::select("
                                                    select
                                                        s.id_qr_stocker,
                                                        s.act_costing_ws,
                                                        msb.buyer,
                                                        COALESCE(a.no_cut, c.no_cut, '-') as no_cut,
                                                        msb.styleno as style,
                                                        s.color,
                                                        COALESCE(msb.size, s.size) size,
                                                        ms.tujuan,
                                                        ms.proses lokasi,
                                                        COALESCE(CONCAT(p_com.panel, (CASE WHEN p_com.panel_status IS NOT NULL THEN CONCAT(' - ', p_com.panel_status) ELSE '' END)), CONCAT(p.panel, (CASE WHEN p.panel_status IS NOT NULL THEN CONCAT(' - ', p.panel_status) ELSE '' END))) panel,
                                                        CONCAT(mp.nama_part, (CASE WHEN pd.part_status IS NOT NULL THEN CONCAT(' - ', pd.part_status) ELSE '' END)) nama_part,
                                                        ".$multiSecondaryBeforeSecondaryIn->qty_in." qty_awal,
                                                        s.lokasi lokasi_tujuan,
                                                        s.tempat tempat_tujuan,
                                                        ".$currentPartDetailSecondary->urutan." as urutan,
                                                        (CASE WHEN max_urutan.max_urutan IS NULL OR (max_urutan.max_urutan IS NOT NULL AND ".$currentPartDetailSecondary->urutan." >= max_urutan.max_urutan) THEN 'finish' ELSE 'process' END) status
                                                    from
                                                        stocker_input s
                                                        left join master_sb_ws msb on msb.id_so_det = s.so_det_id
                                                        left join form_cut_input a on s.form_cut_id = a.id
                                                        left join form_cut_reject b on s.form_reject_id = b.id
                                                        left join form_cut_piece c on s.form_piece_id = c.id
                                                        left join part_detail pd on s.part_detail_id = pd.id
                                                        left join part p on p.id = pd.part_id
                                                        left join part_detail pd_com on pd_com.id = pd.from_part_detail and pd.part_status = 'complement'
                                                        left join part p_com on p_com.id = pd_com.part_id
                                                        left join part_detail_secondary pds on pds.part_detail_id = pd.id
                                                        left join master_part mp on pd.master_part_id = mp.id
                                                        left join master_secondary ms on ms.id = pds.master_secondary_id
                                                        left join marker_input mi on a.id_marker = mi.kode
                                                        left join dc_in_input dc on s.id_qr_stocker = dc.id_qr_stocker
                                                        left join secondary_inhouse_input si on s.id_qr_stocker = si.id_qr_stocker
                                                        left join (
                                                            select
                                                                part_detail_id,
                                                                MAX(part_detail_secondary.urutan) max_urutan
                                                            from
                                                                part_detail_secondary
                                                            WHERE
                                                                part_detail_secondary.urutan IS NOT NULL
                                                            group by
                                                                part_detail_id
                                                        ) max_urutan on max_urutan.part_detail_id = pd.id
                                                    where
                                                        s.id_qr_stocker = '" . $request->txtqrstocker . "' and
                                                        ms.tujuan = 'SECONDARY LUAR' and
                                                        pds.urutan = '".$currentPartDetailSecondary->urutan."'
                                                ");

                                                return $cekdata && $cekdata[0] ? json_encode( $cekdata[0]) : null;
                                            }
                                            // If there is no secondary in
                                            else {
                                                // Return the data for Secondary Dalam
                                                $cekdata = DB::select("
                                                    select
                                                        s.id_qr_stocker,
                                                        s.act_costing_ws,
                                                        msb.buyer,
                                                        COALESCE(a.no_cut, c.no_cut, '-') as no_cut,
                                                        msb.styleno as style,
                                                        s.color,
                                                        COALESCE(msb.size, s.size) size,
                                                        ms.tujuan,
                                                        ms.proses lokasi,
                                                        COALESCE(CONCAT(p_com.panel, (CASE WHEN p_com.panel_status IS NOT NULL THEN CONCAT(' - ', p_com.panel_status) ELSE '' END)), CONCAT(p.panel, (CASE WHEN p.panel_status IS NOT NULL THEN CONCAT(' - ', p.panel_status) ELSE '' END))) panel,
                                                        CONCAT(mp.nama_part, (CASE WHEN pd.part_status IS NOT NULL THEN CONCAT(' - ', pd.part_status) ELSE '' END)) nama_part,
                                                        ".$multiSecondaryBeforeSecondary->qty_in." qty_awal,
                                                        s.lokasi lokasi_tujuan,
                                                        s.tempat tempat_tujuan,
                                                        ".$multiSecondaryBefore->urutan." as urutan,
                                                        (CASE WHEN max_urutan.max_urutan IS NULL OR (max_urutan.max_urutan IS NOT NULL AND ".$multiSecondaryBefore->urutan." >= max_urutan.max_urutan) THEN 'finish' ELSE 'process' END) status
                                                    from
                                                        stocker_input s
                                                        left join master_sb_ws msb on msb.id_so_det = s.so_det_id
                                                        left join form_cut_input a on s.form_cut_id = a.id
                                                        left join form_cut_reject b on s.form_reject_id = b.id
                                                        left join form_cut_piece c on s.form_piece_id = c.id
                                                        left join part_detail pd on s.part_detail_id = pd.id
                                                        left join part p on p.id = pd.part_id
                                                        left join part_detail pd_com on pd_com.id = pd.from_part_detail and pd.part_status = 'complement'
                                                        left join part p_com on p_com.id = pd_com.part_id
                                                        left join part_detail_secondary pds on pds.part_detail_id = pd.id
                                                        left join master_part mp on pd.master_part_id = mp.id
                                                        left join master_secondary ms on ms.id = pds.master_secondary_id
                                                        left join marker_input mi on a.id_marker = mi.kode
                                                        left join dc_in_input dc on s.id_qr_stocker = dc.id_qr_stocker
                                                        left join secondary_inhouse_input si on s.id_qr_stocker = si.id_qr_stocker
                                                        left join (
                                                            select
                                                                part_detail_id,
                                                                MAX(part_detail_secondary.urutan) max_urutan
                                                            from
                                                                part_detail_secondary
                                                            WHERE
                                                                part_detail_secondary.urutan IS NOT NULL
                                                            group by
                                                                part_detail_id
                                                        ) max_urutan on max_urutan.part_detail_id = pd.id
                                                    where
                                                        s.id_qr_stocker = '" . $request->txtqrstocker . "' and
                                                        ms.tujuan = 'SECONDARY DALAM' and
                                                        pds.urutan = '".$multiSecondaryBefore->urutan."'
                                                ");

                                                return $cekdata && $cekdata[0] ? json_encode( $cekdata[0]) : null;
                                            }
                                        } else {
                                            return "Data belum di scan secondary dalam";
                                        }
                                    } else {
                                        // Check the secondary in data
                                        $multiSecondaryBeforeSecondaryIn = DB::table("secondary_in_input")->
                                            where("id_qr_stocker", $request->txtqrstocker)->
                                            where("urutan", $multiSecondaryBefore->urutan)->
                                            first();

                                        // If there is secondary in
                                        if ($multiSecondaryBeforeSecondaryIn) {

                                            // Return the data for Secondary Luar
                                            $cekdata = DB::select("
                                                select
                                                    s.id_qr_stocker,
                                                    s.act_costing_ws,
                                                    msb.buyer,
                                                    COALESCE(a.no_cut, c.no_cut, '-') as no_cut,
                                                    msb.styleno as style,
                                                    s.color,
                                                    COALESCE(msb.size, s.size) size,
                                                    ms.tujuan,
                                                    ms.proses lokasi,
                                                    COALESCE(CONCAT(p_com.panel, (CASE WHEN p_com.panel_status IS NOT NULL THEN CONCAT(' - ', p_com.panel_status) ELSE '' END)), CONCAT(p.panel, (CASE WHEN p.panel_status IS NOT NULL THEN CONCAT(' - ', p.panel_status) ELSE '' END))) panel,
                                                    CONCAT(mp.nama_part, (CASE WHEN pd.part_status IS NOT NULL THEN CONCAT(' - ', pd.part_status) ELSE '' END)) nama_part,
                                                    ".$multiSecondaryBeforeSecondaryIn->qty_in." qty_awal,
                                                    s.lokasi lokasi_tujuan,
                                                    s.tempat tempat_tujuan,
                                                    ".$currentPartDetailSecondary->urutan." as urutan
                                                    (CASE WHEN max_urutan.max_urutan IS NULL OR (max_urutan.max_urutan IS NOT NULL AND ".$currentPartDetailSecondary->urutan." >= max_urutan.max_urutan) THEN 'finish' ELSE 'process' END) status
                                                from
                                                    stocker_input s
                                                    left join master_sb_ws msb on msb.id_so_det = s.so_det_id
                                                    left join form_cut_input a on s.form_cut_id = a.id
                                                    left join form_cut_reject b on s.form_reject_id = b.id
                                                    left join form_cut_piece c on s.form_piece_id = c.id
                                                    left join part_detail pd on s.part_detail_id = pd.id
                                                    left join part p on p.id = pd.part_id
                                                    left join part_detail pd_com on pd_com.id = pd.from_part_detail and pd.part_status = 'complement'
                                                    left join part p_com on p_com.id = pd_com.part_id
                                                    left join part_detail_secondary pds on pds.part_detail_id = pd.id
                                                    left join master_part mp on pd.master_part_id = mp.id
                                                    left join master_secondary ms on ms.id = pds.master_secondary_id
                                                    left join marker_input mi on a.id_marker = mi.kode
                                                    left join dc_in_input dc on s.id_qr_stocker = dc.id_qr_stocker
                                                    left join secondary_inhouse_input si on s.id_qr_stocker = si.id_qr_stocker
                                                    left join (
                                                        select
                                                            part_detail_id,
                                                            MAX(part_detail_secondary.urutan) max_urutan
                                                        from
                                                            part_detail_secondary
                                                        WHERE
                                                            part_detail_secondary.urutan IS NOT NULL
                                                        group by
                                                            part_detail_id
                                                    ) max_urutan on max_urutan.part_detail_id = pd.id
                                                where
                                                    s.id_qr_stocker = '" . $request->txtqrstocker . "' and
                                                    ms.tujuan = 'SECONDARY LUAR' and
                                                    pds.urutan = '".$currentPartDetailSecondary->urutan."'
                                            ");

                                            return $cekdata && $cekdata[0] ? json_encode( $cekdata[0]) : null;
                                        } else {
                                            return "You should never got here, how could you.";
                                        }
                                    }
                                } else {
                                    $cekdata =  DB::select("
                                        SELECT
                                            dc.id_qr_stocker,
                                            s.act_costing_ws,
                                            msb.buyer,
                                            COALESCE(a.no_cut, c.no_cut, '-') as no_cut,
                                            msb.styleno as style,
                                            s.color,
                                            COALESCE(msb.size, s.size) size,
                                            COALESCE(CONCAT(p_com.panel, (CASE WHEN p_com.panel_status IS NOT NULL THEN CONCAT(' - ', p_com.panel_status) ELSE '' END)), CONCAT(p.panel, (CASE WHEN p.panel_status IS NOT NULL THEN CONCAT(' - ', p.panel_status) ELSE '' END))) panel,
                                            CONCAT(mp.nama_part, (CASE WHEN pd.part_status IS NOT NULL THEN CONCAT(' - ', pd.part_status) ELSE '' END)) nama_part,
                                            dc.tujuan,
                                            dc.lokasi,
                                            coalesce(s.qty_ply_mod, s.qty_ply) - dc.qty_reject + dc.qty_replace qty_awal,
                                            ifnull(si.id_qr_stocker,'x'),
                                            1 as urutan,
                                            (CASE WHEN max_urutan.max_urutan IS NULL OR (max_urutan.max_urutan IS NOT NULL AND 1 >= max_urutan.max_urutan) THEN 'finish' ELSE 'process' END) status,
                                            max_urutan.max_urutan
                                        from dc_in_input dc
                                            left join stocker_input s on dc.id_qr_stocker = s.id_qr_stocker
                                            left join master_sb_ws msb on msb.id_so_det = s.so_det_id
                                            left join form_cut_input a on s.form_cut_id = a.id
                                            left join form_cut_reject b on s.form_reject_id = b.id
                                            left join form_cut_piece c on s.form_piece_id = c.id
                                            left join part_detail pd on s.part_detail_id = pd.id
                                            left join part p on p.id = pd.part_id
                                            left join part_detail pd_com on pd_com.id = pd.from_part_detail and pd.part_status = 'complement'
                                            left join part p_com on p_com.id = pd_com.part_id
                                            left join master_part mp on pd.master_part_id = mp.id
                                            left join marker_input mi on a.id_marker = mi.kode
                                            left join secondary_inhouse_input si on dc.id_qr_stocker = si.id_qr_stocker
                                            left join (
                                                select
                                                    part_detail_id,
                                                    MAX(part_detail_secondary.urutan) max_urutan
                                                from
                                                    part_detail_secondary
                                                WHERE
                                                    part_detail_secondary.urutan IS NOT NULL
                                                group by
                                                    part_detail_id
                                            ) max_urutan on max_urutan.part_detail_id = pd.id
                                        where
                                            dc.id_qr_stocker =  '" . $request->txtqrstocker . "' and dc.tujuan = 'SECONDARY DALAM'
                                            and ifnull(si.id_qr_stocker,'x') = 'x'
                                    ");

                                    return $cekdata && $cekdata[0] ? json_encode( $cekdata[0]) : null;
                                }
                            }
                        }
                        // If there is no current secondary (last step)
                        else {

                            // When there is a step before
                            if ($multiSecondaryBefore) {

                                // If Secondary Dalam
                                if ($multiSecondaryBefore->tujuan == "SECONDARY DALAM") {

                                    // Check the secondary dalam data
                                    $multiSecondaryBeforeSecondary = DB::table("secondary_inhouse_input")->
                                        where("id_qr_stocker", $request->txtqrstocker)->
                                        where("urutan", $multiSecondaryBefore->urutan)->
                                        first();

                                    // If there is secondary dalam
                                    if ($multiSecondaryBeforeSecondary) {

                                        // Check the secondary in data
                                        $multiSecondaryBeforeSecondaryIn = DB::table("secondary_in_input")->
                                            where("id_qr_stocker", $request->txtqrstocker)->
                                            where("urutan", $multiSecondaryBefore->urutan)->
                                            first();

                                        // When there is no secondary in then
                                        if (!$multiSecondaryBeforeSecondaryIn) {

                                            // Return the data for Secondary Dalam
                                            $cekdata = DB::select("
                                                select
                                                    s.id_qr_stocker,
                                                    s.act_costing_ws,
                                                    msb.buyer,
                                                    COALESCE(a.no_cut, c.no_cut, '-') as no_cut,
                                                    msb.styleno as style,
                                                    s.color,
                                                    COALESCE(msb.size, s.size) size,
                                                    ms.tujuan,
                                                    ms.proses lokasi,
                                                    COALESCE(CONCAT(p_com.panel, (CASE WHEN p_com.panel_status IS NOT NULL THEN CONCAT(' - ', p_com.panel_status) ELSE '' END)), CONCAT(p.panel, (CASE WHEN p.panel_status IS NOT NULL THEN CONCAT(' - ', p.panel_status) ELSE '' END))) panel,
                                                    CONCAT(mp.nama_part, (CASE WHEN pd.part_status IS NOT NULL THEN CONCAT(' - ', pd.part_status) ELSE '' END)) nama_part,
                                                    ".$multiSecondaryBeforeSecondary->qty_in." qty_awal,
                                                    s.lokasi lokasi_tujuan,
                                                    s.tempat tempat_tujuan,
                                                    ".$multiSecondaryBefore->urutan." as urutan,
                                                    (CASE WHEN max_urutan.max_urutan IS NULL OR (max_urutan.max_urutan IS NOT NULL AND ".$multiSecondaryBefore->urutan." >= max_urutan.max_urutan) THEN 'finish' ELSE 'process' END) status,
                                                    max_urutan.max_urutan
                                                from
                                                    stocker_input s
                                                    left join master_sb_ws msb on msb.id_so_det = s.so_det_id
                                                    left join form_cut_input a on s.form_cut_id = a.id
                                                    left join form_cut_reject b on s.form_reject_id = b.id
                                                    left join form_cut_piece c on s.form_piece_id = c.id
                                                    left join part_detail pd on s.part_detail_id = pd.id
                                                    left join part p on p.id = pd.part_id
                                                    left join part_detail pd_com on pd_com.id = pd.from_part_detail and pd.part_status = 'complement'
                                                    left join part p_com on p_com.id = pd_com.part_id
                                                    left join part_detail_secondary pds on pds.part_detail_id = pd.id
                                                    left join master_part mp on pd.master_part_id = mp.id
                                                    left join master_secondary ms on ms.id = pds.master_secondary_id
                                                    left join marker_input mi on a.id_marker = mi.kode
                                                    left join dc_in_input dc on s.id_qr_stocker = dc.id_qr_stocker
                                                    left join secondary_inhouse_input si on s.id_qr_stocker = si.id_qr_stocker
                                                    left join (
                                                        select
                                                            part_detail_id,
                                                            MAX(part_detail_secondary.urutan) max_urutan
                                                        from
                                                            part_detail_secondary
                                                        WHERE
                                                            part_detail_secondary.urutan IS NOT NULL
                                                        group by
                                                            part_detail_id
                                                    ) max_urutan on max_urutan.part_detail_id = pd.id
                                                where
                                                    s.id_qr_stocker = '" . $request->txtqrstocker . "' and
                                                    ms.tujuan = 'SECONDARY DALAM' and
                                                    pds.urutan = '".$multiSecondaryBefore->urutan."'
                                            ");

                                            return $cekdata && $cekdata[0] ? json_encode( $cekdata[0]) : null;
                                        } else {
                                            return "Data Secondary In sudah ada";
                                        }
                                    } else {
                                        return "Data Secondary Dalam belum ada";
                                    }
                                } else {
                                    // Check the secondary in data
                                    return "when there is no step after and the step before was secondary in then you could not be able to scan the secondary in again, I mean you got yourself here from secondary in already.";
                                }
                            } else {
                                $cekdata =  DB::select("
                                    SELECT
                                        dc.id_qr_stocker,
                                        s.act_costing_ws,
                                        msb.buyer,
                                        COALESCE(a.no_cut, c.no_cut, '-') as no_cut,
                                        msb.styleno as style,
                                        s.color,
                                        COALESCE(msb.size, s.size) size,
                                        COALESCE(CONCAT(p_com.panel, (CASE WHEN p_com.panel_status IS NOT NULL THEN CONCAT(' - ', p_com.panel_status) ELSE '' END)), CONCAT(p.panel, (CASE WHEN p.panel_status IS NOT NULL THEN CONCAT(' - ', p.panel_status) ELSE '' END))) panel,
                                        CONCAT(mp.nama_part, (CASE WHEN pd.part_status IS NOT NULL THEN CONCAT(' - ', pd.part_status) ELSE '' END)) nama_part,
                                        dc.tujuan,
                                        dc.lokasi,
                                        coalesce(s.qty_ply_mod, s.qty_ply) - dc.qty_reject + dc.qty_replace qty_awal,
                                        ifnull(si.id_qr_stocker,'x'),
                                        1 as urutan
                                    from dc_in_input dc
                                        left join stocker_input s on dc.id_qr_stocker = s.id_qr_stocker
                                        left join master_sb_ws msb on msb.id_so_det = s.so_det_id
                                        left join form_cut_input a on s.form_cut_id = a.id
                                        left join form_cut_reject b on s.form_reject_id = b.id
                                        left join form_cut_piece c on s.form_piece_id = c.id
                                        left join part_detail pd on s.part_detail_id = pd.id
                                        left join part p on p.id = pd.part_id
                                        left join part_detail pd_com on pd_com.id = pd.from_part_detail and pd.part_status = 'complement'
                                        left join part p_com on p_com.id = pd_com.part_id
                                        left join master_part mp on pd.master_part_id = mp.id
                                        left join marker_input mi on a.id_marker = mi.kode
                                        left join secondary_inhouse_input si on dc.id_qr_stocker = si.id_qr_stocker
                                    where
                                        dc.id_qr_stocker =  '" . $request->txtqrstocker . "' and dc.tujuan = 'SECONDARY DALAM'
                                        and ifnull(si.id_qr_stocker,'x') = 'x'
                                ");

                                return $cekdata && $cekdata[0] ? json_encode( $cekdata[0]) : null;
                            }
                        }
                    }
                }
                // Default
                else {
                    $cekdata =  DB::select("
                        select
                            s.id_qr_stocker,
                            s.act_costing_ws,
                            msb.buyer,
                            COALESCE(a.no_cut, c.no_cut, '-') as no_cut,
                            msb.styleno as style,
                            s.color,
                            COALESCE(msb.size, s.size) size,
                            dc.tujuan,
                            dc.lokasi,
                            COALESCE(CONCAT(p_com.panel, (CASE WHEN p_com.panel_status IS NOT NULL THEN CONCAT(' - ', p_com.panel_status) ELSE '' END)), CONCAT(p.panel, (CASE WHEN p.panel_status IS NOT NULL THEN CONCAT(' - ', p.panel_status) ELSE '' END))) panel,
                            CONCAT(mp.nama_part, (CASE WHEN pd.part_status IS NOT NULL THEN CONCAT(' - ', pd.part_status) ELSE '' END)) nama_part,
                            if(dc.tujuan = 'SECONDARY LUAR', (dc.qty_awal - dc.qty_reject + dc.qty_replace), (si.qty_awal - si.qty_reject + si.qty_replace)) qty_awal,
                            s.lokasi lokasi_tujuan,
                            s.tempat tempat_tujuan,
                            md.sec_in_stocker,
                            md.sec_in_created_at
                        from
                            (
                                select dc.id_qr_stocker,ifnull(si.id_qr_stocker,'x') cek_1, ifnull(sii.id_qr_stocker,'x') cek_2, sii.id_qr_stocker sec_in_stocker, sii.created_at sec_in_created_at from dc_in_input dc
                                left join secondary_inhouse_input si on dc.id_qr_stocker = si.id_qr_stocker
                                left join secondary_in_input sii on dc.id_qr_stocker = sii.id_qr_stocker
                                where dc.tujuan = 'SECONDARY DALAM' and
                                ifnull(si.id_qr_stocker,'x') != 'x'
                                union
                                select dc.id_qr_stocker, 'x' cek_1, if(sii.id_qr_stocker is null ,dc.id_qr_stocker,'x') cek_2, sii.id_qr_stocker sec_in_stocker, sii.created_at sec_in_created_at from dc_in_input dc
                                left join secondary_in_input sii on dc.id_qr_stocker = sii.id_qr_stocker
                                where dc.tujuan = 'SECONDARY LUAR'
                            ) md
                            left join stocker_input s on md.id_qr_stocker = s.id_qr_stocker
                            left join master_sb_ws msb on msb.id_so_det = s.so_det_id
                            left join form_cut_input a on s.form_cut_id = a.id
                            left join form_cut_reject b on s.form_reject_id = b.id
                            left join form_cut_piece c on s.form_piece_id = c.id
                            left join part_detail pd on s.part_detail_id = pd.id
                            left join part p on p.id = pd.part_id
                            left join part_detail pd_com on pd_com.id = pd.from_part_detail and pd.part_status = 'complement'
                            left join part p_com on p_com.id = pd_com.part_id
                            left join master_part mp on pd.master_part_id = mp.id
                            left join marker_input mi on a.id_marker = mi.kode
                            left join dc_in_input dc on s.id_qr_stocker = dc.id_qr_stocker
                            left join secondary_inhouse_input si on s.id_qr_stocker = si.id_qr_stocker
                            where s.id_qr_stocker = '" . $request->txtqrstocker . "'
                    ");

                    return $cekdata && $cekdata[0] ? json_encode( $cekdata[0]) : null;
                }
            } else {
                return "No Part Detail Found.";
            }
        }

        return "No Stocker Data Found.";
    }
    ```
  </TabItem>
  <TabItem value="saveSecondaryIn" label="Simpan Secondary IN">
    Setelah stocker di-scan, maka user dapat menentukan qty-nya lalu menyimpan data transaksi dengan klik tombol **Simpan**.
    ```php title='App\Http\Controllers\DC\SecondaryInController.php'
    public function store(Request $request)
    {
        $tgltrans = date('Y-m-d');
        $timestamp = Carbon::now();

        $validatedRequest = $request->validate([
            "txtqtyreject" => "required"
        ]);

        // Check stocker's availability on secondary in
        $checkSecondaryIn = SecondaryIn::where("id_qr_stocker", $request->txtno_stocker)->where('urutan', $request->txturutan)->first();
        if ($checkSecondaryIn) {
            return array(
                'status' => 400,
                'message' => 'Stocker <b>'.$request->txtno_stocker.'</b> '.($request->txturutan ? 'urutan '.$request->txturutan : '').' sudah di scan di secondary in pada tanggal <b>'.$checkSecondaryIn->tgl_trans.'</b>',
                'redirect' => '',
                'table' => 'datatable-input',
                'additional' => [],
            );
        }

        // Check if last step of process
        $lastStep = Stocker::selectRaw("MAX(part_detail_secondary.urutan) as urutan")->
            leftJoin("part_detail_secondary", "part_detail_secondary.part_detail_id", "=", "stocker_input.part_detail_id")->
            where("stocker_input.id_qr_stocker", $request['txtno_stocker'])->
            groupBy("stocker_input.id")->
            value("urutan");

        // Update Rak/Trolley (One Step Before Loading) On Last Step/No Step at all
        if (!$lastStep || $lastStep <= $request->txturutan) {

            // Update Rak
            if ($request['cborak']) {
                $rak = DB::table('rack_detail')
                ->select('id')
                ->where('nama_detail_rak', '=', $request['cborak'])
                ->get();
                $rak_data = $rak ? $rak[0]->id : null;

                $insert_rak = RackDetailStocker::create([
                    'nm_rak' => $request['cborak'],
                    'detail_rack_id' => $rak_data,
                    'stocker_id' => $request['txtno_stocker'],
                    'qty_in' => $request['txtqtyin'],
                    'created_at' => $timestamp,
                    'updated_at' => $timestamp,
                ]);
            }

            // Update Trolley
            if ($request['cbotrolley']) {
                $lastTrolleyStock = TrolleyStocker::select('kode')->orderBy('id', 'desc')->first();
                $trolleyStockNumber = $lastTrolleyStock ? intval(substr($lastTrolleyStock->kode, -5)) + 1 : 1;

                $trolleyStockArr = [];

                $thisStocker = Stocker::whereRaw("id_qr_stocker = '" . $request['txtno_stocker'] . "'")->first();
                $thisTrolley = Trolley::where("nama_trolley", $request['cbotrolley'])->first();
                if ($thisTrolley && $thisStocker) {
                    $trolleyCheck = TrolleyStocker::where('stocker_id', $thisStocker->id)->first();
                    if (!$trolleyCheck) {
                        TrolleyStocker::create([
                            "kode" => "TLS".sprintf('%05s', ($trolleyStockNumber)),
                            "trolley_id" => $thisTrolley->id,
                            "stocker_id" => $thisStocker->id,
                            "status" => "active",
                            "tanggal_alokasi" => date('Y-m-d'),
                        ]);
                    }

                    $thisStocker->status = "trolley";
                    $thisStocker->latest_alokasi = Carbon::now();
                    $thisStocker->save();
                }
            }
        }

        // Save Secondary IN
        $savein = SecondaryIn::updateOrCreate(
            ['id_qr_stocker' => $request['txtno_stocker'], 'urutan' => $request->txturutan],
            [
                'tgl_trans' => $tgltrans,
                'qty_awal' => $request['txtqtyawal'],
                'qty_reject' => $request['txtqtyreject'],
                'qty_replace' => $request['txtqtyreplace'],
                'qty_in' => $request['txtqtyawal'] - $request['txtqtyreject'] + $request['txtqtyreplace'],
                'user' => Auth::user()->name,
                'ket' => $request['txtket'],
                'created_at' => $timestamp,
                'updated_at' => $timestamp,
            ]
        );

        // Update Stocker status
        DB::update(
            "update stocker_input set status = 'non secondary' ".($request->txturutan ? ", urutan = '".(intval($request->txturutan) + 1)."' " : "")." where id_qr_stocker = '" . $request->txtno_stocker . "'"
        );

        return array(
            'status' => 300,
            'message' => 'Data Sudah Disimpan',
            'redirect' => '',
            'table' => 'datatable-input',
            'additional' => [],
        );
    }
    ```
  </TabItem>
</Tabs>

:::info

Perlu diingat **Secondary IN** dengan **Secondary INHOUSE** merupakan **proses yang berbeda**. Dimana **Secondary INHOUSE** merupakan proses **Secondary DALAM (INHOUSE)**, yaitu proses secondary yang ada dan terjadi didalam. Sementara **Secondary IN** merupakan **penerimaan untuk hasil akhir dari setiap proses Secondary** baik itu dari secondary dalam (inhouse) ataupun secondary luar.   

:::

## Alur Proses Secondary

**"Conditional"** dari fungsi di atas didasarkan pada flowchart berikut :  

![dc-process-flow](/assets/images/dc-module/dc-process-flow.png)

:::info

Untuk alur general bisa dilihat secara lengkapnya di **<u>[Alur NDS Figma](https://www.figma.com/board/Tz4RO2HK0G6SgR9bZZJwSa/NDS?node-id=0-1&t=BvV1F13V3Tcf253r-1)</u>**

:::

## Trolley

![trolley](/assets/images/dc-module/trolley.png)

Setelah stocker selesai dari proses-prosesnya, Selanjutnya user akan meng-scan stocker untuk dialokasikan ke suatu **trolley** yang nantinya akan dikirim ke **line**.

![trolley](/assets/images/dc-module/allocate-trolley.png)

Pertama-tama user akan **memilih/meng-scan trolley** untuk menentukan trolley mana yang akan dialokasi. Setelah trolley ditentukan, maka selanjutnya user tinggal **meng-scan stocker-stocker yang akan dialokasi** ke trolley yang sudah ditentukan di awal. 

<Tabs>
  <TabItem value="select-trolley" label="All Trolley" default>
    ```php title='App\Http\Controllers\DC\TrolleyStockerController.php'
    public function storeAllocate(Request $request)
    {
        $validatedRequest = $request->validate([
            "trolley_id" => "required",
            "stocker_id" => "required",
        ]);

        // Generate trolley stock kode
        $lastTrolleyStock = TrolleyStocker::select('kode')->orderBy('id', 'desc')->first();
        $trolleyStockNumber = $lastTrolleyStock ? intval(substr($lastTrolleyStock->kode, -5)) + 1 : 1;

        $stockerData = Stocker::where("id", $validatedRequest["stocker_id"])->first();

        // Get similar stocker data
        $similarStockerData = Stocker::selectRaw("stocker_input.*, COALESCE(master_secondary.tujuan, master_secondary_multi.tujuan) as tujuan, dc_in_input.id dc_id, secondary_in_input.id secondary_id, secondary_inhouse_input.id secondary_inhouse_id, loading_line.id as loading_line_id, loading_line.nama_line as loading_line_name")->
            where(($stockerData->form_piece_id > 0 ? "form_piece_id" : ($stockerData->form_reject_id > 0 ? "form_reject_id" : "form_cut_id")), ($stockerData->form_piece_id > 0 ? $stockerData->form_piece_id : ($stockerData->form_reject_id > 0 ? $stockerData->form_reject_id : $stockerData->form_cut_id)))->
            leftJoin("part_detail", "part_detail.id", "=", "stocker_input.part_detail_id")->
            leftJoin("master_secondary", "master_secondary.id", "=", "part_detail.master_secondary_id")->
            leftJoin(DB::raw("
                (
                    SELECT
                        stocker_input.id_qr_stocker,
                        MAX( part_detail_secondary.urutan ) AS max_urutan
                    FROM
                        stocker_input
                        LEFT JOIN part_detail ON part_detail.id = stocker_input.part_detail_id
                        LEFT JOIN part_detail_secondary ON part_detail_secondary.part_detail_id = stocker_input.part_detail_id
                        LEFT JOIN master_secondary ON master_secondary.id = part_detail_secondary.master_secondary_id
                    GROUP BY
                        id_qr_stocker
                    HAVING
                        MAX( part_detail_secondary.urutan ) IS NOT NULL
                ) as pds
            "), "pds.id_qr_stocker", "=", "stocker_input.id_qr_stocker")->
            leftJoin("part_detail_secondary", function ($join) {
                $join->on("part_detail_secondary.part_detail_id", "=", "stocker_input.part_detail_id");
                $join->on("part_detail_secondary.urutan", "=", "pds.max_urutan");
            })->
            leftJoin(DB::raw("master_secondary as master_secondary_multi"), "master_secondary_multi.id", "=", "part_detail_secondary.master_secondary_id")->
            leftJoin("dc_in_input", "dc_in_input.id_qr_stocker", "=", "stocker_input.id_qr_stocker")->
            leftJoin("secondary_in_input", "secondary_in_input.id_qr_stocker", "=", "stocker_input.id_qr_stocker")->
            leftJoin("secondary_inhouse_input", "secondary_inhouse_input.id_qr_stocker", "=", "stocker_input.id_qr_stocker")->
            leftJoin("loading_line", "loading_line.stocker_id", "=", "stocker_input.id")->
            where("so_det_id", $stockerData->so_det_id)->
            where("group_stocker", $stockerData->group_stocker)->
            where("ratio", $stockerData->ratio)->
            get();

        // Check Incomplete Loading
        $incompleteLoading = $similarStockerData->whereNull("loading_line_id");

        // If there is no incomplete loading then it was loaded
        if ($incompleteLoading->count() < 1) {
            return array(
                'status' => 400,
                'message' => "Stocker sudah di loading ke line",
                'redirect' => '',
                'table' => 'trolley-stock-datatable',
                'callback' => 'clearStockerId();',
                'additional' => [],
            );
        }

        // Incomplete Process
        $incompleteNonSecondary = $similarStockerData->whereIn("tujuan", ["NON SECONDARY", "SECONDARY DALAM", "SECONDARY LUAR"])->
            whereNull("dc_id");

        $incompleteSecondary = $similarStockerData->whereIn("tujuan", ["SECONDARY DALAM", "SECONDARY LUAR"])->
            whereNull("secondary_id");

        if ($incompleteNonSecondary->count() > 0 || $incompleteSecondary->count() > 0) {
            return array(
                'status' => 400,
                'message' =>
                    "Stocker tidak bisa dialokasikan".
                    ($incompleteNonSecondary->count() > 0 ? "<br><br> Stocker belum masuk DC In : <br> <b>".$incompleteNonSecondary->pluck("id_qr_stocker")->implode(", ")."</b> <br> <u><a href='".route("create-dc-in")."' class='text-sb' target='_blank'>Ke DC In</a></u>" : "").
                    ($incompleteSecondary->count() > 0 ? "<br><br> Stocker Secondary belum masuk Secondary In : <br> <b>".$incompleteSecondary->pluck("id_qr_stocker")->implode(", ")."</b> <br> <u><a href='".route("secondary-in")."' class='text-sb' target='_blank'>Ke Secondary In</a></u>" : ""),
                'redirect' => '',
                'table' => 'trolley-stock-datatable',
                'callback' => 'clearStockerId();',
                'additional' => [],
            );
        }

        // Allocate Stocker (Bundle) to Trolley
        $trolleyStockArr = [];
        $i = 0;
        foreach ($similarStockerData as $stocker) {
            array_push($trolleyStockArr, [
                "kode" => "TLS".sprintf('%05s', ($trolleyStockNumber+$i)),
                "trolley_id" => $validatedRequest['trolley_id'],
                "stocker_id" => $stocker['id'],
                "status" => "active",
                "tanggal_alokasi" => date('Y-m-d'),
                "created_at" => Carbon::now(),
                "updated_at" => Carbon::now(),
                "created_by" => Auth::user()->id,
                "created_by_username" => Auth::user()->username
            ]);

            $i++;
        }
        $storeTrolleyStock = TrolleyStocker::upsert($trolleyStockArr, ['stocker_id'], ['trolley_id', 'status', 'tanggal_alokasi', 'created_at', 'updated_at', 'created_by', 'created_by_username']);

        if (count($trolleyStockArr) > 0) {
            // Update Stocker Status After Trolley Stock created
            $updateStocker = Stocker::where(($stockerData->form_piece_id > 0 ? "form_piece_id" : ($stockerData->form_reject_id > 0 ? "form_reject_id" : "form_cut_id")), ($stockerData->form_piece_id > 0 ? $stockerData->form_piece_id : ($stockerData->form_reject_id > 0 ? $stockerData->form_reject_id : $stockerData->form_cut_id)))->
                where("so_det_id", $stockerData->so_det_id)->
                where("group_stocker", $stockerData->group_stocker)->
                where("ratio", $stockerData->ratio)->
                update([
                    "status" => "trolley",
                    "latest_alokasi" => Carbon::now()
                ]);

            if ($updateStocker) {
                return array(
                    'status' => 202,
                    'message' => 'Stocker berhasil dialokasi',
                    'redirect' => '',
                    'table' => 'trolley-stock-datatable',
                    'callback' => 'clearStockerId();',
                    'additional' => [],
                );
            }

            return array(
                'status' => 400,
                'message' => 'Stocker gagal dialokasi',
                'redirect' => '',
                'table' => 'trolley-stock-datatable',
                'callback' => 'clearStockerId();',
                'additional' => [],
            );
        }

        return array(
            'status' => 400,
            'message' => 'Stocker gagal dialokasi',
            'redirect' => '',
            'table' => 'trolley-stock-datatable',
            'callback' => 'clearStockerId();',
            'additional' => [],
        );
    }
    ```
  </TabItem>
  <TabItem value="select-trolley-first" label="Specific Trolley" default>
    ```php title='App\Http\Controllers\DC\TrolleyStockerController.php'
    public function storeAllocateThis(Request $request)
    {
        $validatedRequest = $request->validate([
            "trolley_id" => "required",
            "stocker_id" => "required",
        ]);

        // Generate trolley stock kode
        $lastTrolleyStock = TrolleyStocker::select('kode')->orderBy('id', 'desc')->first();
        $trolleyStockNumber = $lastTrolleyStock ? intval(substr($lastTrolleyStock->kode, -5)) + 1 : 1;

        // Get similar stocker data
        $stockerData = Stocker::where("id", $validatedRequest["stocker_id"])->first();
        $similarStockerData = Stocker::selectRaw("stocker_input.*, COALESCE(master_secondary.tujuan, master_secondary_multi.tujuan) as tujuan, dc_in_input.id dc_id, secondary_in_input.id secondary_id, secondary_inhouse_input.id secondary_inhouse_id, loading_line.id as loading_line_id, loading_line.nama_line as loading_line_name")->
            where(($stockerData->form_piece_id > 0 ? "form_piece_id" : ($stockerData->form_reject_id > 0 ? "form_reject_id" : "form_cut_id")), ($stockerData->form_piece_id > 0 ? $stockerData->form_piece_id : ($stockerData->form_reject_id > 0 ? $stockerData->form_reject_id : $stockerData->form_cut_id)))->
            leftJoin("part_detail", "part_detail.id", "=", "stocker_input.part_detail_id")->
            leftJoin("master_secondary", "master_secondary.id", "=", "part_detail.master_secondary_id")->
            leftJoin(DB::raw("
                (
                    SELECT
                        stocker_input.id_qr_stocker,
                        MAX( part_detail_secondary.urutan ) AS max_urutan
                    FROM
                        stocker_input
                        LEFT JOIN part_detail ON part_detail.id = stocker_input.part_detail_id
                        LEFT JOIN part_detail_secondary ON part_detail_secondary.part_detail_id = stocker_input.part_detail_id
                        LEFT JOIN master_secondary ON master_secondary.id = part_detail_secondary.master_secondary_id
                    GROUP BY
                        id_qr_stocker
                    HAVING
                        MAX( part_detail_secondary.urutan ) IS NOT NULL
                ) as pds
            "), "pds.id_qr_stocker", "=", "stocker_input.id_qr_stocker")->
            leftJoin("part_detail_secondary", function ($join) {
                $join->on("part_detail_secondary.part_detail_id", "=", "part_detail.id");
                $join->on("part_detail_secondary.urutan", "=", "pds.max_urutan");
            })->
            leftJoin(DB::raw("master_secondary as master_secondary_multi"), "master_secondary_multi.id", "=", "part_detail_secondary.master_secondary_id")->
            leftJoin("dc_in_input", "dc_in_input.id_qr_stocker", "=", "stocker_input.id_qr_stocker")->
            leftJoin("secondary_in_input", "secondary_in_input.id_qr_stocker", "=", "stocker_input.id_qr_stocker")->
            leftJoin("secondary_inhouse_input", "secondary_inhouse_input.id_qr_stocker", "=", "stocker_input.id_qr_stocker")->
            leftJoin("loading_line", "loading_line.stocker_id", "=", "stocker_input.id")->
            where("so_det_id", $stockerData->so_det_id)->
            where("group_stocker", $stockerData->group_stocker)->
            where("ratio", $stockerData->ratio)->
            get();

        // Check Incomplete Loading
        $incompleteLoading = $similarStockerData->whereNull("loading_line_id");

        // If there is no incomplete loading then it was loaded
        if ($incompleteLoading->count() < 1) {
            return array(
                'status' => 400,
                'message' => "Stocker sudah di loading ke line",
                'redirect' => '',
                'table' => 'trolley-stock-datatable',
                'callback' => 'clearStockerId();',
                'additional' => [],
            );
        }

        // Incomplete Process
        $incompleteNonSecondary = $similarStockerData->whereIn("tujuan", ["NON SECONDARY", "SECONDARY DALAM", "SECONDARY LUAR"])->
            whereNull("dc_id");

        $incompleteSecondary = $similarStockerData->whereIn("tujuan", ["SECONDARY DALAM", "SECONDARY LUAR"])->
            whereNull("secondary_id");

        if ($incompleteNonSecondary->count() > 0 || $incompleteSecondary->count() > 0) {
            return array(
                'status' => 400,
                'message' =>
                    "Stocker tidak bisa dialokasikan".
                    ($incompleteNonSecondary->count() > 0 ? "<br><br> Stocker belum masuk DC In : <br> <b>".$incompleteNonSecondary->pluck("id_qr_stocker")->implode(", ")."</b> <br> <u><a href='".route("create-dc-in")."' class='text-sb' target='_blank'>Ke DC In</a></u>" : "").
                    ($incompleteSecondary->count() > 0 ? "<br><br> Stocker Secondary belum masuk Secondary In : <br> <b>".$incompleteSecondary->pluck("id_qr_stocker")->implode(", ")."</b> <br> <u><a href='".route("secondary-in")."' class='text-sb' target='_blank'>Ke Secondary In</a></u>" : ""),
                'redirect' => '',
                'table' => 'trolley-stock-datatable',
                'callback' => 'clearStockerId();',
                'additional' => [],
            );
        }

        // Allocate Stocker (Bundle) to Trolley
        $trolleyStockArr = [];
        $i = 0;
        foreach ($similarStockerData as $stocker) {
            array_push($trolleyStockArr, [
                "kode" => "TLS".sprintf('%05s', ($trolleyStockNumber+$i)),
                "trolley_id" => $validatedRequest['trolley_id'],
                "stocker_id" => $stocker['id'],
                "status" => "active",
                "tanggal_alokasi" => date('Y-m-d'),
                "created_by" => Auth::user()->id,
                "created_by_username" => Auth::user()->username
            ]);

            $i++;
        }

        $storeTrolleyStock = TrolleyStocker::upsert($trolleyStockArr, ['stocker_id'], ['trolley_id', 'status', 'tanggal_alokasi', 'created_at', 'updated_at', 'created_by', 'created_by_username']);

        if (count($trolleyStockArr) > 0) {
            $updateStocker = Stocker::where(($stockerData->form_piece_id > 0 ? "form_piece_id" : ($stockerData->form_reject_id > 0 ? "form_reject_id" : "form_cut_id")), ($stockerData->form_piece_id > 0 ? $stockerData->form_piece_id : ($stockerData->form_reject_id > 0 ? $stockerData->form_reject_id : $stockerData->form_cut_id)))->
                where("so_det_id", $stockerData->so_det_id)->
                where("group_stocker", $stockerData->group_stocker)->
                where("ratio", $stockerData->ratio)->
                update([
                    "status" => "trolley",
                    "latest_alokasi" => Carbon::now()
                ]);

            if ($updateStocker) {
                return array(
                    'status' => 202,
                    'message' => 'Stocker berhasil dialokasi',
                    'redirect' => '',
                    'table' => 'trolley-stock-datatable',
                    'callback' => 'trolleyStockDatatableReload(); clearStockerId();',
                    'additional' => [],
                );
            }

            return array(
                'status' => 400,
                'message' => 'Stocker gagal dialokasi',
                'redirect' => '',
                'table' => 'trolley-stock-datatable',
                'callback' => 'trolleyStockDatatableReload(); clearStockerId();',
                'additional' => [],
            );
        }

        return array(
            'status' => 400,
            'message' => 'Stocker gagal dialokasi',
            'redirect' => '',
            'table' => 'trolley-stock-datatable',
            'callback' => 'trolleyStockDatatableReload(); clearStockerId',
            'additional' => [],
        );
    }
    ```
  </TabItem>
</Tabs>

### Send Trolley Stock

Ada dua tujuan untuk pengiriman stok trolley, yaitu **trolley** lagi (trolley lain) dan **line** (loading line)

<Tabs>
  <TabItem value="loadingLine" label="Send to Line" default>
    ![send-trolley-to-line](/assets/images/dc-module/send-trolley-stock.png)

    Ketika user memasuki halaman **Send Trolley Stock**, user bisa menentukan untuk dikirim ke line. Setelah user menentukan untuk dikirim ke **line**, akan muncul daftar pilihan line yang tersedia,  user dapat langsung memilih line ataupun meng-scan line yang dituju. Setelah line tujuan dipilih, selanjutnya user akan memilih **stocker bundle** mana saja yang akan dialokasi dan user juga akan menentukan no. bon sebagai identitas transaksi.
  </TabItem>
  <TabItem value="trolley" label="Send to Trolley">
    ![send-trolley-to-trolley](/assets/images/dc-module/send-trolley-stock-trolley.png)

    Ketika user memasuki halaman Send Trolley Stock, user juga bisa menentukan untuk dikirim ke trolley lain. Setelah user menentukan untuk dikirim ke trolley, akan muncul daftar pilihan trolley yang tersedia, user dapat langsung memilih trolley ataupun meng-scan trolley yang dituju. Setelah trolley tujuan dipilih, selanjutnya user akan memilih stocker bundle mana saja yang akan dialokasi dan user juga akan menentukan no. bon sebagai identitas transaksi.
  </TabItem>
</Tabs>

<Tabs>
    <TabItem value="loading-line-view" label="View">
        ```html title='resources\views\dc\trolley\send-stock-trolley.blade.php'
        <div class="card card-primary h-100">
            <div class="card-header">
                <div class="row align-items-center">
                    <div class="col-6">
                        <h5 class="card-title fw-bold">
                            Kirim Stocker :
                        </h5>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="row justify-content-between mb-3">
                    <div class="col-6">
                        <p>Selected Stocker : <span class="fw-bold" id="selected-row-count-1">0</span></p>
                    </div>
                    <div class="col-6">
                        <div class="d-flex gap-3 justify-content-end">
                            <div>
                                <input type="text" class="form-control" id="no_bon" name="no_bon" value="" placeholder="No. BON">
                            </div>
                            <button type="button" class="btn btn-success btn-sm float-end" onclick="sendToLine(this)"><i class="fa fa-plus fa-sm"></i> Kirim</button>
                        </div>
                    </div>
                </div>

                <!-- Trolley's Stocker List -->
                <div class="table-responsive">
                    <table class="table table table-bordered w-100" id="datatable-trolley-stock">
                        <thead>
                            <tr>
                                <th class="d-none">ID</th>
                                <th>Check</th>
                                <th>No. Stocker</th>
                                <th>No. WS</th>
                                <th>No. Cut</th>
                                <th>Style</th>
                                <th>Color</th>
                                <th>Panel</th>
                                <th>Part</th>
                                <th>Size</th>
                                <th>Qty</th>
                                <th>Range</th>
                                <th>By</th>
                            </tr>
                        </thead>
                        <tbody>
                            @if ($trolleyStocks && $trolleyStocks->count() < 1)
                                {{-- No Data --}}
                            @else
                                @php
                                    $i = 0;
                                @endphp
                                @foreach ($trolleyStocks as $trolleyStock)
                                    <tr>
                                        <td class="d-none">
                                            {{ $trolleyStock->stocker_id }}
                                        </td>
                                        <td>
                                            <div class="form-check" style="scale: 1.5;translate: 50%;margin-top: 10px;">
                                                <input class="form-check-input check-stock" type="checkbox" value="" onchange="checkStock(this)" id="stock_{{ $i }}">
                                            </div>
                                        </div>
                                        </td>
                                        <td>{{ $trolleyStock->id_qr_stocker }}</p></td>
                                        <td>{{ $trolleyStock->act_costing_ws }}</td>
                                        <td>{{ $trolleyStock->no_cut }}</td>
                                        <td>{{ $trolleyStock->style }}</td>
                                        <td>{{ $trolleyStock->color }}</td>
                                        <td>{{ $trolleyStock->panel }}</td>
                                        <td>{{ $trolleyStock->nama_part }}</td>
                                        <td>{{ $trolleyStock->size }}</td>
                                        <td>{{ $trolleyStock->qty }}</td>
                                        <td>{{ $trolleyStock->rangeAwalAkhir }}</td>
                                        <td>{{ $trolleyStock->user }}</td>
                                    </tr>
                                    @php
                                        $i++;
                                    @endphp
                                @endforeach
                            @endif
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        ```
    </TabItem>
    <TabItem value="loading-line-view-js" label="JavaScript">
        ```js title='resources\views\dc\trolley\send-stock-trolley.blade.php'
        <script>
            ...

            // Check Stocker
            var stockArr = [];

            // Check each
            function checkStock(element) {
                let data = $('#datatable-trolley-stock').DataTable().row(element.closest('tr')).data();

                if (data) {
                    if (element.checked) {
                        stockArr.push(data);
                    } else {
                        stockArr = stockArr.filter(item => item[0] != data[0]);
                    }

                    console.log(data, stockArr);

                    updateSelectedSum();
                }
            }

            // Check All
            $("#checkAllStock").on("change", function () {
                document.getElementById("loading").classList.remove("d-none");

                let table = $('#datatable-trolley-stock').DataTable();

                // reset stock arr
                stockArr = [];

                if (this.checked) {
                    // check ALL checkboxes from filtered rows (across all pages)
                    table.rows({ search: 'applied' }).nodes().to$()
                        .find('.check-stock')
                        .prop('checked', true)
                        .each(function () {
                            let data = table.row($(this).closest('tr')).data();
                            stockArr.push(data);
                        });
                } else {
                    // uncheck ALL checkboxes
                    table.rows({ search: 'applied' }).nodes().to$()
                        .find('.check-stock')
                        .prop('checked', false);
                }

                updateSelectedSum();
            });

            // Update checked summary
            function updateSelectedSum() {
                let stockArrSum = stockArr.reduce((acc, row) => acc + Number(row[10]), 0);

                document.getElementById('selected-row-count-1').innerText = stockArr.length+" (Total Qty : "+stockArrSum+")";

                document.getElementById("loading").classList.add("d-none");
            }

            // Reset checked
            function initialSelected() {
                stockArr = [];

                let checkStockElements = document.getElementsByClassName("check-stock");
                for (let i = 0; i < checkStockElements.length; i++) {
                    checkStockElements[i].checked = false;
                }
            }

            // Submit
            async function sendToLine(element) {
                if (!document.getElementById("no_bon").value) {
                    return Swal.fire({
                            icon: 'error',
                            title: 'Gagal',
                            html: 'Harap isi no. bon',
                            showCancelButton: false,
                            showConfirmButton: true,
                            confirmButtonText: 'Oke',
                        }).then(() => {
                            if (isNotNull(res.redirect)) {
                                if (res.redirect != 'reload') {
                                    location.href = res.redirect;
                                } else {
                                    location.reload();
                                }
                            } else {
                                location.reload();
                            }
                        });
                } else {
                    let date = new Date();

                    let day = date.getDate();
                    let month = date.getMonth() + 1;
                    let year = date.getFullYear();

                    let tanggalLoading = `${year}-${month}-${day}`

                    let selectedStockerTable = stockArr;
                    let selectedStocker = [];

                    for (let key in selectedStockerTable) {
                        if (!isNaN(key)) {
                            console.log(selectedStockerTable[key]);
                            selectedStocker.push({
                                stocker_ids: selectedStockerTable[key][0]
                            });
                        }
                    }

                    let lineId = document.getElementById('line_id').value;
                    let destinationTrolleyId = document.getElementById('destination_trolley_id').value;
                    let noBon = document.getElementById('no_bon').value;

                    if (tanggalLoading && selectedStocker.length > 0) {
                        if (document.getElementById("loading")) {
                            document.getElementById("loading").classList.remove("d-none");
                        }

                        element.setAttribute('disabled', true);

                        $.ajax({
                            type: "POST",
                            url: '{!! route('submit-send-trolley-stock') !!}',
                            data: {
                                tanggal_loading: tanggalLoading,
                                selectedStocker: selectedStocker,
                                destination: destination,
                                line_id: lineId,
                                destination_trolley_id: destinationTrolleyId,
                                no_bon: noBon,
                            },
                            success: function(res) {
                                if (document.getElementById("loading")) {
                                    document.getElementById("loading").classList.add("d-none");
                                }

                                element.removeAttribute('disabled');

                                if (res.status == 200) {
                                    document.getElementById("no_bon").value = "";

                                    iziToast.success({
                                        title: 'Success',
                                        message: res.message,
                                        position: 'topCenter'
                                    });
                                } else {
                                    iziToast.error({
                                        title: 'Error',
                                        message: res.message,
                                        position: 'topCenter'
                                    });
                                }

                                if (res.additional) {
                                    let message = "";

                                    if (res.additional['success'].length > 0) {
                                        res.additional['success'].forEach(element => {
                                            message += element['stocker'] + " - Berhasil <br>";
                                        });
                                    }

                                    if (res.additional['fail'].length > 0) {
                                        res.additional['fail'].forEach(element => {
                                            message += element['stocker'] + " - Gagal <br>";
                                        });
                                    }

                                    if (res.additional['exist'].length > 0) {
                                        res.additional['exist'].forEach(element => {
                                            message += element['stocker'] + " - Sudah Ada <br>";
                                        });
                                    }

                                    Swal.fire({
                                        icon: 'info',
                                        title: 'Hasil Transfer',
                                        html: message,
                                        showCancelButton: false,
                                        showConfirmButton: true,
                                        confirmButtonText: 'Oke',
                                    }).then(() => {
                                        if (isNotNull(res.redirect)) {
                                            if (res.redirect != 'reload') {
                                                location.href = res.redirect;
                                            } else {
                                                location.reload();
                                            }
                                        } else {
                                            location.reload();
                                        }
                                    });
                                }
                            },
                            error: function(jqXHR) {
                                if (document.getElementById("loading")) {
                                    document.getElementById("loading").classList.add("d-none");
                                }

                                element.removeAttribute('disabled');

                                iziToast.error({
                                    title: 'Error',
                                    message: 'Terjadi kesalahan.',
                                    position: 'topCenter'
                                });

                                console.log(jqXHR);
                            }
                        })
                    } else {
                        Swal.fire({
                            icon: 'error',
                            title: 'Gagal',
                            html: "Harap pilih line/trolley dan tentukan stocker nya",
                            showCancelButton: false,
                            showConfirmButton: true,
                            confirmButtonText: 'Oke',
                        });
                    }
                }
            }

            ...
            
        </script>
        ``` 
    </TabItem>
    <TabItem value='send-trolley-stock-controller' label='Send Trolley Stock'>
        ```php title='App\Http\Controllers\DC\TrolleyStockerController.php'
        public function submitSend(Request $request) {
            $success = [];
            $fail = [];
            $exist = [];

            $lastLoadingLine = LoadingLine::select('kode')->orderBy("id", "desc")->first();
            $lastLoadingLineNumber = $lastLoadingLine ? intval(substr($lastLoadingLine->kode, -5)) + 1 : 1;

            $lineData = UserLine::where("line_id", $request->line_id)->first();

            // Get costing Data function
            function getCostingDataTrolley($data, $field) {
                if (isset($data->masterSbWs)) {
                    switch ($field) {
                        case "act_costing_id" :
                            $field = "id_act_cost";
                            break;
                        case "act_costing_ws" :
                            $field = "ws";
                            break;
                        case "style" :
                            $field = "styleno";
                            break;
                    }

                    if (isset($data->masterSbWs->{$field})) {
                        return $data->masterSbWs->{$field};
                    }
                } elseif (isset($data->formPiece->{$field})) {
                    return $data->formPiece->{$field};
                } elseif (isset($data->formReject->{$field})) {
                    return $data->formReject->{$field};
                } elseif (isset($data->formCut->marker->{$field})) {
                    return $data->formCut->marker->{$field};
                }
                return null;
            }

            // When Loading to Line
            if ($request->destination != "trolley") {
                foreach ($request->selectedStocker as $req) {
                    $loadingStockArr = [];

                    $stockerIds = explode(',', $req['stocker_ids']);
                    $stockerIdsStr = addQuotesAround(str_replace(', ', ' \n ', $req['stocker_ids']));

                    $stockerData = Stocker::selectRaw("stocker_input.*, COALESCE(multi_secondary.tujuan, master_secondary.tujuan) as tujuan, dc_in_input.id dc_id, secondary_in_input.id secondary_id, secondary_inhouse_input.id secondary_inhouse_id, multi_secondary.max_urutan, multi_secondary.last_in_id as last_in_id")->
                        leftJoin("part_detail", "part_detail.id", "=", "stocker_input.part_detail_id")->
                        leftJoin("master_secondary", "master_secondary.id", "=", "part_detail.master_secondary_id")->
                        leftJoin("dc_in_input", "dc_in_input.id_qr_stocker", "=", "stocker_input.id_qr_stocker")->
                        leftJoin("secondary_in_input", "secondary_in_input.id_qr_stocker", "=", "stocker_input.id_qr_stocker")->
                        leftJoin("secondary_inhouse_input", "secondary_inhouse_input.id_qr_stocker", "=", "stocker_input.id_qr_stocker")->
                        leftJoin(DB::raw("
                            (
                                SELECT
                                    multi_secondary.id_qr_stocker,
                                    multi_secondary.max_urutan,
                                    master_secondary.tujuan,
                                    master_secondary.proses,
                                    COALESCE(secondary_in_input.id, dc_in_input.id) as last_in_id
                                FROM
                                (
                                    SELECT
                                        stocker_input.id_qr_stocker,
                                        part_detail.id as part_detail_id,
                                        MAX(part_detail_secondary.urutan) as max_urutan
                                    FROM stocker_input
                                    LEFT JOIN part_detail ON part_detail.id = stocker_input.part_detail_id
                                    LEFT JOIN part_detail_secondary ON part_detail_secondary.part_detail_id = stocker_input.part_detail_id
                                    WHERE
                                        stocker_input.id is not null
                                        ".(strlen($stockerIdsStr) > 0 ? " and stocker_input.id in (".$stockerIdsStr.") " : "")."
                                    GROUP BY
                                        id_qr_stocker
                                    HAVING
                                        MAX(part_detail_secondary.urutan) is not null
                                ) as multi_secondary
                                left join part_detail_secondary on part_detail_secondary.urutan = multi_secondary.max_urutan and part_detail_secondary.part_detail_id = multi_secondary.part_detail_id
                                left join master_secondary on master_secondary.id = part_detail_secondary.master_secondary_id
                                left join secondary_in_input on secondary_in_input.id_qr_stocker = multi_secondary.id_qr_stocker and secondary_in_input.urutan = multi_secondary.max_urutan and master_secondary.tujuan != 'NON SECONDARY'
                                left join dc_in_input on dc_in_input.id_qr_stocker = multi_secondary.id_qr_stocker and master_secondary.tujuan = 'NON SECONDARY'
                            ) as multi_secondary
                        "), "multi_secondary.id_qr_stocker", "=", "stocker_input.id_qr_stocker")->
                        whereIn("stocker_input.id", $stockerIds)->
                        get();

                    // Check Stocker Processes
                    $incompleteNonSecondary = collect([]);
                    $incompleteSecondary = collect([]);
                    $incompleteMultiMsg = "";
                    foreach($stockerData as $stocker) {
                        if ($stocker->max_urutan == null) {
                            if (($stocker->tujuan == "NON SECONDARY" || $stocker->tujuan == NULL) && $stocker->dc_id == null) {
                                $incompleteNonSecondary->push($stocker);
                            }

                            if ($stocker->tujuan == "SECONDARY" && $stocker->secondary_id == null) {
                                $incompleteSecondary->push($stocker);
                            }
                        } else {
                            if ($stocker->tujuan != "NON SECONDARY" && $stocker->tujuan != NULL) {
                                if ($stocker->urutan < $stocker->max_urutan) {
                                    $incompleteMultiMsg .= "<br><br> Stocker <b>".$stocker->id_qr_stocker."</b> masih di proses ke <b>".($stocker->urutan ?? 1)."/".$stocker->max_urutan."</b> <br> <u><a href='".route("secondary-inhouse")."' class='text-sb' target='_blank'>Ke Secondary Inhouse</a></u> <br> <u><a href='".route("secondary-in")."' class='text-sb' target='_blank'>Ke Secondary In</a></u>";
                                } else {
                                    if (!$stocker->last_in_id) {
                                        $incompleteMultiMsg .= "<br><br> Stocker <b>".$stocker->id_qr_stocker."</b> sudah di proses ke <b>".($stocker->urutan ?? 1)."/".$stocker->max_urutan."</b> belum masuk Secondary IN. <br> <u><a href='".route("secondary-in")."' class='text-sb' target='_blank'>Ke Secondary In</a></u>";
                                    }
                                }
                            } else {
                                if (!$stocker->last_in_id) {
                                    $incompleteNonSecondary->push($stocker);
                                }
                            }
                        }
                    }

                    if ($incompleteNonSecondary->count() > 0 || $incompleteSecondary->count() > 0 || strlen($incompleteMultiMsg) > 0) {
                        return array(
                            'status' => 400,
                            'message' =>
                                "Stocker tidak bisa dialokasikan".
                                ($incompleteNonSecondary->count() > 0 ? "<br><br> Stocker Non Secondary belum masuk DC In : <br> <b>".$incompleteNonSecondary->pluck("id_qr_stocker")->implode(", ")."</b> <br> <u><a href='".route("create-dc-in")."' class='text-sb' target='_blank'>Ke DC In</a></u>" : "").
                                ($incompleteSecondary->count() > 0 ? "<br><br> Stocker Secondary belum masuk Secondary In : <br> <b>".$incompleteSecondary->pluck("id_qr_stocker")->implode(", ")."</b> <br> <u><a href='".route("secondary-in")."' class='text-sb' target='_blank'>Ke Secondary In</a></u>" : "").
                                ($incompleteMultiMsg),
                            'redirect' => '',
                            'table' => 'trolley-stock-datatable',
                            'callback' => 'clearAll()',
                            'additional' => [],
                        );
                    }

                    // BatchId
                    $batchId = Str::uuid()->toString();

                    for ($i = 0; $i < count($stockerIds); $i++) {
                        $thisStockerData = Stocker::where('id', $stockerIds[$i])->first();

                        // Qty
                        $currentQty = 0;

                        $thisStockerPartDetailSecondaries = $thisStockerData->partDetail ? ($thisStockerData->partDetail->secondaries ? $thisStockerData->partDetail->secondaries : null) : null;
                        if ($thisStockerPartDetailSecondaries) {
                            $currentSecondary = $thisStockerPartDetailSecondaries->sortByDesc("urutan")->first();

                            if ($currentSecondary && $currentSecondary->secondary) {
                                if ($currentSecondary->secondary->tujuan != 'NON SECONDARY') {
                                    $currentQty = SecondaryIn::where("id_qr_stocker", $thisStockerData->id_qr_stocker)->where("urutan", $currentSecondary->urutan)->value("qty_in");
                                } else {
                                    $currentDc = DCIn::where("id_qr_stocker", $thisStockerData->id_qr_stocker)->first();
                                    $currentQty = $currentDc->qty_awal - $currentDc->qty_reject + $currentDc->qty_replace;
                                }
                            } else {
                                $currentQty = ($thisStockerData->qty_ply_mod > 0 ? $thisStockerData->qty_ply_mod : $thisStockerData->qty_ply) + ($thisStockerData->dcIn ? ((0 - $thisStockerData->dcIn->qty_reject) + $thisStockerData->dcIn->qty_replace) : 0) + ($thisStockerData->secondaryInHouse ? ((0 - $thisStockerData->secondaryInHouse->qty_reject) + $thisStockerData->secondaryInHouse->qty_replace) : 0) + ($thisStockerData->secondaryIn ? ((0 - $thisStockerData->secondaryIn->qty_reject) + $thisStockerData->secondaryIn->qty_replace) : 0);
                            }
                        } else {
                            $currentQty = ($thisStockerData->qty_ply_mod > 0 ? $thisStockerData->qty_ply_mod : $thisStockerData->qty_ply) + ($thisStockerData->dcIn ? ((0 - $thisStockerData->dcIn->qty_reject) + $thisStockerData->dcIn->qty_replace) : 0) + ($thisStockerData->secondaryInHouse ? ((0 - $thisStockerData->secondaryInHouse->qty_reject) + $thisStockerData->secondaryInHouse->qty_replace) : 0) + ($thisStockerData->secondaryIn ? ((0 - $thisStockerData->secondaryIn->qty_reject) + $thisStockerData->secondaryIn->qty_replace) : 0);
                        }

                        $loadingLinePlan = LoadingLinePlan::where("act_costing_ws", $thisStockerData->act_costing_ws)->where("color", $thisStockerData->color)->where("line_id", $lineData['line_id'])->where("tanggal", $request['tanggal_loading'])->first();

                        $isExist = LoadingLine::where("stocker_id", $stockerIds[$i])->count();
                        if ($isExist < 1) {
                            if ($loadingLinePlan) {
                                array_push($loadingStockArr, [
                                    "kode" => "LOAD".sprintf('%05s', ($lastLoadingLineNumber+$i)),
                                    "line_id" => $lineData['line_id'],
                                    "loading_plan_id" => $loadingLinePlan['id'],
                                    "nama_line" => $lineData['username'],
                                    "stocker_id" => $thisStockerData['id'],
                                    "qty" => $currentQty,
                                    "status" => "active",
                                    "tanggal_loading" => $request['tanggal_loading'],
                                    "no_bon" => $request['no_bon'],
                                    "batch" => $batchId,
                                    "created_at" => Carbon::now(),
                                    "updated_at" => Carbon::now(),
                                    "created_by" => Auth::user()->id,
                                    "created_by_username" => Auth::user()->username,
                                ]);
                            } else {
                                $lastLoadingPlan = LoadingLinePlan::selectRaw("MAX(kode) latest_kode")->first();
                                $lastLoadingPlanNumber = intval(substr($lastLoadingPlan->latest_kode, -5)) + 1;
                                $kodeLoadingPlan = 'LLP'.sprintf('%05s', $lastLoadingPlanNumber);

                                $storeLoadingPlan = LoadingLinePlan::create([
                                    "line_id" => $lineData['line_id'],
                                    "kode" => $kodeLoadingPlan,
                                    "act_costing_id" => getCostingDataTrolley($thisStockerData, "act_costing_id"),
                                    "act_costing_ws" => getCostingDataTrolley($thisStockerData, "act_costing_ws"),
                                    "buyer" => getCostingDataTrolley($thisStockerData, "buyer"),
                                    "style" => getCostingDataTrolley($thisStockerData, "style"),
                                    "color" => getCostingDataTrolley($thisStockerData, "color"),
                                    "tanggal" => $request['tanggal_loading'],
                                    "created_by" => Auth::user()->id,
                                    "created_by_username" => Auth::user()->username,
                                ]);

                                array_push($loadingStockArr, [
                                    "kode" => "LOAD".sprintf('%05s', ($lastLoadingLineNumber+$i)),
                                    "line_id" => $lineData['line_id'],
                                    "loading_plan_id" => $storeLoadingPlan['id'],
                                    "nama_line" => $lineData['username'],
                                    "stocker_id" => $thisStockerData['id'],
                                    "qty" => $currentQty,
                                    "status" => "active",
                                    "tanggal_loading" => $request['tanggal_loading'],
                                    "no_bon" => $request['no_bon'],
                                    "batch" => $batchId,
                                    "created_at" => Carbon::now(),
                                    "updated_at" => Carbon::now(),
                                    "created_by" => Auth::user()->id,
                                    "created_by_username" => Auth::user()->username,
                                ]);
                            }
                        } else {
                            array_push($exist, ['stocker' => $thisStockerData['id']]);
                        }
                    }

                    // Store Loading Stock
                    $storeLoadingStock = LoadingLine::insert($loadingStockArr);
                    // Get Stored Loading Stock
                    $storedLoadingStock = LoadingLine::where('batch', $batchId)->pluck("stocker_id")->toArray();

                    if (count($storedLoadingStock) > 0) {
                        $updateStocker = Stocker::whereIn("id", $storedLoadingStock)->
                            update([
                                "status" => "line",
                                "latest_alokasi" => Carbon::now()
                            ]);

                        $updateTrolleyStocker = TrolleyStocker::whereIn("stocker_id", $storedLoadingStock)->
                            update([
                                "status" => "not active"
                            ]);

                        if ($updateStocker) {
                            array_push($success, ['stocker' => $storedLoadingStock]);
                        } else {
                            array_push($fail, ['stocker' => $storedLoadingStock]);
                        }
                    }
                }
            }

            // When Moving to another Trolley
            else {
                foreach ($request->selectedStocker as $req) {
                    $stockerIds = explode(',', $req['stocker_ids']);

                    $updateStocker = Stocker::whereIn("id", $stockerIds)->
                        update([
                            "latest_alokasi" => Carbon::now()
                        ]);

                    $updateTrolleyStocker = TrolleyStocker::whereIn("stocker_id", $stockerIds)->
                        update([
                            "trolley_id" => $request->destination_trolley_id
                        ]);

                    if ($updateStocker && $updateTrolleyStocker) {
                        array_push($success, ['stocker' => $stockerIds]);
                    } else {
                        array_push($fail, ['stocker' => $stockerIds]);
                    }
                }
            }

            if (count($success) > 0) {
                return array(
                    'status' => 200,
                    'message' => 'Stocker berhasil dikirim',
                    'redirect' => '',
                    'additional' => ["success" => $success, "fail" => $fail, "exist" => $exist],
                );
            } else {
                return array(
                    'status' => 400,
                    'message' => 'Data tidak ditemukan',
                    'redirect' => '',
                    'additional' => ["success" => $success, "fail" => $fail, "exist" => $exist],
                );
            }
        }
        ```
    </TabItem>
</Tabs>