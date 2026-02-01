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