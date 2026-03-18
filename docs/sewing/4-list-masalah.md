---
title: List Problem Sewing
---

Dalam modul sewing beberapa hal yang perlu diperhatikan, sebagian besar berasal dari teknis metode/alur penginputan.

## Perangkat

Perangkat yang digunakan untuk **Scan Label QR** di Sewing adalah

- TAB 
- Scanner Duduk Kabel
- OTG 

Terkadang ada masalah teknis yang ditemukan pada perangkat diatas, seperti **Scanner tidak membaca QR dengan baik**, **OTG gagal menghubungkan ke Scanner**, **TAB yang baterainya cepat habis** karena Scanner menggunakan daya dari TAB, **Distribusi TAB** yang cukup sulit  dsb.

## Salah Pasang Label 

Dalam beberapa kasus, label bisa saja terpasang ke produk yang tidak sesuai. Hal itu bisa saja disebabkan oleh **Operator Sewing yang salah menjahit label**, bisa juga **DC yang salah mengelompokkan Label** atau **salah loading** dsb. Untuk mengatasi ini, saat ini digunakan modul **Modify Year Sequence** untuk mengubah label sesuai dengan aktual.

## Pindah Line 

Dalam beberapa kasus, user akan meminta output dari suatu Line untuk dipindahkan ke Line lain. Biasanya karena memang aktualnya di lapangan, orang orang dan output di Line tertentu dapat bertukar/berpindah ke Line Lain, bisa juga karena penyesuaian dsb. Untuk mengatasi ini bisa digunakan modul **Transfer Output**.

<center>_*Tampilan Transfer Output_</center>

![Transfer Output](/assets/images/sewing-module/transfer-output.png)

Atau dapat juga menggunakan modul **Line Migration** jika perpindahan Line terjadi secara menyeluruh (Seluruh Output/Tidak Parsial).

<center>_*Tampilan Line Migration_</center>

![Line Migration](/assets/images/sewing-module/line-migration.png)

## Master Plan yang Tidak Sesuai Dengan Aktual

Jikalau terjadi perubahan di output sewing, terkadang ada beberapa transaksi yang tidak selesai, sehingga menyebabkan data output tidak sinkron dengan master plan yang dimana output itu terdaftar. Saat ini digunakan beberapa modul sinkronisasi yang dijalankan dengan _Task Scheduler/Cron Job_. Command yang digunakan untuk membenarkan kasus ini berada di ```App\Console\Commands\MissMasterPlan.php``` dan terdaftar di ```App\Console\Kernel.php```.

## Data Output Tidak Lengkap

Kasus ini masih mirip dengan kasus sebelumnya, yaitu ketika user mengubah suatu data setelah data itu terekam di beberapa modul dan ada beberapa transaksi yang tidak terjalankan dengan baik. Hal itu bisa menyebabkan data output tidak lengkap, misalnya 

- RFT dengan status REWORK tetapi tidak ada data REWORK yang bersangkutan.
- REWORK tanpa data Defect.
- DEFECT dengan status REWORKED tetapi tidak ada data REWORK yang bersangkutan.
- DEFECT dengan status REJECTED tetapi tidak ada data REJECT yang bersangkutan.

Saat ini ada modul sinkronisasi dijalankan dengan _Task Scheduler/Cron Job_. Command yang digunakan untuk membenarkan kasus ini berada di ```App\Console\Commands\MissRework.php``` untuk data Defect-Rework dan ```App\Console\Commands\MissReject.php``` untuk data Defect-Reject, terdaftar di ```App\Console\Kernel.php```.