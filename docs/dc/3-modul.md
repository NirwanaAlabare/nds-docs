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
    ```php title='App\Http\Controllers\DCInController.php'
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

Ketika user meng-scan stocker ke DC IN maka stocker itu akan dimasukkan ke data temporary.


```php title='App\Http\Controllers\DCInController'
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

![Scan DC IN 1](/assets/images/dc-module/create-dc-in-1.png)

<Tabs groupId="dc-process">
  <TabItem value="single-assign" label="Single Assignment">
    Setelah klik icon search di tabel (single assignment)

    ![Single Assign](/assets/images/dc-module/create-dc-in-assign.png)

    Akan muncul tampilan seperti diatas, dan dapat ditentukanlah qty-nya dan lokasi/proses selanjutnya (berdasarkan spesifikasi ```part_detail```), jika non-secondary maka akan ditampilkan pilihan rak dan detail lokasinya bisa juga langsung ke troli. Dan jika secondary maka akan ditampilkan pilihan proses secondary yang perlu dilalui selanjutnya. 

    ```php title='App\Http\Controllers\DCInController.php'
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

    ```php title='App\Http\Controllers\DCInController.php'
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

Setelah stocker sudah di-assign dan ditentukan qty-nya dengan benar maka tinggal klik **'SIMPAN DC IN'** untuk menyimpan data-nya.

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