prawn_document() do |pdf|
  pdf.font_size 14
  pdf.text "KERANGKA ACUAN KERJA/ TERM OF REFERENCE", align: :center
  pdf.text "KELUARAN (OUTPUT) KEGIATAN TA 2022", align: :center
  # tabel pertama
  pdf.font_size 8
  pdf.move_down 20
  tabel_program_kegiatan = pdf.make_table([
    ["Kementrian negara/Lembaga", ":", "Pemerintah Daerah Kota Madiun"],
    ["Unit Eselon I/II", ":", "Badan Perencanaan, Penelitian dan Pengembangan Daerah"],
    ["Program", ":", "Program Penunjang Urusan Pemerintahan Daerah Kabupaten/Kota"],
    ["Kegiatan", ":", "Administrasi UMUM Perangkat Daerah"],
    ["Indikator Kinerja Kegiatan (Output)", ":", "Prosentase pemenuhan Administrasi Umum"],
    ["Volume Keluaran (target)", ":", "100"],
    ["Satuan Ukur Keluaran (Output)", ":", "%"],
  ])
  isi_subkegiatan = [ ["Sub Kegiatan", ":", "Penyelenggaraan Rapat Koordinasi dan Kunsultasi SKPD"],
  ["Indikator", ":", "Prosentase Pemenuhan kebutuhan perjalanan dinas"],
  ["Target", ":", "100 %"] ]
  tabel_subkegiatan = pdf.make_table([
  # nomor
    [ "1", isi_subkegiatan]
  ])
  tabel_program_kegiatan.draw
  pdf.move_down 30
  tabel_subkegiatan.draw
  pdf.move_down 10
  pdf.text "A. Latar Belakang"
  pdf.move_down 5
  pdf.text "1. Dasar Hukum",indent_paragraphs: 10
  pdf.move_down 5
  dasar_hukum1 =  "Peraturan menteri Dalam negeri Nomor 86 Tahun 2017 tentang Tata Cara Perencanaan, Pengendalian dan Evaluasi Pembangunan Daerah, Tata Cara Evaluasi Rancangan Peraturan Daerah, Tata Cara Evaluasi Rancangan Peraturan Daerah tentang Rencana Pembangunan Jangka Menengah Daerah, serta Tata Cara Perubahan Rencana Pembangunan Jangka Panjang Daerah, Rencana Pembangunan Jangka Menengah Daerah, dan Rencana Kerja Pemerintah Daerah;"
  
  pdf.bounding_box([50, pdf.cursor], width: 450) do
    pdf.text dasar_hukum1, align: :justify
  end
  pdf.move_down 5
  pdf.text "2. Gambaran Umum",indent_paragraphs: 10
  pdf.move_down 5
  gambaran_umum = "Bahwa dalam kegiatan ini pelaksanaan kegiatan yautu kepala sub bagian umum dan pegawaian badan perencanaan pembangunan daerah kota Madiun harus menyediakan dan memenuhi semua kebutuhan Rapat Koordinasi dan Konsultasi ke Luar Daerah Perangkat Daerah yang disertai dengan pendanaan , diantaranya :"
  pdf.bounding_box([50, pdf.cursor], width: 450) do
    pdf.text gambaran_umum, align: :justify
    pdf.text "1. Kepala OPD", align: :justify
    pdf.text "2. Sekretaris, Kepala Bidang, Subid, subag dan Staf Bappeda. Dan Tenaga pahan yang ada", align: :justify
  end
  
  pdf.move_down 10
  pdf.text "B. Penerima Manfaat"
  pdf.text "Penerima manfaat dari kegiatan ini adalah Semua Karyawan/karyawati Badan Pernecanaan, Penelitian dan Pengembangan Daerah Kota Madiun", align: :justify
  
  pdf.move_down 10
  pdf.text "C. Strategi Pencapaain Keluaran"
end