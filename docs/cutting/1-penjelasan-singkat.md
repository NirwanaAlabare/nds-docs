---
title: Penjelasan Singkat Cutting
---

Cutting merupakan modul yang cukup rumit pada implementasinya. Memiliki banyak langkah dan beberapa rumus untuk mendapatkan output dari cutting. Berikut langkah-langkah yang dilalui untuk mendapatkan output cutting. Berikut beberapa langkahnya :

### Spreading

Spreading adalah modul untuk mengkonversi suatu marker agar dapat menjadi form. Cara kerjanya adalah dengan memilih marker yang sudah dibuat lalu membagi qty marker tersebut sesuai jumlah form yang dibutuhkan. Dengan form seperti berikut :

![Spreading](/assets/images/spreading.png)

### Cutting Plan

Cutting Plan merupakan modul yang disediakan untuk mengalokasikan form agar dapat di-input oleh user meja. Untuk dapat di-input oleh meja diperlukan approve dan alokasi meja, yang diatur menggunakan modul _Manage Cutting Plan_.

Tampilan alokasi cutting plan :

![Cutting Plan](/assets/images/cutting-plan.png)

Tampilan manage cutting plan :

![Manage Cutting Plan](/assets/images/manage-cut-plan.png)

### Cutting Process

Cutting Process adalah modul dimana proses gelar dimulai, terdapat banyak tahap dan rumus di modul ini. Ada beberapa tipe form di modul ini diantaranya Regular Form, Manual Form, Pilot Form atau dalam bentuk lain ada Form Piece, Form Reject, Form Piping. Di-input oleh user meja. Modul ini akan menghasilkan output jumlah gelaran, jumlah panel (_pcs berdasarkan rasio dan gelaran_) dan pemakaian kain (_Hasil dari rumus-rumus_). Berikut tampilan dari proses form cutting :

![Cutting Process](/assets/images/cutting-form-process.png)

#### 1. Regular Form 

Form Biasa, di-generate oleh admin dengan modul spreading, lalu dialokasi ke suatu meja sampai akhirnya di-approve, setelah itu form bisa di-input oleh operator cutting per-meja.

#### 2. Manual Form

Form Manual adalah form yang spesifikasi-nya ditentukan secara manual oleh operator cutting per-meja secara langsung, atau bisa juga dibuat oleh admin yang membutuhkan form tetapi belum ada marker yang sesuai.

#### 3. Pilot Form

Form Pilot adalah form yang penginputannya masih sama dengan regular form, hanya saja pilot spesifik berasal dari marker dengan tipe pilot, dan setelah form selesai akan ditentukan *bulk* atau tidaknya suatu form. 

:::info

3 Tipe form diatas adalah proses utama dari modul form cutting yang masih berada dalam satu tabel

:::

#### 4. Form Reject

Merupakan form yang dibuat untuk merekam data output cutting tambahan yang digunakan untuk mengganti reject.

#### 5. Form Piping

Piping adalah proses tambahan dari form cutting utama. Terdapat pemakaian kain pada modul ini.