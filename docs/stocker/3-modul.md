---
title: Modul
---

Stocker hanya memiliki satu table sebagai penampung. Tetapi dalam programnya banyak mengambil referensi dari tabel lain. Stocker memiliki banyak modul yang cukup rumit dan men-detail.

# Stocker

Stocker baru akan terbentuk tampilannya setelah **data form** dialokasi/masuk kedalam tabel <code>part_form</code>. **Data Form** adalah data yang menjadi dasr bagi stocker. Ketika form telah dialokasi kedalam part_form stocker akan mengambil spesifikasi dari form dan memasangkannya dengan **part group** yang terhubung melalui **part_form**.

Gambar diatas adalah contoh daftar form yang sudah bisa di-generate stocker-nya. Berikut beberapa hal penting dari modul stocker :

## Part Group - Form List

List dari form yang dapat dibuat stocker-nya dapat dilihat melalui modul <code>part</code>.

<div id="part-list"></div>
![Part List](/assets/images/stocker-module/part-list.png)

Dengan klik tombol yang diberi tanda panah di gambar di atas. Akan memunculkan pop-up/modal seperti berikut :

<div id="form-list"></div>
![Form List](/assets/images/stocker-module/form-list.png)

## No. Cut

Setelah form terdaftar di tabel diatas, setiap form akan mendapatkan **no_cut**. Nomor Cuttingan/no_cut adalah nomor yang didapatkan form setelah proses cutting selesai, diurutkan sesuai dengan waktu penyelesaian proses cutting. Form akan diurutkan berdasarkan **Part Group dan Color** yang dimiliki form. Seperti yang ditampilkan dalam tampilan **stocker detail** berikut.

![No. Cutting](/assets/images/stocker-module/no-cut-on-stocker-detail.png)

## Group Gelaran dan Part Detail

Lalu stocker akan mengelompokkan **group gelaran** (hasil dari proses cutting) dan menarik list **part detail** yang terdaftar di part group dimana form terdaftar berdasarkan part_form dengan cara <code>stocker_input.form_cut_id -> form_cut_input.id -> part_form.form_cut_id -> part_form.part_id -> part.id -> part_detail.part_id</code>. Lalu menampilkan list group gelaran serta part detail seperti berikut :

![Group Gelaran](/assets/images/stocker-module/group-gelaran-part-detail.png)

## Size dan Range

Berdasarkan form, stocker akan mengambil data dari **marker_input_detail** untuk mendapatkan daftar size serta rasionya. Setelah didapatkan daftar size dan rasio, stocker akan memasangkan size dan rasio ke masing masing **group gelaran**. Setelah membuka part detail dalam sebuah group gelaran akan didapatkan tampilan seperti berikut :

<center><div id="size-range"></div></center>
![Size dan Range](/assets/images/stocker-module/form-size-range.png) 

Terdapat daftar size beserta rasio (dari marker_detail) dan range-nya. Range adalah qty awal dan akhir yang bersifat kumulatif di setiap form dengan spesifikasi yang cocok, berdasarkan nomor cut dari form. Misalnya :

<center><div id="size-range-1"><small><i>*Gambar Size-Range No. Cut 1</i></small></div></center>
![Size dan Range 1](/assets/images/stocker-module/size-range-1.png)

Gambar diatas adalah gambaran bagaimana range ditentukan. Berikut gambar untuk lanjutannya.

<center><div id="size-range-2"><small><i>*Gambar Size-Range No. Cut 2</i></small></div></center>
![Size dan Range 2](/assets/images/stocker-module/size-range-2.png)

