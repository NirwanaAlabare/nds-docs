---
title: Modul Stocker
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

Stocker hanya memiliki satu table sebagai penampung. Tetapi dalam programnya banyak mengambil referensi dari tabel lain. Stocker memiliki banyak modul yang cukup rumit dan men-detail.

## Stocker 

Stocker baru akan terbentuk tampilannya setelah **data form** dialokasi/masuk kedalam tabel ```part_form```. **Data Form** adalah data yang menjadi dasr bagi stocker. Ketika form telah dialokasi kedalam part_form stocker akan mengambil spesifikasi dari form dan memasangkannya dengan **part group** yang terhubung melalui **part_form**.

Gambar diatas adalah contoh daftar form yang sudah bisa di-generate stocker-nya. Berikut beberapa hal penting dari modul stocker :

### Part Group - Form List

List dari form yang dapat dibuat stocker-nya dapat dilihat melalui modul ```part```.

<div id="part-list"></div>
![Part List](/assets/images/stocker-module/part-list.png)

Dengan klik tombol yang diberi tanda panah di gambar di atas. Akan memunculkan pop-up/modal seperti berikut :

<div id="form-list"></div>
![Form List](/assets/images/stocker-module/form-list.png)

### No. Cut

Setelah form terdaftar di tabel diatas, setiap form akan mendapatkan **no_cut**. Nomor Cuttingan/no_cut adalah nomor yang didapatkan form setelah proses cutting selesai, diurutkan sesuai dengan waktu penyelesaian proses cutting. Form akan diurutkan berdasarkan **Part Group dan Color** yang dimiliki form. Seperti yang ditampilkan dalam tampilan **stocker detail** berikut.

![No. Cutting](/assets/images/stocker-module/no-cut-on-stocker-detail.png)

### Group Gelaran dan Part Detail

Lalu stocker akan mengelompokkan **group gelaran** (hasil dari proses cutting) dan menarik list **part detail** yang terdaftar di part group berdasarkan form melalui part_form 

```
stocker_input.form_cut_id -> form_cut_input.id -> part_form.form_cut_id -> part_form.part_id -> part.id -> part_detail.part_id
```

Lalu menampilkan list group gelaran serta part detail seperti berikut :

![Group Gelaran](/assets/images/stocker-module/group-gelaran-part-detail.png)

