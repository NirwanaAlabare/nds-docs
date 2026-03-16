---
title: Stocker Qty
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

Untuk mendapatkan qty stocker ada beberapa hal yang perlu diperhatikan.

## Stocker Bundle

Untuk mendapatkan qty stocker, perlu dicek terlebih dahulu bundlenya, setiap stocker memiliki bundle. Bundle stocker ditentukan oleh spesifikasi sebagai berikut : 

### form_cut_id 

Dengan kolom ```stocker_input.form_cut_id``` didapatkan identitas asal form dari stocker. Terhubung ke ```form_cut_input.id``` untuk nantinya mendapatkan detail lain dari produk panel;

### group_stocker

```sql 
select 
    group_roll,
    group_stocker,
    SUM(lembar_gelaran) total_lembar
from 
    form_cut_input_detail
where 
    form_cut_input_detail.form_cut_id = 61612
group by 
    group_stocker
order by 
    group_stocker desc 
```

Query diatas adalah contoh query yang digunakan untuk mendapatkan grouping dari form beserta qty lembarannya. Nantinya qty lembaran dari sini akan dikalikan dengan rasio yang terdaftar di ```marker_input_detail.so_det_id``` 

### so_det_id

Kolom ```marker_input_detail.so_det_id``` sebagai identitas detail order dari produk yang akan dihasilkan stocker. Didapatkan dengan cara : 

```sql
select 
	marker_input_detail.id,
	marker_input.act_costing_ws,
	marker_input.color,
	marker_input_detail.so_det_id,
	marker_input_detail.size
from 
	marker_input_detail 
	left join marker_input on marker_input.id = marker_input_detail.marker_id
	left join form_cut_input on form_cut_input.marker_id = marker_input.id 
where 
	form_cut_input.id = 61612
group by 
	marker_input_detail.id 
```

### ratio

Kolom ```marker_input_detail.ratio``` sebagai identitas ratio yang akan terbentuk sesuai dengan yang ditentukan di marker. Contoh query : 

```sql
select 
    marker_input_detail.id,
    marker_input.act_costing_ws,
    marker_input.color,
    marker_input_detail.so_det_id,
    marker_input_detail.size,
    marker_input_detail.ratio
from 
    marker_input_detail 
    left join marker_input on marker_input.id = marker_input_detail.marker_id
    left join form_cut_input on form_cut_input.marker_id = marker_input.id 
where 
    form_cut_input.id = 61612
group by 
    marker_input_detail.id 
```

Query-nya sama saja dengan saat mengambil ```marker_input_detail.so_det_id```. Setiap rasio akan menghasilkan 1 stocker. Misalnya jika suatu ```marker_input_detail.so_det_id``` memiliki ```marker_input_detail.ratio = 3``` maka akan terbentuk 3 baris data ```stocker_input``` berdasarkan dengan atribut lain seperti ```form_cut_input.id``` dan ```part_detail.id```. 

### part_detail_id

Sebagai identitas part dengan kolom ```part_detail.id``` didapatkan dengan cara :

```sql
select 
	part_detail.id,
	master_part.nama_part,
	master_part.bag as bagian_part
from 
	part_detail 
	left join master_part on master_part.id = part_detail.master_part_id 
	left join part on part.id = part_detail.part_id 
	left join part_form on part_form.part_id = part.id
	left join form_cut_input on form_cut_input.id = part_form.form_id 
where 
	form_cut_input.id = 61612
group by 
	part_detail.id
```

Setiap satu ```part_detail.id``` akan masuk ke setiap group yang terbentuk dan dari setiap ```part_detail.id``` akan mendapatkan data bundle yang berdasar pada kolom ```form_cut_input_detail.group_stocker```, ```marker_input_detail.so_det_id```, ```marker_input_detail.ratio```.

## Hasil Stocker

Berdasarkan data-data diatas, akan didapatkan view seperti berikut : 

![Print Stocker](/assets/images/stocker-qty/print-stocker-overview.png)

