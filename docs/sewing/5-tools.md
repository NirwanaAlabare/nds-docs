---
title: Tool Sewing
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

Terdapat beberapa tools yang disediakan di NDS untuk menangani kasus-kasus seperti perubahan data di lapangan, transaksi yang tidak tuntas (Server), data yang tidak cocok dsb.

![Sewing Tools](/assets/images/sewing-module/tool.png)

### Transfer Output

Tools ini digunakan biasanya untuk memindahkan suatu output dari satu line ke line lain, dari satu plan ke plan lain dan semacamnya. 

![Transfer Output](/assets/images/sewing-module/transfer-output.png)

Terdapat beberapa tombol yang disediakan di halaman ini : 

#### 1. Transfer All

Untuk mentransfer semua jenis output dari satu ketentuan asal (FROM) ke ketentuan tujuan (TO).

#### 2. Transfer Numbering

Untuk mentransfer output dengan kode numbering yang diinput ke ketentuan tujuan (TO).

#### 3. Transfer RFT

Untuk mentransfer semua output dengan jenis RFT dari satu ketentuan asal (FROM) ke ketentuan tujuan (TO)

#### 4. Transfer Defect

Untuk mentransfer semua output dengan jenis Defect dari satu ketentuan asal (FROM) ke ketentuan tujuan (TO)

#### 5. Transfer Reject

Untuk mentransfer semua output dengan jenis Reject dari satu ketentuan asal (FROM) ke ketentuan tujuan (TO)

#### 6. Transfer Rework

Untuk mentransfer semua output dengan jenis Rework dari satu ketentuan asal (FROM) ke ketentuan tujuan (TO)

### Fix Output User Line 

Untuk membenarkan data created_by yang tidak sesuai dengan line dari master plan.

### Fix Output Master Plan  

Tool ini digunakan untuk membenarkan data output yang tidak sesuai antara master plan dengan output-nya.

![Miss Master Plan](/assets/images/sewing-module/miss-masterplan.png)

- Jika user ingin mengubah data OUTPUT maka klik tombol **Update Origin**.
- Jika user ingin mengubah data MASTER PLAN maka klik tombol **Update Master Plan**.

### Fix Defect-Rework-RFT

Untuk melengkapi output yang belum lengkap. Data yang akan terhandle dengan tool ini diantara lain : 

- RFT dengan status REWORK tetapi tidak ada data REWORK yang bersangkutan.
- REWORK tanpa data Defect.
- DEFECT dengan status REWORKED tetapi tidak ada data REWORK yang bersangkutan.

### Fix Packing-PO

Jika ada output packing yang spesifikasi produknya tidak sesuai dengan PO yang terdaftar, maka dapat digunakan tool ini. Tool ini akan mencarikan PO yang sesuai dengan produk lalu mengubah PO yang terdaftar di data output packing menjadi PO yang sesuai.

### Fix Defect-Reject

Untuk melengkapi output DEFECT dengan status REJECTED tetapi tidak ada data REJECT yang bersangkutan.

### Check Output Detail

Tool ini digunakan untuk mendapatkan list output yang sesuai dengan berbagai filter yang dipilih secara detail. Biasanya digunakan untuk mencari nomor QR dari suatu produk dengan style tertentu, yang nantinya akan di-modify ataupun di-transfer.

![Check Output Detail](/assets/images/sewing-module/check-output-detail.png)

### Line Migration 

Digunakan untuk memindahkan output dari suatu line ke line lain secara menyeluruh.

![Line Migration](/assets/images/sewing-module/line-migration.png)

### Modify Output

Digunakan untuk mengubah spesifikasi output yang tidak memiliki Kode QR / Numbering. 

![Modify Output](/assets/images/sewing-module/modify-output.png)
 
Setelah menentukan Line dan Plan-nya user bisa menentukan size dan qty (FROM) dari produk yang akan diubah dan spesifikasi tujuan (MODIFY TO) lalu klik tombol **Modify** untuk menyimpan perubahan, bisa juga digunakan untuk **Undo** dengan meng-klik tombol Undo.

![Modify Output RFT](/assets/images/sewing-module/modify-output-rft.png)

### Undo Output 

Tool yang digunakan untuk menghapus suatu output dengan kode QR / Numbering tertentu, dengan menentukan list kode Numbering, **User dapat menghapus output dengan klik tombol UNDO** atau jika sudah di UNDO bisa **dikembalikan lagi dengan klik tombol RESTORE**.

![Undo Output](/assets/images/sewing-module/undo-output.png)

### Undo Reject IN OUT 

Tool yang digunakan untuk menghapus suatu output dari **QC REJECT** dengan kode QR / Numbering tertentu, dengan menentukan list kode Numbering, **User dapat menghapus output QC REJECT dengan klik tombol UNDO** atau jika sudah di UNDO bisa **dikembalikan lagi dengan klik tombol RESTORE**.

![Undo REJECT IN OUT](/assets/images/sewing-module/undo-reject-in-out.png)

### Undo Defect IN OUT 

Tool yang digunakan untuk menghapus suatu output dari **DEFECT Tertentu yang melalui proses khusus**,  dengan kode QR / Numbering tertentu, dengan menentukan list kode Numbering, **User dapat menghapus output DEFECT dengan klik tombol UNDO** atau jika sudah di UNDO bisa **dikembalikan lagi dengan klik tombol RESTORE**.

![Undo Defect IN OUT](/assets/images/sewing-module/undo-defect-in-out.png)

### Modify Sewing Secondary 

Tool ini bisa digunakan untuk **mengubah proses Secondary** yang sudah terekam di **Secondary Sewing**, dengan menentukan kode QR / Numbering dan menentukan proses Secondary lalu klik tombol SIMPAN. Bisa juga digunakan untuk membatalkan output yang masuk ke **Secondary Sewing** dengan mengklik tombol UNDO.

![Modify Sewing Secondary](/assets/images/sewing-module/modify-sewing-secondary.png)