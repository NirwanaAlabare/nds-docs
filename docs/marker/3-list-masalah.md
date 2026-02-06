---
title: List Problem Marker
---

Dalam modul marker ini masih ada problem yang belum terselesaikan. Berikut beberapa diantaranya :

### Select Panel tidak tampil

Terkadang ketika user sedang membuat data Marker, user akan menemukan select input panel tanpa adanya opsi panel, padahal database master sudah memiliki datanya. Biasanya problem ini disebabkan oleh **PDI yang belum ter-update**, ketika ini terjadi maka dapat dicoba untuk run PDI (Third-Party) secara manual di server. Tapi terkadang juga ada kasus dimana **data master sudah di cancel atau data master belum ada**.

![PDI](/assets/images/pdi.png)

Gambar diatas adalah tampilan dari aplikasi PDI. Klik icon start untuk mengeksekusi scheduler.

### Multi Order Marker

Awalnya modul marker digunakan dengan basis single-order, tetapi ditengah-tengah development user memiliki problem baru, yaitu ketika ternyata satu marker dapat dipakai untuk lebih dari satu order, marker yang masih berbasis single-order untuk mampu menautkan ke lebih dari satu order (_act_costing_id_) mungkin diperlukan perombakan di tabel **marker_input** dengan memindahkan kolom **act_costing_id ke tabel baru** sebagai penampung **relasi antar marker_input dengan master_sb_ws atau act_costing (signalbit)**. Saat ini user menggunakan modul alternatif di stocker, yaitu **Stocker Additional**. Dengan menggunakan modul <u>[Stocker Additional](/docs/stocker/3-modul.md#stocker-additional)</u> user dapat menautkan Order tambahan, hanya saja **modul ini terbatas hanya pada satu tambahan order dan berada ditahap saat user meng-generate stocker**.