<Tabs>
    <TabItem value="controller" label="Controller" default>
        ```php title='app\Http\Controllers\Stocker\StockerController.php'
        public function show($formCutId = 0, StockerService $stockerService) {
            ...
        }
        ```
    </TabItem>
    <TabItem value="view" label="View" default>
        ```php title='resources\views\stocker\stocker-detail.blade.php'
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
                    @foreach ($currentDataSpreading->formCutInputDetails->where('status', '!=', 'not complete')->sortByDesc('group_roll')->sortByDesc('group_stocker') as $detail)
                        @if (!$detail->group_stocker)
                        {{-- Without group stocker condition --}}

                            @if ($loop->first)
                            {{-- Initial group --}}
                                @php
                                    $currentGroup = $detail->group_roll;
                                    $currentGroupStocker = $detail->group_stocker;
                                @endphp
                            @endif

                            @if ($detail->group_roll != $currentGroup)
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
                                    @include('stocker.stocker.stocker-detail-part-complement', ["modifySizeQtyStocker" => $modifySizeQty])
                                @else
                                    @include('stocker.stocker.stocker-detail-part-complement')
                                @endif
                                @php
                                    $index += $currentDataRatio->count() * $currentDataPartDetail->count();
                                    $partIndex += $currentDataPartDetail->count();
                                @endphp

                                {{-- Change initial group --}}
                                @php
                                    $currentBefore += $currentTotal;

                                    $currentGroup = $detail->group_roll;
                                    $currentGroupStocker = $detail->group_stocker;
                                    $currentTotal = $detail->lembar_gelaran;

                                    $currentModifySize = $modifySizeQty->where("group_stocker", $currentGroupStocker)->first() ? $modifySizeQty->where("group_stocker", $currentGroupStocker)->first()->difference_qty : 0;
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

                                    @include('stocker.stocker.stocker-detail-part-complement', ["modifySizeQtyStocker" => $modifySizeQty])
                                    @php
                                        $index += $currentDataRatio->count() * $currentDataPartDetail->count();
                                        $partIndex += $currentDataPartDetail->count();
                                    @endphp
                                @endif
                            @else
                                {{-- Accumulate when it still in the same group --}}
                                @php
                                    $currentTotal += $detail->lembar_gelaran;
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

                                    @include('stocker.stocker.stocker-detail-part-complement', ["modifySizeQtyStocker" => $modifySizeQty])
                                    @php
                                        $index += $currentDataRatio->count() * $currentDataPartDetail->count();
                                        $partIndex += $currentDataPartDetail->count();
                                    @endphp
                                @endif
                            @endif
                        @else
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
                                    @include('stocker.stocker.stocker-detail-part-complement', ["modifySizeQtyStocker" => $modifySizeQty])
                                @else
                                    @include('stocker.stocker.stocker-detail-part-complement')
                                @endif
                                @php
                                    $index += $currentDataRatio->count() * $currentDataPartDetail->count();
                                    $partIndex += $currentDataPartDetail->count();
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

                                    @include('stocker.stocker.stocker-detail-part-complement', ["modifySizeQtyStocker" => $modifySizeQty])
                                    @php
                                        $index += $currentDataRatio->count() * $currentDataPartDetail->count();
                                        $partIndex += $currentDataPartDetail->count();
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

                                    @include('stocker.stocker.stocker-detail-part-complement', ["modifySizeQtyStocker" => $modifySizeQty])
                                    @php
                                        $index += $currentDataRatio->count() * $currentDataPartDetail->count();
                                        $partIndex += $currentDataPartDetail->count();
                                    @endphp
                                @endif
                            @endif
                        @endif
                    @endforeach
                </div>
                <div class="d-flex justify-content-end p-3">
                    <button type="button" class="btn btn-danger btn-sm mb-3 w-auto" onclick="generateCheckedStockerCom({{ $i }})"><i class="fa fa-print"></i> Generate Checked Stocker</button>
                </div>
            </div>
        </div>
        ```
    </TabItem>
    <TabItem value="subview" label="Sub-View" default>
        ```php title='resources\views\stocker\stocker-detail-part.blade.php'
        <div class="accordion mb-3" id="accordionPanelsStayOpenExample">
            @php
                $index;
                $partIndex;
            @endphp

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
                                    <p class="w-50 mb-0">{{ $partDetail->proses_tujuan }}</p>
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
                                                    $stockerBefore = $dataStocker ? $dataStocker->where("so_det_id", $ratio->so_det_id)->where("no_cut", "<", $dataSpreading->no_cut)->sortBy([['no_cut', 'desc'],['range_akhir', 'desc']])->filter(function ($item) { return ($item->ratio > 0 && ($item->difference_qty > 0 || $item->difference_qty == null)) || ($item->difference_qty > 0); })->first() : null;

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
        </div>

        ```
    </TabItem>
