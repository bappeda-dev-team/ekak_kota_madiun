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
* PK Bisa otomatis keisi Usernya jika diklik dari user !!
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

 # Tracker 26/11/2021
 * Mengganti Nama PK jadi Sasaran ( tulisane aja )
 * Mengganti Alur pengisian , User -> Sasaran -> Program Kegiatan -> KaK / Pagu < ? >
 * Sasaran Punya Banyak Program Kegiatan -> PK ganti ke Sasaran aja, buang kalimat pk
 * Program Kegiatan punya KaK
 * Sasaran punya Pagu
 * Dalam Sasasran Terdapat Elemen KaK
 * Gambaran Umum merefer ke Sasaran
 * Di Sasaran Ada isian banyak itu
 * 1 Kak -* Sasaran Kinerja ( PK )
 * !!! Perbaiki Isian Sasaran
 * Todo : Sasaran - Rincian : One to One
 

 # Todo Today 27-11-2021
 * Nested Opd , Program Kegiatan [ Done ]
 * Atau coba deep nested kan Lembaga , Opd , Program Kegiatan [ Bad ]
 * Perbaiki Definisi KaK [ Done ]
    * KaK adalah gabungan dari Sasaran User dengan SUbkegiatan yang disasar oleh Sasaran Tersebut
    * Hasil : 1 Subkegiatan ( Dengan detail program, kegiatan, indikator, dan sasaran program kegiatan ) dan banyak Sasaran User tersebut
 * Nonaktifkan PK routes 
 * User -* Sasaran [ done ]
 * Nested User - Sasaran [ done ]
 * Pas isi sasaran, sekalian isi punya rinciannya [ done ]
    * Bug : Redirect ke sasaran error tidak ada id user [ FIXME ]
 # Todo 29-11-2021
 * !! Edit and Destroy in Sasarans show [ maybe done FIXME ]
 * Rincian in form edit Sasarans if the sasaran have it [ done ]
 * Nested shallow again for pagu and tahapan [ done ]
 * BUg renaksi after create [ done ]
 * Fix Field Pagu ( maybe )
 * Kesenjangan !! [ FIXME ]

 # Do 30-11-2021
 * Ubah Pagu dari Parent Sasaran ke Parent Tahapan [ ANCHOR - Will broken ]
 * Detail Pagu anggaran [ ANCHOR - After Ubah parent ]
 * Tampilan Seperti di Excel [ TODO - Lihat tampilan excel ]
 * Test Update and Delete [ FIXME - Urgensi kedua ]
 * !! CRUD Renaksi