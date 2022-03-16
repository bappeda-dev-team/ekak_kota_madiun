prawn_document do |pdf|
  pdf.font_size 16
  judul_rka = pdf.make_table([
  ["RENCANA KERJA DAN ANGGARAN SATUAN KERJA PERANGKAT DAERAH", {content: "Formulir RKA - RINCIAN BELANJA SKPD", rowspan: 2}],
  ["Pemerintah Kota Madiun Tahun Anggaran 2022"]
  ])
  judul_rka.draw
  pdf.move_down 7
  pdf.font_size 10
  sub_judul_rka = pdf.table([
  ["Urusan Pemerintahan", ":", "5 Unsur Penunjang urusan Pemerintahan"],
  ["Bidang Urusan", ":", "5.01 Perencanaan"],
  ["Program", ":", "5.01.01 Program Penunjang Urusan Pemerintahan daerah kabupaten/kota"],
  ["Sasaran Program", ":", ""],
  ["Capaian Program", ":", ""],
  ["Kegiatan", ":", "5.01.01.2.01 Perencanaan, PEnganggaran, dan Evaluasi Kinerja Perangkat Daerah"],
  ["Organisasi", ":", "5.01.5.05.0.00.02.0000 Badan Perencanaan, Penelitian, dan Pengembangan Daerah"],
  ["Unit", ":", "5.01.5.05.0.00.02.0000 Badan Perencanaan, Penelitian, dan Pengembangan Daerah"],
  ["Alokasi Tahun 2021", ":", "0"],
  ["Alokasi Tahun 2022", ":", "Rp. 88.215.400"],
  ["Alokasi Tahun 2023", ":", "0"],
  ], cell_style: {borders: []})
  pdf.move_down 3
  indikator = pdf.table([
  [{content: "Indikator & Tolok Ukur Kinerja Kegiatan", colspan: 3}],
  ["Indikator", "Tolok Ukur Kinerja", "Target Kinerja"],
  ["Capaian Kegiatan", "", ""],
  ["Masukan", "Dana yang dibutuhkan", "Rp. 88.215.400"],
  ["Keluaran", "", ""],
  ["Hasil", "", ""],
  ])
  
  pdf.move_down 3
  pdf.font_size 8
  pdf.text "Kelompok Sasaran Kegiatan"
  pdf.move_down 5
  pdf.font_size 10
  pdf.table([
  ["Rincian Anggaran Belanja Kegiatan Satuan Kerja Perangkat Daerah"]
  ])
  pdf.start_new_page
  
  # new page
  pdf.move_down 5
  pdf.font_size 8
  pdf.table([
  ["Sub Kegiatan", ":","5.01.01.2.01.01 Penyusunan Dokumen Perenanaan Perangkat Daerah"],
  ["Lokasi", ":","Kota Madiun, Semua Kecamatan. Semua Kelurahan"],
  ["Waktu Pelaksanaan", ":", "Januari s.d Desember"],
  ["Keluaran Sub Kegiatan", ":", "Jumlah Dokumen perencanaan, pengendalian dan evaluasi pernagat daerah | 7 dokumen"]
  ], cell_style: {borders: []})
  
  pdf.table([
  [{content: "Kode rekening", rowspan: 2}, {content: "Uraian", rowspan: 2}, {content: "Rincian Perhitungan", colspan: 4}, {content: "Jumlah", rowspan: 2}],
  ["Koefisien", "Satuan", "Harga", "PPN"],
  ["5.1", {content: "BELANJA OPERASI", colspan: 5}, "Rp. 66.979.200"],
  ["5.1.01", {content: "BELANJA Pegawai", colspan: 5}, "Rp. 54.360.000"],
  ["5.1.01.01", {content: "BELANJA Gaji dan Tunjangan ASN", colspan: 5}, "Rp. 54.360.000"],
  ["5.1.01.01.01", {content: "BELANJA Gaji Pokok ASN", colspan: 5}, "Rp. 54.360.000"],
  ["5.1.01.01.01.0001", {content: "BELANJA Gaji Pokok PNS", colspan: 5}, "Rp. 54.360.000"],
  ["", "Belanja Gaji Pokok PNS (Belanja Gaji dan Tunjangan )","12 Bulan","","3.800.000", "0" ,"Rp. 45.600.000"],
  ["", "Belanja Gaji Pokok PNS (Belanja Gaji dan Tunjangan )","6 Bulan","","1.460.000", "0" ,"Rp. 8.760.000"],
  [{content: "Jumlah Anggaran Sub Kegiatan :", colspan: 6} ,"Rp. 54.360.000"],
  ])
end