</Tabs>

Dengan kode diatas dihasilkanlah baris-baris ```stocker_input``` dengan format sebagai berikut : 

```
stocker_input
+ id_qr_stocker -> sebagai identitas stocker
+ part_detail_id -> merujuk ke part_detail.id untuk mendapatkan data part (bagian)
+ form_cut_id -> merujuk ke form_cut_input.id
+ form_reject_id -> merujuk ke form_cut_reject.id jika stockernya berasal dari form cutting reject
+ form_piece_id -> merujuk ke form_cut_piece.id jika stockernya berasal dari form cuttin dengan unit piece
+ act_costing_ws -> notes untuk order
+ so_det_id -> merujuk ke detail order 
+ ratio -> sebagai rasio dari stocker (*stocker ke-) 
+ qty_ply -> untuk qty stockernya 
+ range_awal -> didapatkan secara kumulatif berdasarkan stocker_input.form_cut_id->form_cut_input.id->form_cut_input.no_cut 
+ range_akhir -> range_awal + qty_ply - 1
```

Untuk melihat overview modul print stocker klik <b><u>[disini](/docs/stocker/3-modul.md)</u></b>.

### Stocker Bundle Qty

Dan setelah stocker dibuat, karena tabel stocker hanya ada 1 sedangkan untuk qty stocker yang biasanya akan diambil untuk reporting adalah qty berdasarkan bundle, maka diperlukan query grouping bundle berdasarkan data **<u>[diatas](#stocker-bundle)</u>**. Berikut contoh query dasar stocker (saat ini) :

```sql
SELECT  
    --  uncomment this if you want to check the detail
    -- 	GROUP_CONCAT(id_qr_stocker),
    -- 	GROUP_CONCAT(form_cut_id), 
    -- 	GROUP_CONCAT(form_reject_id), 
    -- 	GROUP_CONCAT(form_piece_id),
    -- 	GROUP_CONCAT(shade),
    -- 	GROUP_CONCAT(group_stocker),
    -- 	GROUP_CONCAT(so_det_id),
    -- 	GROUP_CONCAT(size),
    -- 	GROUP_CONCAT(ratio),
    -- 	GROUP_CONCAT(qty_ply) qty_ply,
    -- 	GROUP_CONCAT(range_awal) range_awal,
    -- 	GROUP_CONCAT(range_akhir) range_akhir,
	so_det_id,
	SUM(qty_ply) qty_stocker
FROM (
	SELECT 
		id_qr_stocker,
		form_cut_id, 
		form_reject_id, 
		form_piece_id,
		shade,
		group_stocker,
		so_det_id,
		size,
		ratio,
		MIN(qty_ply) qty_ply,
		MIN(range_awal) range_awal,
		MAX(range_akhir) range_akhir
	FROM 
		`stocker_input` 
	WHERE 
		stocker_input.updated_at >= '2026-01-01 00:00:00'
	group by 
		form_cut_id, 
		form_reject_id, 
		form_piece_id,
		group_stocker,
		so_det_id,
		ratio
) stocker 
group by 
	so_det_id
```