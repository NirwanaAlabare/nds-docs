---
title: Modul
---

Stocker hanya memiliki satu table sebagai penampung. Tetapi dalam programnya banyak mengambil referensi dari tabel lain. Stocker memiliki banyak modul yang cukup rumit dan men-detail.

## Stocker

Stocker baru akan terbentuk tampilannya setelah **data form** dialokasi/masuk kedalam tabel <code>part_form</code>. **Data Form** adalah data yang menjadi dasr bagi stocker. Ketika form telah dialokasi kedalam part_form stocker akan mengambil spesifikasi dari form dan memasangkannya dengan **part group** yang terhubung melalui **part_form**. 

Gambar diatas adalah contoh daftar form yang sudah bisa di-generate stocker-nya. Berikut beberapa hal penting dari modul stocker :

### Part Group - Form List

List dari form yang dapat dibuat stocker-nya dapat dilihat melalui modul <code>part</code>.

<div id="part-list"></div>
![Part List](/assets/images/stocker-module/part-list.png)

Dengan klik tombol yang diberi tanda panah di gambar di atas. Akan memunculkan pop-up/modal seperti berikut : 

<div id="form-list"></div>
![Form List](/assets/images/stocker-module/form-list.png)

### No. Cut

Setelah form terdaftar di tabel diatas, setiap form akan mendapatkan **no_cut**. Nomor Cuttingan/no_cut adalah nomor yang didapatkan form setelah proses cutting selesai, diurutkan sesuai dengan waktu penyelesaian proses cutting. Form akan diurutkan berdasarkan **Part Group dan Color** yang dimiliki form. Seperti yang ditampilkan dalam tampilan **stocker detail** berikut.

![No. Cutting](/assets/images/stocker-module/no-cut-on-stocker-detail.png)

### Group Gelaran dan Part Detail

Lalu stocker akan mengelompokkan **group gelaran** (hasil dari proses cutting) dan menarik list **part detail** yang terdaftar di part group dimana form terdaftar berdasarkan part_form dengan cara <code>stocker_input.form_cut_id -> form_cut_input.id -> part_form.form_cut_id -> part_form.part_id -> part.id -> part_detail.part_id</code>. Lalu menampilkan list group gelaran serta part detail seperti berikut : 

![Group Gelaran](/assets/images/stocker-module/group-gelaran-part-detail.png) 

### Size dan Range

Berdasarkan form, stocker akan mengambil data dari **marker_input_detail** untuk mendapatkan daftar size serta rasionya. Setelah didapatkan daftar size dan rasio, stocker akan memasangkan size dan rasio ke masing masing **group gelaran**.  Setelah membuka part detail dalam sebuah group gelaran akan didapatkan tampilan seperti berikut :

![Size dan Range](/assets/images/stocker-module/form-size-range.png) 

Terdapat daftar size beserta rasio (dari marker_detail) dan range-nya. Range adalah qty awal dan akhir yang bersifat kumulatif di setiap form dengan spesifikasi yang cocok, berdasarkan nomor cut dari form. Misalnya :

<center><div id="size-range-1"><small><i>*Gambar Size-Range No. Cut 1</i></small></div></center>
![Size dan Range 1](/assets/images/stocker-module/size-range-1.png)

Gambar diatas adalah gambaran bagaimana range ditentukan. Berikut gambar untuk lanjutannya.

<center><div id="size-range-2"><small><i>*Gambar Size-Range No. Cut 2</i></small></div></center>
![Size dan Range 2](/assets/images/stocker-module/size-range-2.png)

Gambar diatas merupakan lanjutan dari gambar <u>[Size Range 1](#size-range-1)</u>. Range akan meninjau form sebelumnya yang memiliki sepesifikasi serupa (berdasakan *order, color, size*) dengan nomor cut yang paling mendekati form yang dipilih, untuk bisa mendapatkan range yang sesuai.