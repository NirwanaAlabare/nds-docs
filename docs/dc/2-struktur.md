---
title: Struktur Data
---

![Struktur Database DC](/assets/images/struktur-database-dc.jpg)

#### 1. dc_in_input Table

Merupakan tabel untuk menampung data yang masuk ke DC, DC IN adalah proses pertama di modul DC. Tabel ini menampung kolom **id_qr_stocker** sebagai penghubung ke tabel **stocker_input**, dan kolom utamanya adalah 
**qty_awal, qty_reject dan qty_replace**, dengan menghitung rumus berikut sebagai qty in dari DC : 
```
qty_in = qty_awal - qty_reject + qty_replace
```

#### 2. secondary_inhouse_input Table

Merupakan tabel untuk menampung data yang masuk ke Secondary Inhouse (Secondary DALAM), Secondary Inhouse adalah proses tambahan bagi part yang terdaftar. Mirip dengan tabel **dc_in_input** tabel ini menampung kolom **id_qr_stocker** sebagai penghubung ke tabel **stocker_input**, dan kolom utamanya adalah **qty_awal, qty_reject dan qty_replace** hanya saja tabel ini memiliki kolom **qty_in** sebagai penampung dari hasilnya, didapat dengan menghitung rumus berikut sebagai qty in dari Secondary Inhouse : 
```
qty_in = qty_awal - qty_reject + qty_replace
```
Sama dengan DC

:::info
Terdapat juga tabel **secondary_inhouse_in_input**, hanya saja posisinya masih belum jelas, dan belum mandatory, fungsinya untuk menampung data stocker yang masuk ke secondary_inhouse
:::

#### 3. secondary_in_input Table

Merupakan tabel untuk menampung data yang masuk ke Secondary IN, Secondary IN adalah proses tambahan setelah Secondary Inhouse ataupun Secondary Luar (Tidak ada modulnya). Mirip dengan tabel **secondary_inhouse_input** tabel ini menampung kolom **id_qr_stocker** sebagai penghubung ke tabel **stocker_input**, dan kolom utamanya adalah **qty_awal, qty_reject dan qty_replace** hanya saja tabel ini memiliki kolom **qty_in** sebagai penampung dari hasilnya, didapat dengan menghitung rumus berikut sebagai qty in dari Secondary Inhouse : 
```
qty_in = qty_awal - qty_reject + qty_replace
```

#### 4. rack 

Merupakan tabel master dari group rak.

#### 5.rack_detail

Adalah tabel child dari **rack**. Tabel ini yang menampung data detail dari lokasi rak.

#### 6. rack_detail_stocker

Sebagai penghubung tabel **stocker_input** dengan tabel **rack_detail**. Merupakan tabel yang digunakan untuk menyimpan data alokasi rak dari stocker. Menggunakan kolom ```stocker_id``` untuk penghubung ke ```stocker_input.id```.

#### 7. trolley 

Berisi data master trolley.

#### 8. trolley_stocker

Sebagai penghubung tabel **stocker_input** dengan tabel **trolley**. Merupakan tabel yang digunakan untuk menyimpan data alokasi trolley dari stocker, agar nantinya dapat dimasukkan ke tabel **loading_line**. Menggunakan kolom ```stocker_id``` untuk penghubung ke ```stocker_input.id```.

#### 9. loading_line_plan

Adalah tabel yang menampung data **planning** berdasarkan line beserta order yang sedang berjalan. Memiliki kolom **target_sewing dan target_loading** untuk melihat patokan loading.

#### 10. loading_line

Merupakan Tabel yang menampung data **transaksi stocker dalam proses loading** agar didapatkan data : kemana (line) suatu stocker dialokasi. Terdapat kolom ```stocker_id``` sebagai penghubung ke ```stocker_input.id```. Tabel ini juga merupakan child dari **loading_line_plan** berdasarkan **tanggal, line dan ordernya**.