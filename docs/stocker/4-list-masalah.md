---
title: List Problem
---

Beberapa masalah yang masih terjadi :

## Range Stocker tidak sesuai

Terkadang user akan menemukan beberapa kasus ketika range stocker ada kesalahan. Biasanya ini terjadi ketika user mengubah/menghapus data form setelah form sudah memiliki stocker. Perlu penyelidikan lebih lanjut untuk kasus-kasus seperti ini. Walaupun saat ini ada tool <u>[Reorder Stocker Numbering](/docs/stocker/3-modul.md#reorder-stocker-numbering)</u> untuk membenarkan data yang tidak sesuai, tetapi eksekusi tool tersebut bisa saja salah pada kasus-kasus tertentu.

## Group Stocker tidak sesuai

Ada beberapa kasus dimana saat user menginput form cutting dengan nama group yang serupa tapi tidak menjadi satu group. Biasanya karena ada perubahan nama group, atau salah ketik disaat user menginput group gelaran. Bisa menggunakan tool <u>[Rearrange Group Stocker](/docs/stocker/3-modul.md#grouping)</u> untuk membenarkan group stocker.

## Stocker dengan Range yang Berubah setelah di-Print

User kadang menemukan fisik dari stocker (*hasil print stocker*) memiliki spesifikasi yang sama dengan stocker lain. Biasanya kasus ini ditemukan ketika user telah meng-generate stocker pada tanggal tertentu (*misalnya 20 januari 2026*) lalu setelah beberapa hari (*misalnya 25 januari 2026*) user meng-generate stocker yang sama, kadang akan ditemukan range dari stocker dengan ID yang sama memiliki range yang berbeda, hasilnya range tersebut dapat menimpa range dari stocker lain yang ID nya berbeda. Untuk saat ini, yang memungkinkan itu terjadi adalah perubahan di form yang dapat menyebabkan range mundur. Biasanya modul yang menyebabkan itu ada di modul **Cutting Tools** ataupun di modul **Stocker Tools**. Mungkin perlu dibuatkan juga history untuk transaksi-transaksi tersebut untuk mengetahui penyebabnya secara jelas.

