---
title: Struktur Data Part
---

Struktur database berfokus di sekitar tabel berikut :

![Struktur Database Part](/assets/images/struktur-database-part.png)

### 1. master_part Table 

Tabel ini menampung data master part.

### 2. master_tujuan Table 

Tabel ini menampung data master tujuan.

### 3. master_secondary Table 

Tabel ini menampung data master secondary. Memiliki relasi dengan <code>master_tujuan</code> sebagai penentu jenis secondary apa yang akan menjadi tujuan suatu proses.

### 4. part Table

Sebagai parent table untuk menampung **Part Grouping** yang memiliki kolom <code>act_costing_id</code>, <code>color</code>, <code>panel</code> sebagai patokan group.

### 5. part_detail Table 

Child table dari tabel <code>part</code> dengan kolom <code>part_detail.part_id</code> sebagai penghubung ke <code>part.id</code>. Menampung <code>master_part</code> apa saja yang termasuk kedalam suatu **Part Group** dengan kolom <code>part_detail.master_part_id</code> ke <code>master_part.id</code>, serta <code>master_secondary</code>-nya sebagai penentu tujuan dan proses apa yang akan dilalui part tersebut dengan kolom <code>part_detail.master_secondary_id</code> ke <code>master_secondary.id</code>. 

### 6. part_detail_item Table 

Penghubung part dengan tabel **bom_jo_item** (signalbit). Satu **part_detail** dapat memiliki lebih dari satu **bom_jo_item** (proses eksternal). 

### 7. part_detail_secondary Table 

Baru-baru ini ada penambahan untuk part yang **bisa melalui lebih dari satu proses secondary**. Karena itu dibuatlah satu tabel ini sebagai penampung relasi antar tabel **part_detail** dengan tabel **master_secondary** (Sebelumnya hanya satu arah \****master_secondary_id di tabel part_detail*** \*). Dengan kolom **urutan sebagai pembeda agar proses-proses yang dilalui tidak tumpang tindih**.

### 8. part_form Table 

Merupakan tabel untuk menghubungkan data dari tabel <code>form_cut_input</code> kedalam suatu <code>part</code> group yang memiliki spesifikasi sesuai. Dengan kolom <code>part_id</code> yang dicocokkan dengan <code>part.id</code>. Dan <code>form_cut_id</code> ke <code>form_cut_input.id</code> sebagai penghubung ke tabel <code>form_cut_input</code>.

