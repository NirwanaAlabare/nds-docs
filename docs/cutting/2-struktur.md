---
title: Struktur Data
---

## Cutting Plan

Data untuk modul cutting plan akan berada di tabel berikut :

### 1. cutting_plan

Tabel untuk menampung tanggal cutting beserta form yang akan dialokasikan. Juga menampung status approve pada tiap form. Menggunakan kolom <code>form_cut_id</code> untuk penghubung ke tabel <code>form_cut_input</code>. Memiliki identifikasi dengan format <code>CP-ddmmyyyy</code>.

![Struktur Database Cutting Plan](/assets/images/struktur-database-cutting-plan.png)

## Form Cutting

Modul untuk proses form cutting berfokus pada tabel-tabel berikut :

![Struktur Database Cutting](/assets/images/struktur-database-cutting.png)

### 1. form_cut_input Table 

Merupakan tabel yang menampung **spesifikasi form hasil input dari spreading**, bisa juga hasil input spesifikasi manual melalui **form cutting manual**. Terdapat kolom **form_cut_input.marker_id** sebagai penghubung ke **marker.id**, Memiliki kolom **no_form** sebagai identifikasi umum dengan format <code>dd-mm-iteration</code>. Hanya saja identifikasi **no_form memiliki celah** yaitu ketika berganti tahun, no_form bisa memiliki kembaran.

### 2. form_cut_input_detail Table {#form_cut_input-table}

Merupakan child table dari **form_cut_input**. Identitas di tabel ini berbeda dari tabel lain, table ini menggunakan uuid sebagai id. Untuk penghubung ke parent melalui **form_cut_input_detail.form_cut_id** ke **form_cut_input.id**. Tabel ini berisikan **detail pemakaian dari setiap roll yang discan di form**. Terdapat kolom **id_roll** sebagai identitas roll, sekaligus penghubung ke tabel scanned_item.

:::info

Qty dari tabel **form_cut_input_detail** harus disinkronisasi dengan tabel **scanned_item**.

:::

### 3. scanned_item Table 

Tabel **scanned_item** menampung data roll secara _unique_, beserta kolom **qty** sebagai stok roll yang tersisa, **qty_in** sebagai qty awal roll, **unit** sebagai satuan dari roll dan bermacam detail lainnya dari roll.

:::warning

Data **qty dari scanned_item** harus selalu tersinkronisasi dengan data sisa kain terakhir berdasarkan kolom **id_roll**.

:::

### 4. form_cut_reject Table {#form_cut_reject-table}

Tabel **form_cut_reject** adalah varian lain dari <code>form_cut_input</code>. Berbeda dari form_cut_input, form_cut_reject tidak mencantumkan detail item di tabelnya. Tidak ada relasi ke marker. Untuk order dan semacamnya ditentukan langsung di modul **Form Cut Reject**. Seperti <code>buyer_id</code>, <code>act_costing_id</code>, <code>color</code>, <code>panel</code>, <code>group</code> dsb.

### 5. form_cut_reject_detail Table

Merupakan tabel **child dari tabel form_cut_reject**. Isinya detail output aktual per-<code>size</code>-nya. Digunakan kolom **form_cut_reject_detail.form_id** sebagai penghubung ke **form_cut_reject.id**.

## Piping

![Struktur Database Piping](/assets/images/struktur-database-cutting-piping.png)

### 1. form_cut_piping Table {#form_cut_piping-table}

Merupakan tabel untuk proses eksternal di cutting. Yang terpenting di tabel **form_cut_piping** ini ialah pemakaian kainnya, dengan kolom **id_roll** sebagai identitas kain yand dipakai, serta **qty, piping, qty_sisa, unit dan short_roll** yang merupakan kolom inti dari **data pemakaian di tabel form_cut_piping** ini.

:::info

Qty dari tabel **form_cut_piping** harus disinkronisasi dengan tabel **scanned_item**.

:::
