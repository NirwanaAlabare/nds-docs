---
title: Modul
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

Untuk transaksinya berfokus pada gambar dibawah ini :

![Scan DC IN 1](/assets/images/dc-module/create-dc-in-1.png)

<Tabs groupId="dc-process-1">
  <TabItem value="single-assign" label="Single Assignment">
    Setelah klik icon search di tabel (single assignment)

    ![Single Assign](/assets/images/dc-module/create-dc-in-assign.png)

    Akan muncul tampilan seperti diatas, dan dapat ditentukanlah qty-nya dan lokasi/proses selanjutnya (berdasarkan spesifikasi ```part_detail```), jika non-secondary maka akan ditampilkan pilihan rak dan detail lokasinya bisa juga langsung ke troli. Dan jika secondary maka akan ditampilkan pilihan proses secondary yang perlu dilalui selanjutnya. 
  </TabItem>
  <TabItem value="mass-assign" label="Mass Assignment">
    Setelah menceklis stocker dan klik **'edit selected stocker'** (mass assignment)

    ![Mass Assign](/assets/images/dc-module/create-dc-in-assign-1.png)

    Akan muncul tampilan seperti diatas, tidak terdapat kolom untuk menginput qty-nya karena tiap stocker dapat berbeda qty-nya, hanya ada kolom untuk menentukan lokasi/proses selanjutnya (berdasarkan spesifikasi ```part_detail```), jika non-secondary maka akan ditampilkan pilihan rak dan detail lokasinya bisa juga langsung ke troli. Dan jika secondary maka akan ditampilkan pilihan proses secondary yang perlu dilalui selanjutnya. 
  </TabItem>
  <TabItem value="delete-temp-dc" label="Cancel DC Scan">
    Untuk membatalkan scan ke dc cukup dengan menceklis stocker yang akan dibatalkan lalu klik button **'Delete Selected Stocker'**. 
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

```
Query DC
```

Download query dc per-size.

## Secondary Inhouse

Terdapat dua tahap dalam proses secondary inhouse, yaitu **Secondary Inhouse IN** dan **Secondary Inhouse OUT** tapi saat ini **Secondary Inhouse IN belum mandatory**. Maka user hanya perlu **menginput di Secondary Inhouse OUT**. 