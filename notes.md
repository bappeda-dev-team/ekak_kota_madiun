# Notes

## View
* ~~Opd~~
* ~~User~~
* ~~Lembaga~~
* ~~Kak~~
* ~~ProgramKegiatan~~

## Controller / Action / Route
* ~~Opd~~
* ~~User~~
* ~~Lembaga~~
* ~~Kak~~
* ~~ProgramKegiatan~~


## TODO
* Tambah PK dan SKP Sementara
* Dropdown di references
* Tambah pagu Anggaran
* Tambahkan Dynamic class buat navigation
* Tambahakan Pemilik KAK , User --* KaK <-Sekalian tes bisa ga begini
* Percantik setelah selesai fungsinya
* user login system dan langsung di asosiasikan antara user dan opdnya, sehingga di KAK tinggal pilih ProgramKegiatan
* Program Kegiatan di KAK harus ada chain dari OPD ( atau kelompokkan saja )
* maybe some refactor [ DONE ]
* KAK -> per sasaran , Rp -> pegawai jasa modal
* Sasaran Kinerja -> Model baru 1 KAK Many Sasaran Kinerja -> Rincian
* Faktor Kesenjangan , Di Klik Buka 
* 

## Story
Merencanakan Sasaran Kinerja -> Menentukan Tahapan Kerja -> Menentukan Kebutuhan Dana ( Modal, Pegawai, Jasa, Hibah ) -> Jadi SUbkegiatan -> Menjadi # ( Tagar ) -> Subkegiatan melekat pada Sasaran Kinerja -> Sasaran jadi pengali JV Indeks Untuk pengecekan bulanan

UKK -> jika nempel di subkegiatan jadi gede karena ada UKK

## Tracker
25/11/2021
* Ubah root route
* Ganti Judul halaman index opd
* Model PK
* User tampil PK
* Menu PK di navbar ( delete later )
* 1 KaK 1 SubKegiatan
## Story Baru
User masuk / Login -> Pilih OPD
-> Menu Rancang KaK -> Masuk Menu new KaK
-> ( dari atas ) Pilih Sasaran ( dari PK User )
-> Pilih Program , Kegiatan dan SubKegiatan ( jika tidak bisa input saja ) -> Isi Semua Isian KaK ( lihat di struktur KaK dibawah ) -> Pagu Anggaran ( lihat di Pagu dibawah)
-> Bisa di Print ( cari gem )

### Struktur KaK
 Latar Belakang ( DasHu, Tujuan) -> Gambaran Umum --> Sasaran Kinerja ( Refer dari PK ) -> dari Sasaran Punya Banyak Rincian -> Rincian adalah isian KaK yang lain

 ### Pagu Anggaran
 Ref Sasaran Kinerja -> Belanja Modal ( angka ) -> Belanja Operasional -> Bisa add field sendiri ( ada satuan, volume, dan total ) -> Sum kebawah -> Jadi Anggaran Sub kegiatan