Gambar diatas merupakan lanjutan dari gambar <u>[Size Range 1](#size-range-1)</u>. Range akan meninjau form sebelumnya yang memiliki sepesifikasi serupa (berdasakan *order, color, size*) dengan nomor cut yang paling mendekati form yang dipilih, untuk bisa mendapatkan range yang sesuai.

## Generate Stocker 

Stocker bisa di-generate dengan cara seperti berikut :

<center><div id="generate-stocker"></div></center>
![Generate Stocker](/assets/images/stocker-module/generate-stocker.png)

Atau bisa juga dengan cara bulk (banyak part sekaligus). Dengan cara seperti berikut : 

<center><div id="generate-stocker-1"></div></center>
![Generate Stocker 1](/assets/images/stocker-module/generate-stocker-1.png)

**Generate Stocker** akan menghasilkan data di tabel <code>stocker_input</code>. Stocker dibuat dengan dasar **form, order, color, size, part_detail hingga rasio**. Setiap detail tadi akan menghasilkan satu data stocker. Setelah berhasil menambahkan data stocker, modul ini akan meng-generate **PDF**-nya, PDF ini nantinya akan di-print lalu dijadikan sebagai identitas dari stok panel yang sesuai, yang sudah terbuat. Setelah stocker di-print, stocker akan bisa diedarkan ke bagian **DC** untuk menempuh proses lain. Berikut gambaran dari **PDF stocker** : 

<center><div id="stocker-pdf"></div></center>
![Stocker PDF](/assets/images/stocker-module/stocker-pdf.png)

Setiap satu rasio dari stocker akan terbuat satu halaman di pdf seperti diatas. Detail data terkait stocker tertera di pdf tersebut.

## Stocker Detail Tools

Dalam halaman **stocker detail** terdapat beberapa tools yang digunakan untuk menyesuaikan perubahan di lapangan.

<center><div id="stocker-detail-tools"></div></center>
![Stocker PDF](/assets/images/stocker-module/stocker-detail-tools.png)

### 1. Separate Qty

Separate Qty adalah tool yang digunakan untuk menentukan dan memisahkan qty gelaran di masing-masing group, agar dapat sesuai dengan qty aktual di lapangan.    

<center><div id="separate-qty-stocker"></div></center>
![Stocker PDF](/assets/images/stocker-module/separate-qty-stocker.png)

User dapat menambahkan ataupun mengurangi rasio stocker serta qty-nya secara kustom. **Separate Stocker Tool** ini akan menggantikan/menimpa spesifikasi rasio dan qty yang sudah ada di [stocker detail](#size-dan-range). Biasanya user akan menggunakan tool ini jika perubahannya memiliki skala yang cukup besar. Sedangkan untuk perubahan skala kecil yang biasanya disebut dengan *Turun Size / Naik Size* akan menggunakan tool [Size Qty (Modify Size Qty)](#modify-size-qty).

### 2. No. Stocker

Adalah tool yang digunakan untuk meninjau dan mengatur ulang range dari stocker jika tidak sesuai dengan range seharusnya, Biasanya jika ada perubahan qty pada form sebelumnya yang menyebabkan range harus mundur.

### 3. Grouping

Merupakan tool yang dipakai jika group gelaran tidak sesuai dengan data aktual. Misalnya jika ada qty gelaran group yang terpisah walaupun group-nya sama. Biasanya karena ada perubahan nama group, atau salah ketik disaat user menginput group gelaran. 

### 4. Modify Size Qty {#modify-size-qty}

Tool ini digunakan untuk menurunkan/menaikkan size, misalnya di size S ada turun size ke size XS, maka dari size S akan dikurangi qty nya dan size XS akan ditambahkan qty-nya sesuai kebutuhan. Berikut adalah contoh form untuk mengeksekusi tool **Size Qty (Modify Size Qty)** :

![Size Qty](/assets/images/stocker-module/modify-size-qty.png)

## Stocker Additional

Seperti yang sudah disebutkan di <u>[List Problem Marker - Multi Order Marker](/docs/marker/3-list-masalah.md)</u>. Modul ini dibuat untuk menyediakan ruang untuk order lain agar dapat di-generate stocker-nya. Berikut tampilannya di halaman stocker detail :

![Add Stocker Additional](/assets/images/stocker-module/add-additional-stocker.png)

Dengan mengklik tombol add additional stocker user bisa menambahkan order lain untuk disandingkan dengan form yang dipilih. Berikut tampilan form untuk menambahkan additional stocker :

![Add Stocker Additional Form](/assets/images/stocker-module/add-additional-stocker-form.png)

Setelah form dilengkapi dan disimpan. List part detail beserta size dan rasio dari order yang dipilih akan muncul, tetapi dengan spesifikasi range, qty dan rasio akan persis dengan spesifikasi form yang dipilih. Berikut contoh tampilan stocker additional : 

![Stocker Additional](/assets/images/stocker-module/additional-stocker.png)

## Reorder Stocker Numbering

Selain tools diatas, ada juga tool **Reorder Stocker Numbering**. Fungsinya untuk **mengurutkan ulang semua form yang berada dalam suatu part group**. Kadang perubahan user di form cutting akan menyebabkan beberapa range menjadi salah atau tidak sesuai, misalnya stocker form yang range-nya tidak melanjutkan form sebelumnya, range yang terlewat, range stocker yang menimpa range stocker lain, nomor cuttingan yang tidak berurutan dsb. Karena prosesnya cukup banyak maka tool ini dibuat agar program dapat memebenarkan range sesuai dengan data yang seharusnya. Semakin banyak form dalam suatu part group maka proses Reorder Stocker Numbering ini juga akan semakin lama.

Untuk mengeksekusi tool ini cukup klik tombol **Urutkan Ulang** pada modal pop-up dari detail part di menu part :

![Reorder Stocker Numbering](/assets/images/stocker-module/reorder-stocker-numbering.png)
