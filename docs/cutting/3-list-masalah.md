---
title: List Problem
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

