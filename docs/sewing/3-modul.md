---
title: Modul Sewing
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

Setelah stocker panel dialokasi ke Line user akan meregistrasi stocker tersebut menjadi Label QR, Nantinya QR tersebut akan dipasang sesuai spesifikasi produk, Lalu dicek oleh QC dan akhirnya di-scan-lah QR Label tersebut untuk merekam data output dari sewing line secara realtime. 


## Alur Sewing

![Alur Sewing Figma](/assets/images/sewing-flow.jpg)

Gambar diatas merupakan sebuah gambaran dari alur yang saat ini berjalan di **Sewing Line**.

## Penggunaan 

Pertama-tama user perlu memilih master_plan yang sesuai untuk dapat menginputkan output sewing. 

![Order List](/assets/images/sewing-module/sewing-order-list.jpg)

Setelah user menentukan Plan (berdasarkan WS dan Color) maka user akan diarahkan ke halaman **Production Panel**

![Production Panel](/assets/images/sewing-module/production-panel.png)

Di halaman ini QC akan menentukan kualitas dari produk yang sudah diperiksa.

:::tip[RFT]

Untuk menginput output sewing yang berkualitas baik.

:::

:::warning[Defect]

Untuk menginput defect sewing yang memiliki cacat.

:::

:::danger[Reject]

Untuk menginput reject sewing yang memiliki cacat dan tidak bisa diperbaiki. Defect dapat diubah menjadi Reject.

:::

:::info[Rework]

Untuk menginput defect sewing yang berhasil diperbaiki. Masuk ke Output RFT.

:::

Setelah memilih suatu modul maka akan muncul tampilan seperti berikut : 

![RFT Scan](/assets/images/sewing-module/rft-scan.png)

QC akan meng-scan QR Label menggunakan Alat Scan yang disambungkan ke tablet sebagai input, Setiap user meng-scan Label QR, Scanner akan meng-input konten dari QR lalu mengirim data tersebut ke server untuk direkam. Setelah berhasil disimpan Jumlah Qty di List Size akan ter-update. 

Jika yang dipilih adalah modul **Defect**/**Reject** maka akan muncul dialog untuk memilih **Jenis beserta Area dari Defect**

![Defect](/assets/images/sewing-module/defect.png)

Setelah dipilih jenis dan area defect-nya maka user perlu menentukan juga posisi dari cacat produk. 

![Defect Position](/assets/images/sewing-module/defect-position.png)