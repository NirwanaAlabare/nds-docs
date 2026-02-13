---
title: Penjelasan Singkat Part
---

Part adalah modul yang digunakan untuk menentukan apa saja bagian-bagian/part dari suatu panel dalam suatu order/style.

### Master Part

Modul **Master Part** adalah tempat dimana data-data dari berbagai part dibuat, diubah atau dihapus. Merupakan modul master yang cukup sederhana.

![Data Master Part](/assets/images/master-part.png)

### Master Secondary

Modul **Master Secondary** adalah tempat dimana data-data dari berbagai proses dibuat, diubah atau dihapus. Merupakan modul master yang cukup sederhana. Penggunaannya untuk nantinya dipasangkan ke part dan untuk mengatur di **bagian DC** mana **Stocker dari Part** tersebut dapat dialokasi/discan. 

![Data Master Part](/assets/images/master-secondary.png)

### Part

**Part** merupakan modul untuk menentukan part apa saja yang digunakan di suatu panel dalam suatu order/style. Part adalah tempat dimana form akan bisa memiliki **<u>[part detail](/docs/part/2-.struktur.md#5-part_detail-table)</u>** yang nantinya bisa <u>[di-generate **Stocker**-nya](/docs/stocker/3-modul.md#generate-stocker)</u>. **Form akan otomatis ter-alokasi** ke part yang sesuai dengan order dan panelnya. Namun form juga **dapat dialokasi manual** jika belum masuk ke part group yang diinginkan. Dalam pembuatan part ditentukan juga **consumption** serta **tujuan dan proses alokasinya** sebagai dasar untuk **<u>[Distribution Center (DC)](/docs/dc/3-modul.md#scan-dc)</u>**. 

Contoh data part :

![Data Master Part](/assets/images/part.png)
