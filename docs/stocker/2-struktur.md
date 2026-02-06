---
title: Struktur Data Stocker
---

## Stocker 

![Struktur Database Stocker](/assets/images/struktur-database-stocker.png)

Dengan **id_qr_stocker** sebagai identifikasi, berformat ```STK-iteration```. Memiliki kolom ```form_cut_id``` untuk menautkan ke form cutting, ```form_reject_id``` sebagai penaut untuk form yang menggunakan metode form reject, lalu ```part_detail_id``` sebagai penghubung ke tabel ```part_detail```. 

## Stocker Additional

![Struktur Database Stocker Additional](/assets/images/struktur-database-stocker-additional.png)

### 1. stocker_ws_additional Table 

Tabel ini menampung data spesifikasi **buyer, order, color, panel**, Kolom **stocker_ws_additional.form_cut_id** sebagai penghubung ke data stocker form (**form_cut_input.id**) untuk mengambil spesifikasinya.

### 2. stocker_ws_additional_detail Table 

Tabel ini merupakan **child table dari stocker_ws_additional table**. Menampung data **so_det_id** (size) beserta **ratio**-nya.