<details>
    <summary>Code</summary>
    ```html title="resources\views\stocker-detail.blade.php"
    ... 

    <div class="mb-5">
        <h5 class="fw-bold text-sb mb-3 ps-1">Print Stocker</h5>
        <div class="card">
            <div class="card-body">
                @php
                    $index = 0;
                    $partIndex = 0;

                    $currentGroup = "";
                    $currentGroupStocker = 0;
                    $currentTotal = 0;
                    $currentBefore = 0;
                    $currentModifySize = collect(["so_det_id" => null, "group_stocker" => null, "difference_qty" => null]);

                    $currentModifySizeQty = $modifySizeQty->filter(function ($item) {
                        return !is_null($item->group_stocker);
                    })->count();

                    $groupStockerList = [];
                @endphp
                @foreach ($dataSpreading->formCutInputDetails->where('status', '!=', 'not complete')->sortByDesc('group_roll')->sortByDesc('group_stocker') as $detail)
                    {{-- With group stocker condition --}}

                    @if ($loop->first)
                    {{-- Initial Group --}}
                        @php
                            $currentGroup = $detail->group_roll;
                            $currentGroupStocker = $detail->group_stocker;
                        @endphp
                    @endif

                    @if ($detail->group_stocker != $currentGroupStocker)
                        {{-- Create element when switching group --}}
                        <div class="d-flex gap-3">
                            <div class="mb-3">
                                <label><small>Group</small></label>
                                <input type="text" class="form-control form-control-sm" value="{{ $currentGroup }}" readonly>
                            </div>
                            <div class="mb-3">
                                <label><small>Qty</small></label>
                                <input type="text" class="form-control form-control-sm" value="{{ $currentTotal }}" readonly>
                            </div>
                        </div>
                        @php
                            array_push($groupStockerList, ["group_stocker" => $currentGroupStocker, "qty" => $currentTotal]);
                        @endphp

                        @if ($currentModifySizeQty > 0)
                            @include('stocker.stocker.stocker-detail-part', ["modifySizeQtyStocker" => $modifySizeQty])
                        @else
                            @include('stocker.stocker.stocker-detail-part')
                        @endif
                        @php
                            $index += $dataRatio->count() * $dataPartDetail->count();
                            $partIndex += $dataPartDetail->count();
                        @endphp

                        {{-- Change initial group --}}
                        @php
                            $currentBefore += $currentTotal;

                            $currentGroup = $detail->group_roll;
                            $currentGroupStocker = $detail->group_stocker;
                            $currentTotal = $detail->lembar_gelaran;
                        @endphp

                        {{-- Create last element when it comes to an end of this loop --}}
                        @if ($loop->last)
                            <div class="d-flex gap-3">
                                <div class="mb-3">
                                    <label><small>Group</small></label>
                                    <input type="text" class="form-control form-control-sm" value="{{ $currentGroup }}" readonly>
                                </div>
                                <div class="mb-3">
                                    <label><small>Qty</small></label>
                                    <input type="text" class="form-control form-control-sm" value="{{ $currentTotal }}" readonly>
                                </div>
                            </div>
                            @php
                                array_push($groupStockerList, ["group_stocker" => $currentGroupStocker, "qty" => $currentTotal]);
                            @endphp

                            @include('stocker.stocker.stocker-detail-part', ["modifySizeQtyStocker" => $modifySizeQty])
                            @php
                                $index += $dataRatio->count() * $dataPartDetail->count();
                                $partIndex += $dataPartDetail->count();
                            @endphp
                        @endif
                    @else
                        {{-- Accumulate when it still in the group --}}
                        @php
                            $currentTotal += $detail->lembar_gelaran;
                        @endphp

                        @if ($loop->last)
                        {{-- Create last element when it comes to an end of this loop --}}
                            <div class="d-flex gap-3">
                                <div class="mb-3">
                                    <label><small>Group</small></label>
                                    <input type="text" class="form-control form-control-sm" value="{{ $currentGroup }}" readonly>
                                </div>
                                <div class="mb-3">
                                    <label><small>Qty</small></label>
                                    <input type="text" class="form-control form-control-sm" value="{{ $currentTotal }}" readonly>
                                </div>
                            </div>
                            @php
                                array_push($groupStockerList, ["group_stocker" => $currentGroupStocker, "qty" => $currentTotal]);
                            @endphp

                            @include('stocker.stocker.stocker-detail-part', ["modifySizeQtyStocker" => $modifySizeQty])
                            @php
                                $index += $dataRatio->count() * $dataPartDetail->count();
                                $partIndex += $dataPartDetail->count();
                            @endphp
                        @endif
                    @endif
                @endforeach
            </div>
            <div class="d-flex justify-content-end p-3">
                <button type="button" class="btn btn-danger btn-sm mb-3 w-auto" onclick="generateCheckedStocker()"><i class="fa fa-print"></i> Generate Checked Stocker</button>
            </div>
        </div>
    </div>
    
    ...
    ```
</details>

### Size dan Range

Berdasarkan form, stocker akan mengambil data dari **marker_input_detail** untuk mendapatkan daftar size serta rasionya. Setelah didapatkan daftar size dan rasio, stocker akan memasangkan size dan rasio ke masing masing **group gelaran**. Setelah membuka part detail dalam sebuah group gelaran akan didapatkan tampilan seperti berikut :

![Size dan Range](/assets/images/stocker-module/form-size-range.png) 

Terdapat daftar size beserta rasio (dari marker_detail) dan range-nya. Range adalah qty awal dan akhir yang bersifat kumulatif di setiap form, dengan spesifikasi yang cocok, berdasarkan nomor cut dari form. Misalnya :

<center><div id="size-range-1"><small><i>*Gambar Size-Range No. Cut 1</i></small></div></center>
![Size dan Range 1](/assets/images/stocker-module/size-range-1.png)

Gambar diatas adalah gambaran bagaimana range ditentukan. Berikut gambar untuk lanjutannya.

<center><div id="size-range-2"><small><i>*Gambar Size-Range No. Cut 2</i></small></div></center>
![Size dan Range 2](/assets/images/stocker-module/size-range-2.png)

