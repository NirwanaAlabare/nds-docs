---
title: Struktur Data QR Label
---

![Struktur Database Year Sequence](/assets/images/struktur-database-year-sequence.png)

#### year_sequence Table

Tabel **year_sequence** merupakan satu-satunya tabel yang dijadikan dasar untuk qr label. Dengan **id_year_sequence** sebagai identitas yang ber-format :

```
TAHUN_SEKUEN_NOMOR

TAHUN = Tahun label di-generate.
SEKUEN = Ketika Nomor sudah mencapai batas 6 digit maka akan terbentuk sekuen baru.
NOMOR = Nomor dengan batas 6 digit 

```

Dan relasi : 

```
year_sequence.form_cut_id = form_cut_input.id
year_sequence.form_reject_id = form_cut_reject.id
year_sequence.form_piece_id = form_cut_piece.id
year_sequence.id_qr_stocker = stocker_input.id_qr_stocker (stocker patokan)
```

Sebagai sumber spesifikasi produk. Tetapi jika ada perubahan/revisi sebaiknya menggunakan kolom **so_det_id** untuk mendapatkan spesifikasi aktual dari produk, dikaitkan ke tabel **so_det** di signalbit.