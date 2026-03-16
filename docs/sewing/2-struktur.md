---
title: Struktur Data Sewing
---

## Output Sewing

![Struktur Database Sewing](/assets/images/Sewing-Output-ERDiagram.jpg)

Untuk data **Sewing Output** digunakan database yang berbeda dari database utama, yaitu database ```signalbit_erp```. Database tersebut merupakan database dari aplikasi ERP terdahulu yaitu **SignalBit**, agar mudah terhubung dengan data **Purchasing** yang masih menggunakan aplikasi SignalBit.

### act_costing 

Merupakan tabel yang digunakan untuk menampung data dasar order. Berisi informasi utama dari suatu Order seperti WorkSheet (WS/kpno), Style (styleno) yang terhubung ke tabel ```so_det``` melalui tabel ```so``` untuk medapatkan detail isi dari Order seperti ```size``` dan ```color```, terhubung juga ke tabel ```mastersupplier``` sebagai penampung data master dari Buyer/Supplier.

### so 

Merupakan child table dari ```act_costing``` sebagai penampung detail order group. 

### so_det

Merupakan child table dari ```so``` sebagai penampung detail dari order seperti ```size``` dan ```color```.

### mastersupplier 

Adalah tabel yang menampung data ```Buyer/Supplier``` sebagai identitas pemilik dari order di ```act_costing```.

### master_plan 

Adalah tabel yang dibuat agar user (QC) dapat menginputkan output dari sewing sesuai plan yang ditentukan di tiap harinya. Dengan berbagai kolom yang nantinya akan menentukan target dari setiap line yang terdaftar. Terhubung ke tabel ```userpassword```.

```master_plan.sewing_line = userpassword.username (User dengan Groupp = SEWING)```

### userpassword 

Tabel yang menampung data user yang dapat login ke ERP SignalBit, namun dalam modul NDS hanya menggunakan user dengan ```Groupp``` tertentu. dalam kasus ini digunakan untuk **Master Line**.

### user_sb_wip 

Menampung data username dan password yang dapat digunakan untuk login ke modul **Input Sewing Output**. Memiliki kolom ```line_id``` sebagai identitas **Line dari user** yang mengambil referensi dari tabel ```userpassword``` dengan ```userpassword.line_id = user_sb_wip.line_id```

### output_defect_types 

Merupakan tabel yang menampung data master dari **Jenis Defect (Cacat)** yang terdaftar.

### output_defect_areas 

Merupakan tabel yang menampung data master dari **Area Defect (Cacat)** yang terdaftar.

### output_defects 

Menampung data untuk **Produk Sewing** yang terdapat cacat. Kolom ```output_defect_type_id``` terhubung ke ```output_defect_types.id``` dan kolom ```output_defect_area_id``` untuk mendapatkan data **Jenis dan Area dari Defect** yang ditemukan. Nantinya data ```output_defects``` yang sudah diperbaiki bisa masuk ke data output ```output_rfts``` melalui ```output_reworks```. Begitu juga jika data ```output_defects``` tidak dapat diperbaiki, bisa masuk ke data reject ```output_reject```.

### output_rejects 

Menampung data untuk **Produk Sewing** yang terdapat cacat dan tidak dapat diperbaiki. Dapat juga menampung data yang awalnya defect ```output_defects```.

### output_reworks 

Sebagai penampung data defect dari ```output_defects``` yang sudah diperbaiki, yang juga masuk ke tabel output ```output_rfts``` sebagai produk yang baik.

### output_rfts 

Menampung data **Produk Sewing** yang memiliki kualitas baik berdasarkan pengecekan dari orang QC.