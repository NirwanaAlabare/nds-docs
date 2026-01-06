---
title: Struktur Data
---

Modul Marker memiliki struktur yang cukup simple. Yang hanya berfokus pada tiga tabel berikut.

![Struktur Database Marker](/assets/images/struktur-database-marker.png)

### 1. master_sb_ws Table

Merupakan tabel yang menampung data dari aplikasi master (_SignalBit_). Menggunakan PDI (_Pentaho Data Integration_) untuk repopulate data setiap 3 jam.

### 2. marker_input Table

Berperan sebagai parent table, dimana bermacam spesifikasi gelaran disimpan. Memiliki kolom _Kode Marker_ sebagai identifikasi tambahan selain kolom _id_. Menggunakan kolom **act_costing_id** sebagai penghubung ke **master_sb_ws.id_act_cost** untuk mendapatkan informasi order yang sesuai dengan aplikasi master.

### 3. marker_input_detail Table

**Child dari marker_input table** melalui **marker_input_detail.marker_id** ke **marker_input.id** sebagai penghubung. **tabel marker_input_detail** menampung kolom so_det_id (so_det_id adalah kolom yang digunakan untuk mengidentifikasi size dan color produk) beserta rasio dari masing-masing so_det_id tersebut. Satu **marker_input** mampu memiliki lebih dari satu **marker_input_detail**.