Gambar diatas merupakan lanjutan dari gambar <u>[Size Range 1](#size-range-1)</u>. Range akan meninjau form sebelumnya yang memiliki spesifikasi serupa (berdasakan *order, color, size*) dengan nomor cut yang paling mendekati form yang dipilih, untuk bisa mendapatkan range yang sesuai.

<details>
    <summary>Code</summary>
    ```html title="resources\views\stocker-detail-part.blade.php"
    @foreach ($dataPartDetail as $partDetail)
        @php
            $generatable = true;
        @endphp
        <div class="accordion-item">
            <div class="d-flex justify-content-between align-items-center">
                <h2 class="accordion-header w-75">
                    <button class="accordion-button accordion-sb collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#panelsStayOpen-{{ $index }}" aria-expanded="false" aria-controls="panelsStayOpen-collapseTwo">
                        <div class="d-flex w-75 justify-content-between align-items-center">
                            <p class="w-25 mb-0">{{ $partDetail->nama_part." - ".$partDetail->bag }}</p>
                            <p class="w-50 mb-0">{{ $partDetail->tujuan." - ".$partDetail->proses }}</p>
                        </div>
                    </button>
                </h2>
                <div class="accordion-header-side col-3">
                    <div class="form-check ms-3">
                        <input class="form-check-input generate-stocker-check generate-{{ $partDetail->id }}" type="checkbox" id="generate_{{ $partIndex }}" name="generate_stocker[{{ $partIndex }}]" data-group="generate-{{ $partDetail->id }}" value="{{ $partDetail->id }}" onchange="massChange(this)" disabled>
                        <label class="form-check-label fw-bold text-sb">
                            Generate Stocker
                        </label>
                    </div>
                </div>
            </div>
            <div id="panelsStayOpen-{{ $index }}" class="accordion-collapse collapse">
                <div class="accordion-body">
                    <div class="table-responsive">
                        <table class="table table-bordered table" id="table-ratio-{{ $index }}">
                            <thead>
                                <th>Size</th>
                                <th>Ratio</th>
                                <th>Qty Cut</th>
                                <th>Range Awal</th>
                                <th>Range Akhir</th>
                                <th>Generated</th>
                                <th>Print Stocker</th>
                                {{-- <th>Print Numbering</th> --}}
                            </thead>
                            <tbody>
                                @foreach ($dataRatio as $ratio)
                                    @php
                                        $currentModify = $currentModifySize ? $currentModifySize->where("group_stocker", "!=", $currentGroupStocker)->where("so_det_id", $ratio->so_det_id)->first() : null;

                                        $qty = intval($ratio->ratio) * intval($currentTotal);
                                        $qtyBefore = (intval($ratio->ratio) * intval($currentBefore)) + ($currentModify ? $currentModify['difference_qty'] : 0);
                                    @endphp

                                    @php
                                        if (isset($modifySizeQtyStocker) && $modifySizeQtyStocker) {
                                            $modifyThisStocker = null;
                                            if ($currentModifySizeQty > 0) {
                                                $modifyThisStocker = $modifySizeQtyStocker->where("group_stocker", $currentGroupStocker)->where("so_det_id", $ratio->so_det_id)->first();
                                            } else {
                                                $modifyThisStocker = $modifySizeQtyStocker->where("so_det_id", $ratio->so_det_id)->first();
                                            }

                                            if ($modifyThisStocker) {
                                                $qty = $qty + $modifyThisStocker->difference_qty;

                                                $currentModifySize->push(["so_det_id" => $ratio->so_det_id, "group_stocker" => $currentGroupStocker, "difference_qty" => $modifyThisStocker->difference_qty]);
                                            }
                                        }

                                        if ($qty > 0) :
                                            $stockerThis = $dataStocker ? $dataStocker->where("so_det_id", $ratio->so_det_id)->where("no_cut", $dataSpreading->no_cut)->where('ratio', '>', '0')->first() : null;
                                            $stockerBefore = $dataStocker ? $dataStocker->where("so_det_id", $ratio->so_det_id)->where("no_cut", "<", $dataSpreading->no_cut)->sortBy([['no_cut', 'desc'],['range_akhir', 'desc']])->filter(function ($item) { return $item->ratio > 0 || ($item->ratio < 1 && $item->difference_qty > 0); })->first() : null;

                                            $rangeAwal = ($dataSpreading->no_cut > 1 ? ($stockerBefore ? ($stockerBefore->stocker_id != null ? $stockerBefore->range_akhir + 1 + ($qtyBefore) : "-") : 1 + ($qtyBefore)) : 1 + ($qtyBefore));
                                            $rangeAkhir = ($dataSpreading->no_cut > 1 ? ($stockerBefore ? ($stockerBefore->stocker_id != null ? $stockerBefore->range_akhir + $qty + ($qtyBefore) : "-") : $qty + ($qtyBefore)) : $qty + ($qtyBefore));
                                            if ($currentGroupStocker == '2') {
                                                // dd($rangeAwal, $rangeAkhir, $stockerBefore->range_akhir, $qtyBefore, $qty);
                                            }
                                    @endphp
                                    <tr>
                                        <input type="hidden" name="part_detail_id[{{ $index }}]" id="part_detail_id_{{ $index }}" value="{{ $partDetail->id }}">
                                        <input type="hidden" name="ratio[{{ $index }}]" id="ratio_{{ $index }}" value="{{ $ratio->ratio }}">
                                        <input type="hidden" name="so_det_id[{{ $index }}]" id="so_det_id_{{ $index }}" value="{{ $ratio->so_det_id }}">
                                        <input type="hidden" name="size[{{ $index }}]" id="size_{{ $index }}" value="{{ $ratio->size }}">
                                        <input type="hidden" name="group[{{ $index }}]" id="group_{{ $index }}" value="{{ $currentGroup }}">
                                        <input type="hidden" name="group_stocker[{{ $index }}]" id="group_stocker_{{ $index }}" value="{{ $currentGroupStocker }}">
                                        <input type="hidden" name="qty_ply_group[{{ $index }}]" id="qty_ply_group_{{ $index }}" value="{{ $currentTotal }}">
                                        <input type="hidden" name="qty_cut[{{ $index }}]" id="qty_cut_{{ $index }}" value="{{ $qty }}">
                                        <input type="hidden" name="range_awal[{{ $index }}]" id="range_awal_{{ $index }}" value="{{ $rangeAwal }}">
                                        <input type="hidden" name="range_akhir[{{ $index }}]" id="range_akhir_{{ $index }}" value="{{ $rangeAkhir }}">

                                        <td>{{ $ratio->size_dest }}</td>
                                        <td>{{ $ratio->ratio }}</td>
                                        <td>{{ (intval($ratio->ratio) * intval($currentTotal)) != $qty ? $qty." (".(intval($ratio->ratio) * intval($currentTotal))."".(($qty - (intval($ratio->ratio) * intval($currentTotal))) > 0 ? "+".($qty - (intval($ratio->ratio) * intval($currentTotal))) : ($qty - (intval($ratio->ratio) * intval($currentTotal)))).")" : $qty }}</td>
                                        <td>{{ $rangeAwal }}</td>
                                        <td>{{ $rangeAkhir }}</td>
                                        <td>
                                            @if ($dataSpreading->no_cut > 1)
                                                @if ($stockerBefore)
                                                    @if ($stockerBefore->stocker_id != null)
                                                        @if ($stockerThis && $stockerThis->stocker_id != null)
                                                            <i class="fa fa-check"></i>
                                                        @else
                                                            <i class="fa fa-times"></i>
                                                        @endif
                                                    @else
                                                        @php $generatable = false; @endphp
                                                        <i class="fa fa-minus"></i>
                                                    @endif
                                                @else
                                                    @if ($stockerThis && $stockerThis->stocker_id != null)
                                                        <i class="fa fa-check"></i>
                                                    @else
                                                        <i class="fa fa-times"></i>
                                                    @endif
                                                @endif
                                            @else
                                                @if ($stockerThis && $stockerThis->stocker_id != null)
                                                    <i class="fa fa-check"></i>
                                                @else
                                                    <i class="fa fa-times"></i>
                                                @endif
                                            @endif
                                        <td>
                                            <button type="button" class="btn btn-sm btn-danger" onclick="printStocker({{ $index }});" {{ ($dataSpreading->no_cut > 1 ? ($stockerBefore ? ($stockerBefore->stocker_id != null ? "" : "disabled") : "") : "") }}>
                                                <i class="fa fa-print fa-s"></i>
                                            </button>
                                        </td>
                                        {{-- <td>
                                            <button type="button" class="btn btn-sm btn-danger" onclick="printNumbering({{ $index }});" {{ ($dataSpreading->no_cut > 1 ? ($stockerBefore ? ($stockerBefore->stocker_id != null ? "" : "disabled") : "") : "") }}>
                                                <i class="fa fa-print fa-s"></i>
                                            </button>
                                        </td> --}}
                                    </tr>
                                    @php
                                            $index++;
                                        endif;
                                    @endphp
                                @endforeach
                            </tbody>
                        </table>
                        <button type="button" class="btn btn-sm btn-danger fw-bold float-end mb-3" onclick="printStockerAllSize('{{ $partDetail->id }}', '{{ $currentGroup }}', '{{ $currentTotal }}');" {{ $generatable ? '' : 'disabled' }}>Generate All Size <i class="fas fa-print"></i></button>
                        <input type="hidden" class="generatable" name="generatable[{{ $partIndex }}]" id="generatable_{{ $partIndex }}" data-group="{{ $partDetail->id }}" value="{{ $generatable }}">
                    </div>
                </div>
            </div>
        </div>

        @php
            $partIndex++;
        @endphp
    @endforeach
    ```
</details>

### Generate Stocker 

Stocker bisa di-generate dengan cara seperti berikut :

![Generate Stocker](/assets/images/stocker-module/generate-stocker.png)

<Tabs>
    <TabItem value="allsize" label="Print Per Size" default>
        ```php title="app\Http\Controllers\StockerController.php"
            public function printStocker(Request $request) 
            {
                ...
            }
        ```
    </TabItem>
    <TabItem value="checked" label="Print All Size">
        ```php title="app\Http\Controllers\StockerController.php"
            public function printStockerAllSize(Request $request) 
            {
                ...
            }
        ```
    </TabItem>
</Tabs>

Atau bisa juga dengan cara bulk (banyak part sekaligus). Dengan cara seperti berikut : 

![Generate Stocker 1](/assets/images/stocker-module/generate-stocker-1.png)

```php title="app\Http\Controllers\StockerController.php"
    public function printStockerChecked(Request $request) 
    {
        ...
    }
```

**Generate Stocker** akan menghasilkan data di tabel ```stocker_input```. Stocker dibuat dengan dasar **form, order, color, size, part_detail hingga rasio**. Setiap detail tadi akan menghasilkan satu data stocker. Setelah berhasil menambahkan data stocker, modul ini akan meng-generate **PDF**-nya, PDF ini nantinya akan di-print lalu dijadikan sebagai identitas dari stok panel yang sesuai, yang sudah terbuat. Setelah stocker di-print, stocker akan bisa diedarkan ke bagian **DC** untuk menempuh proses lain. Berikut gambaran dari **PDF stocker** : 

![Stocker PDF](/assets/images/stocker-module/stocker-pdf.png)

Setiap satu rasio dari stocker akan terbuat satu halaman di pdf seperti diatas. Detail data terkait stocker tertera di pdf tersebut.

### Stocker Detail Tools

Dalam halaman **stocker detail** terdapat beberapa tools yang digunakan untuk menyesuaikan perubahan di lapangan.

![Stocker PDF](/assets/images/stocker-module/stocker-detail-tools.png)

#### 1. Separate Qty

Separate Qty adalah tool yang digunakan untuk menentukan dan memisahkan qty gelaran di masing-masing group, agar dapat sesuai dengan qty aktual di lapangan.    

![Separate Qty](/assets/images/stocker-module/separate-qty-stocker.png)

```php title="app\Http\Controllers\StockerController.php"
    public function separateStocker(Request $request) 
    {
        ...
    }
```


User dapat menambahkan ataupun mengurangi rasio stocker serta qty-nya secara kustom. **Separate Stocker Tool** ini akan menggantikan/menimpa spesifikasi rasio dan qty yang sudah ada di [stocker detail](#size-dan-range). Biasanya user akan menggunakan tool ini jika perubahannya memiliki skala yang cukup besar. Sedangkan untuk perubahan skala kecil yang biasanya disebut dengan *Turun Size / Naik Size* akan menggunakan tool **<u>[Size Qty (Modify Size Qty)](#modify-size-qty)</u>**.

#### 2. No. Stocker

```php title="app\Http\Controllers\StockerController.php"
    public function countStockerUpdate(Request $request) 
    {
        ...
    }
```

Adalah tool yang digunakan untuk meninjau dan mengatur ulang range dari stocker jika tidak sesuai dengan range seharusnya, Biasanya digunakan jika ada perubahan qty pada form sebelumnya yang menyebabkan range harus diatur ulang.

#### 3. Grouping {#grouping}

```php title="app\Http\Controllers\StockerController.php"
    public function rearrangeGroup(Request $request) 
    {
        ...
    }
```

Merupakan tool yang dipakai jika group gelaran tidak sesuai dengan data aktual. Misalnya jika ada qty gelaran group yang terpisah walaupun group-nya sama. Biasanya karena ada perubahan nama group, atau salah ketik disaat user menginput group gelaran. 

#### 4. Modify Size Qty {#modify-size-qty}

```php title="app\Http\Controllers\StockerController.php"
    public function modifySizeQty(Request $request, StockerService $stockerService) 
    {
        ...
    }
```

Tool ini digunakan untuk menurunkan/menaikkan size, misalnya di size **S ada turun size ke size XS**, maka dari **size S akan dikurangi** qty nya dan **size XS akan ditambahkan** qty-nya sesuai kebutuhan. Berikut adalah contoh form untuk mengeksekusi tool **Size Qty (Modify Size Qty)** :

![Size Qty](/assets/images/stocker-module/modify-size-qty.png)

## Stocker Additional

Seperti yang sudah disebutkan di <u>[List Problem Marker - Multi Order Marker](/docs/marker/3-list-masalah.md)</u>. Modul ini dibuat untuk menyediakan ruang untuk order lain agar dapat di-generate stocker-nya. Berikut tampilannya di halaman stocker detail :

![Add Stocker Additional](/assets/images/stocker-module/add-additional-stocker.png)

Dengan mengklik tombol **add additional stocker** user bisa menambahkan order lain untuk disandingkan dengan form yang dipilih. Berikut tampilan form untuk menambahkan additional stocker :

![Add Stocker Additional Form](/assets/images/stocker-module/add-additional-stocker-form.png)

```php title="app\Http\Controllers\StockerController.php"
    public function submitStockerAdd(Request $request) 
    {
        ...
    }
```
Setelah form dilengkapi dan disimpan. List part detail beserta size dan rasio dari order yang dipilih akan muncul, tetapi dengan spesifikasi range, qty dan rasio akan persis dengan spesifikasi form yang dipilih. Berikut contoh tampilan stocker additional : 

![Stocker Additional](/assets/images/stocker-module/additional-stocker.png)

<Tabs>
    <TabItem value="allsize" label="Print All Size" default>
        ```php title="app\Http\Controllers\StockerController.php"
            public function printStockerAllSizeAdd(Request $request) 
            {
                ...
            }
        ```
    </TabItem>
    <TabItem value="checked" label="Print Checked Part">
        ```php title="app\Http\Controllers\StockerController.php"
            public function printStockerCheckedAdd(Request $request) 
            {
                ...
            }
        ```
    </TabItem>
</Tabs>

:::info

Sebagai pembeda untuk stocker additional, akan ada tambahan **note "ADDITIONAL STOCKER"** di detail stocker ```stocker_input.notes``` setelah stocker digenerate .

:::

## Reorder Stocker Numbering

```php title="app\Http\Services\StockerService.php"
    public function reorderStockerNumbering($partId, $color = null) 
    {
        ...
    }
```

Selain tools diatas, ada juga tool **Reorder Stocker Numbering**. Fungsinya untuk **mengurutkan ulang semua form yang berada dalam suatu part group**. Kadang perubahan user di form cutting akan menyebabkan beberapa range menjadi salah atau tidak sesuai, misalnya stocker form yang range-nya tidak melanjutkan form sebelumnya, range yang terlewat, range stocker yang menimpa range stocker lain, nomor cuttingan yang tidak berurutan dsb. Karena prosesnya cukup banyak maka tool ini dibuat agar program dapat memebenarkan range sesuai dengan data yang seharusnya. **Semakin banyak form dalam suatu part group maka proses Reorder Stocker Numbering ini juga akan semakin lama**.

Untuk mengeksekusi tool ini cukup klik tombol **Urutkan Ulang** pada modal pop-up dari detail part di menu part :

![Reorder Stocker Numbering](/assets/images/stocker-module/reorder-stocker-numbering.png)

## Stocker Build 

![stocker-build](/assets/images/stocker-module/stocker-build.png)

Untuk diagram lengkap figma bisa dicek di **<u>[Alur NDS Figma](https://www.figma.com/board/Tz4RO2HK0G6SgR9bZZJwSa/NDS?node-id=0-1&t=BvV1F13V3Tcf253r-1)</u>**