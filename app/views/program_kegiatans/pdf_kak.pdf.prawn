prawn_document do |pdf|
  pdf.text 'KERANGKA ACUAN KERJA/ TERM OF REFERENCE', size: 16, align: :center
  pdf.text "KELUARAN (OUTPUT) KEGIATAN TA #{@program_kegiatan.created_at.year}", align: :center
  # tabel pertama
  pdf.move_down 20
  tabel_program_kegiatan = [
    ['Kementrian negara/Lembaga', ':', { content: 'Pemerintah Daerah Kota Madiun', font_style: :bold }],
    ['Unit Eselon I/II', ':', { content: 'Badan Perencanaan, Penelitian dan Pengembangan Daerah', font_style: :bold }],
    ['Program', ':', { content: @program_kegiatan.nama_program, font_style: :bold }],
    ['Indikator Program (Outcome)', ':', @program_kegiatan.indikator_program],
    ['Target', ':', @program_kegiatan.target_program],
    ['Satuan', ':', @program_kegiatan.satuan_target_program],
    ['Kegiatan', ':', { content: @program_kegiatan.nama_kegiatan, font_style: :bold }],
    ['Indikator Kinerja Kegiatan (Output)', ':', @program_kegiatan.indikator_kinerja],
    ['Volume Keluaran (Target)', ':', @program_kegiatan.target],
    ['Satuan Ukur Keluaran (Output)', ':', @program_kegiatan.satuan],
    ['Sub Kegiatan', ':', { content: @program_kegiatan.nama_subkegiatan, font_style: :bold }],
    ['Indikator Sub Kegiatan (Output)', ':', @program_kegiatan.indikator_subkegiatan],
    ['Target', ':', @program_kegiatan.target_subkegiatan.to_s],
    ['Satuan', ':', @program_kegiatan.satuan_target_subkegiatan.to_s]
  ]
  pdf.table(tabel_program_kegiatan, cell_style: { size: 8, align: :justify, border_width: 0 })
  pdf.move_down 20
  pdf.text 'A. Latar Belakang', size: 14, style: :bold
  pdf.move_down 10
  pdf.text '1. Dasar Hukum', indent_paragraphs: 5, size: 12, style: :bold
  pdf.move_down 5
  @program_kegiatan.sasarans.each.with_index(1) do |hukum, i|
    hukum.dasar_hukums.order(:updated_at).each do |dasar_hukum|
      pdf.bounding_box([20, pdf.cursor], width: pdf.bounds.width - 20) do
        pdf.text "#{i}. #{dasar_hukum.judul}", align: :justify, size: 10
        pdf.text "#{i}. #{dasar_hukum.peraturan}", align: :justify, size: 10
      end
    end
  end
  pdf.move_down 10
  pdf.text '2. Gambaran Umum', indent_paragraphs: 5, size: 12, style: :bold
  pdf.move_down 5
  pdf.indent(20) do
    @program_kegiatan.sasarans.where.not(program_kegiatan: nil).each do |sas_gambumum|
      pdf.text "Gambaran Umum Sasaran #{sas_gambumum.sasaran_kinerja}", align: :justify, size: 10
      pdf.move_down 5
      sas_gambumum.latar_belakangs.order(:updated_at).each do |gambumum|
        pdf.text gambumum.gambaran_umum, align: :justify, size: 10
      end
      pdf.move_down 10
      pdf.text 'Permasalahan:'
      pdf.move_down 5
      sas_gambumum.permasalahans.each do |masalah|
        pdf.text "JENIS PERMASALAHAN : Permasalahan #{masalah.jenis}", align: :justify, size: 10
        pdf.text "PERMASALAHAN :  #{masalah.permasalahan}", align: :justify, size: 10
        pdf.text "PENYEBAB INTERNAL :  #{masalah.penyebab_internal}", align: :justify, size: 10
        pdf.text "PENYEBAB EXTERNAL :  #{masalah.penyebab_external}", align: :justify, size: 10
      end
      pdf.move_down 10
      pdf.text 'Data Terpilah:'
      pdf.move_down 5
      pdf.text "DATA TERPILAH : #{sas_gambumum.rincian.data_terpilah}", align: :justify, size: 10
      pdf.text "RESIKO : #{sas_gambumum.rincian.resiko}", align: :justify, size: 10
    end
  end

  pdf.move_down 20
  pdf.text 'B. Penerima Manfaat', size: 14, style: :bold
  data_penerima_manfaat = [['No', 'Rencana Kinerja', 'Penerima Manfaat', 'Nama Usulan',
                            'Jenis Usulan', 'Permasalahan/ Uraian', 'Keterangan']]
  count = 0
  @program_kegiatan.sasarans.each.map do |sasaran|
    sasaran.my_usulan.each do |u|
      count += 1
      keterangan = u.try(:alamat) || u.try(:peraturan_terkait) || u.try(:manfaat)
      tipe = u.class.try(:type) || u.class.name.to_s
      data_penerima_manfaat << [count, sasaran.sasaran_kinerja.to_s, sasaran.penerima_manfaat.to_s, u.usulan,
                                tipe, u.uraian, keterangan]
    end
  end
  pdf.move_down 10
  pdf.table(data_penerima_manfaat, column_widths: { 0 => 17, 1 => 150, 2 => 50, 4 => 50, 5 => 100 },
                                   cell_style: { size: 6, align: :left }, width: pdf.bounds.width)

  pdf.move_down 20
  pdf.text 'C. Capaian Keluaran ( Jadwal & Anggaran )', size: 14, style: :bold
  # sasaran 1
  pdf.move_down 10
  @program_kegiatan.sasarans.order(:created_at).each.with_index(1) do |sasaran, index|
    data_rencana_aksi = [[{ content: 'No', rowspan: 2 }, { content: 'Tahapan Kerja', rowspan: 2 }, { content: 'Target pada bulan', colspan: 12 }, { content: 'Jumlah', rowspan: 2 },
                          { content: 'Pagu Anggaran', rowspan: 2 }, { content: 'Keterangan', rowspan: 2 }],
                         %w[1 2 3 4 5 6 7 8 9 10 11 12]]
    pdf.text "Sasaran #{index}:   #{sasaran.sasaran_kinerja}", size: 12, style: :bold
    pdf.move_down 7

    sasaran.tahapans.each.with_index(1) do |tahapan, i|
      data_rencana_aksi << [i, tahapan.tahapan_kerja,
                            tahapan.find_target_bulan(1),
                            tahapan.find_target_bulan(2),
                            tahapan.find_target_bulan(3),
                            tahapan.find_target_bulan(4),
                            tahapan.find_target_bulan(5),
                            tahapan.find_target_bulan(6),
                            tahapan.find_target_bulan(7),
                            tahapan.find_target_bulan(8),
                            tahapan.find_target_bulan(9),
                            tahapan.find_target_bulan(10),
                            tahapan.find_target_bulan(11),
                            tahapan.find_target_bulan(12),
                            tahapan.target_total,
                            "Rp. #{number_with_delimiter(tahapan.anggaran_tahapan, delimiter: '.')}",
                            tahapan.keterangan]
    end
    data_rencana_aksi << [{ content: "Total sasaran ini adalah #{sasaran.waktu_total} bulan", colspan: 14 },
                          sasaran.jumlah_target, "Rp. #{number_with_delimiter(sasaran.total_anggaran, delimiter: '.')}", '']
    pdf.table(data_rencana_aksi, column_widths: { 0 => 17, 1 => 150 }, cell_style: { size: 6, align: :left }, width: pdf.bounds.width)
    data_rencana_aksi.clear
    pdf.move_down 5
    pdf.text "Pemilik Sasaran: #{sasaran.user.nama}", size: 6
    pdf.move_down 10
  end
  pdf.move_down 10
  pdf.text "Total waktu yang diperlukan dalama pencapaian output sub kegiatan ini adalah #{@program_kegiatan.my_waktu} bulan",
           size: 8
  pdf.move_down 10
  pdf.text "Pagu Anggaran yang diperlukan dalam sub kegiatan ini, adalah sebesar Rp. #{number_with_delimiter(@program_kegiatan.my_pagu, delimiter: '.')}",
           size: 8

end
