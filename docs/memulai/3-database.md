---
title: "Database"
---

Struktur database di project ini masih berkembang. Tapi untuk gambaran umum bisa ditampilkan dengan diagram seperti berikut :

### 1. NDS

Berikut struktur database dari NDS secara umum :

**<u><a href="/assets/others/NDS-ERD.drawio" download>Download NDS ERD</a></u>**

![NDS ERD](/assets/images/NDS-ERD.png)

### 2. Sewing

Untuk modul-modul di Sewing databasenya dipisahkan dari aplikasi NDS. Secara database menyatu dengan database master (signalbit). Berikut gambaran umumnya, tapi ini bukan versi terbarunya :

**<u><a href="/assets/others/Sewing-Output-ERDiagram.drawio" download>Download Sewing ERD</a></u>**

![Sewing ERD](/assets/images/Sewing-Output-ERDiagram.jpg)

:::info 

Database ini menggunakan relasi tanpa **foreign key**. Jadi perlu didefinisikan secara manual untuk **sinkronisasinya** di aplikasi.

::: 