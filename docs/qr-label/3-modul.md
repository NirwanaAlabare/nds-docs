---
title: Modul QR Label
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

Ada beberapa modul dari **QR Label** yang perlu diperhatikan. 

## Set Year Sequence

Modul untuk meng-generate **QR Label**, dengan cara meng-scan stocker yang ingin di registrasi ke qr label.

![Set Year Sequence](/assets/images/year-sequence/set-year-sequence.png)

Setelah user meng-scan stocker, maka akan muncul spesifikasi dari stocker, lalu user bisa memilih **year (tahun)**, **sequence** beserta **nomor** yang tersedia. Setelah stocker di registrasi, maka akan muncul list nomor yang ter-registrasi atas stocker tersebut dan secara otomatis akan ter-generate juga file struk registrasi berbentuk pdf seperti berikut : 

![Stock Number](/assets/images/year-sequence/stock-number.png)

Struk tersebut nantinya digunakan untuk identitas setiap nomor yang di-generate di bundle yang sama.

```php title='App\Http\Controllers\StockerController\YearSequenceController'
public function checkYearSequenceNumber(Request $request) {
    ...
}

public function setYearSequenceNumber(Request $request) {
    ...
}

public function checkAllStockNumber(Request $request) {
    ...
}

public function printStockNumber(Request $request) {
    ...
}

public function deleteYearSequence(Request $request) {
    ...
}

public function customMonthCount() {
    ...
}

public function yearSequence() {
    ...
}

public function printYearSequence(Request $request) {
    ...
}

public function printYearSequenceNew(Request $request) {
    ...
}

public function printYearSequenceNewFormat(Request $request) {
    ...
}

public function getStocker(Request $request) {
    ...
}

public function getStockerMonthCount(Request $request) {
    ...
}

public function getStockerYearSequence(Request $request) {
    ...
}

public function getRangeMonthCount(Request $request) {
    ...
}

public function getSequenceYearSequence(Request $request) {
    ...
}

public function getRangeYearSequence(Request $request) {
    ...
}

```

## Registration List 

List Stocker yang telah di registrasi akan muncul di modul ini.

![Registration List](/assets/images/year-sequence/registration-list.png)

User bisa meng-generate ulang struk registrasi ataupun qr label disini. User juga bisa meng-generate **QR Label** sesuai range yang ditentukan, dan kalaupun QR label tersebut belum ter-registrasi, program akan membuat **QR Label mentah** (qr label tanpa spesifikasi produk). Karena biasanya user akan menggenerate qr label secara mentah untuk stock, setelah ada bundle stocker yang siap dialokasi baru user akan registrasikan stocker ke qr label mentah tersebut. 

```php title='App\Http\Controllers\StockerController\YearSequenceController.php'
public function stockerList(Request $request) { 
    ...
}

public function stockerListTotal(Request $request) { 
    ...
}

public function stockerListExport(Request $request) { 
    ...
}

public function stockerListDetail($form_cut_id, $group_stocker, $ratio, $so_det_id, $normal = 1) { 
    ...
}

public function stockerListDetailExport($form_cut_id, $group_stocker, $ratio, $so_det_id, $normal = 1) { 
    ...
}

public function setMonthCountNumber(Request $request) { 
    ...
}

```

## Modify Year Sequence 

Terkadang ada perubahan data ketika label salah registrasi. Maka dbuatlah modul ini.

![Registration List](/assets/images/year-sequence/modify-year-sequence.png)

User bisa meng-generate ulang struk registrasi ataupun qr label disini. User juga bisa meng-generate **QR Label** sesuai range yang ditentukan, dan kalaupun QR label tersebut belum ter-registrasi, program akan membuat **QR Label mentah** (qr label tanpa spesifikasi produk). Karena biasanya user akan menggenerate qr label secara mentah untuk stock, setelah ada bundle stocker yang siap dialokasi baru user akan registrasikan stocker ke qr label mentah tersebut. 

```php title='App\Http\Controllers\StockerController\YearSequenceController'
public function modifyYearSequence(Request $request) {
    ...
}

public function modifyYearSequenceList(Request $request) {
    ...
}

public function modifyYearSequenceUpdate(Request $request, SewingService $sewingService) {
    ...
}

public function modifyYearSequenceDelete(Request $request) {
    ...
}

```
