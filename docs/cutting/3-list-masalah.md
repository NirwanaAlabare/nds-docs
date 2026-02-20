---
title: List Problem Cutting
---

Beberapa problem yang belum terselesaikan di Cutting diantaranya :

### Progress Lembar Gelaran tidak bertambah

Beberapa user melaporkan adanya bug dimana progress lembar gelaran tidak bertambah walaupun user sudah mengubah lembar gelarannya. Saat ini belum diketahui apa penyebabnya dan bagaimana kondisi saat ply progress terjadi bug. Tampilan untuk form cutting di bagian spreading terlihat seperti ini :

![Form Cut Input Spreading](/assets/images/form-cut-input-spreading.png)

Seharusnya ketika ada perubahan pada value input <code>Lembar Gelaran</code>, maka progress bar <code>Ply Progress</code> pun ikut bertambah.

### Roll Qty tidak sesuai

Kadang saat ada beberapa perubahan qty di bagian roll, entah itu dari **Qty Out gudang** ataupun **perubahan/penghapusan roll setelah form selesai**, qty roll bisa jadi tidak cocok dengan qty yang seharusnya. Saat ini ada tools untuk mengatasi ini di modul **Cutting Tools**.

![Cutting Tools](/assets/images/fix-roll-qty-tool.png)

Mungkin perlu ditinjau ulang bagaimana agar qty roll dapat memiliki qty yang konsisten.

:::info

Biasanya qty roll yang sesuai dari tabel **scanned_item** adalah **qty sisa kain** dari pemakaian terakhir di tabel <b><u>[form_cut_input_detail](/docs/cutting/2-struktur.md#form_cut_input-table)</u></b>, <b><u>[form_cut_piping](/docs/cutting/2-struktur.md#form_cut_input-detail-table)</u></b> dan mungkin juga (*jika ada update pemakaian roll di form_cut_reject*) <b><u>[form_cut_reject](/docs/cutting/2-struktur.md#form_cut_reject-table)</u></b>

:::

### Roll-Request Entanglement

Ada satu masalah di Cutting yang membuat Reporting jadi sulit dicerna. Karena itu diperlukan suatu relasi yang menghubungkan **Pemakaian Roll (form_cut_input_detail)** dengan **Pengeluaran Gudang (whs_bppb_det)**. Tetapi ada beberapa hal yang perlu dipertimbangkan : 

- **1 kali pemakaian roll bisa didasarkan pada 1 request**. Contoh : 

```
+--------+------------+------------+------------+
|REQUEST | ROLL       | PEMAKAIAN  | QTY        |
|--------|------------|------------|------------|
|RQ-123  | Roll 1     | Form 1     | 50 Meter   |
|--------|------------|------------|------------|
|RQ-124  | Roll 2     | Form 2     | 39 Meter   |
+--------|------------+------------+------------+
```

- **1 kali pemakaian roll bisa didasarkan pada 2 request**. Contoh : 

```
+--------+------------+------------+------------+
|REQUEST | ROLL       | PEMAKAIAN  | QTY        |
|--------|------------|------------|------------|
|RQ-123  |            |            |            |
|--------| Roll 1     | Form 1     | 50 Meter   |
|RQ-124  |            |            |            |
+--------|------------+------------+------------+
```
Ini adalah kasus yang bisa terjadi ketika gudang mengeluarkan **1 roll secara parsial (lebih dari 1 kali (request))**. Tapi walaupun gudang mengeluarkan secara parsial, cutting tetap memakainya **setelah qty dari roll sudah full (tidak ada sisa di gudang)**.

- **1 kali pemakaian roll bisa didasarkan pada 2 request berbeda**, namun dengan **1 id roll yang sama**. Contoh : 

```
+--------+------------+------------+------------+------------+
|REQUEST | ROLL       | PEMAKAIAN  | QTY        | SISA       |
|--------|------------|------------|------------|------------|
|RQ-123  | Roll 1     | Form 1     | 25 Meter   | 10 Meter   |
|--------|------------|------------|------------|------------|
|RQ-124  | Roll 1     | Form 2     | 35 Meter   | 0  Meter   |
+--------+------------+------------+------------+------------+
```
Ini adalah kasus yang bisa terjadi ketika gudang mengeluarkan **1 roll secara parsial (lebih dari 1 kali (request))**. Dan cutting pun **memakainya secara parsial** di 2 form yang berbeda.
