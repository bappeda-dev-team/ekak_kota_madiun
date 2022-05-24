prawn_document do |pdf|
  pdf.text 'KERANGKA ACUAN KERJA/ TERM OF REFERENCE', size: 16, align: :center
  pdf.text "KELUARAN (OUTPUT) KEGIATAN TA #{@program_kegiatan.created_at.year}", align: :center
  # tabel pertama
  pdf.move_down 20
  tabel_program_kegiatan = [
    ['Perangkat Daerah', ':', { content: @program_kegiatan.opd.nama_opd, font_style: :bold }],
    ['Program', ':', { content: @program_kegiatan.nama_program, font_style: :bold }],
    ['Indikator Kinerja Program', ':', @program_kegiatan.indikator_program],
    ['Target', ':', @program_kegiatan.target_program],
    ['Satuan', ':', @program_kegiatan.satuan_target_program],
    ['', '', ''],
    ['Kegiatan', ':', { content: @program_kegiatan.nama_kegiatan, font_style: :bold }],
    ['Indikator Kinerja Kegiatan (Output)', ':', @program_kegiatan.indikator_kinerja],
    ['Target', ':', @program_kegiatan.target],
    ['Satuan', ':', @program_kegiatan.satuan],
    ['', '', ''],
    ['Sub Kegiatan', ':', { content: @program_kegiatan.nama_subkegiatan, font_style: :bold }],
    ['Indikator Kinerja Sub Kegiatan (Output)', ':', @program_kegiatan.indikator_subkegiatan],
    ['Target', ':', @program_kegiatan.target_subkegiatan.to_s],
    ['Satuan', ':', @program_kegiatan.satuan_target_subkegiatan.to_s],
    ['Jumlah Sasaran/Rencana Kinerja', ':', @program_kegiatan.sasarans.count]
  ]
  pdf.table(tabel_program_kegiatan, column_widths: { 0=> 150,1 => 12 }, cell_style: { size: 8, border_width: 0 }, width: pdf.bounds.width)
  # after tabel pertama
  pdf.move_down 30
  # loop sasaran
  @program_kegiatan.sasarans.where.not(program_kegiatan: nil).each.with_index(1) do |sasaran, index|
    dasar_hukum_arr = []
    permasalahan_arr = []
    indikator_arr = []
    satuan_arr = []
    target_arr = []
    sasaran_arr = [[sasaran.sasaran_kinerja]]
    if sasaran.indikator_sasarans.any?
      sasaran.indikator_sasarans.each do |indikator|
        indikator_arr << [indikator.indikator_kinerja]
        satuan_arr << [indikator.satuan]
        target_arr << [indikator.target]
      end
    else
      indikator_arr = [['-']]
      satuan_arr = [['-']]
      target_arr = [['-']]
    end
    # DasarHukum
    if sasaran.dasar_hukums.any?
      sasaran.dasar_hukums.each do |dasar_hukum|
        dasar_hukum_arr << [dasar_hukum.judul]
      end
    else
      dasar_hukum_arr = [['-']]
    end
    if sasaran.permasalahans.any?
      sasaran.permasalahans.each do |permasalahan|
        permasalahan_arr << [permasalahan.permasalahan]
        permasalahan_arr << ['Penyebab', '']
        permasalahan_arr << ['1. Internal']
        permasalahan_arr << [permasalahan.penyebab_internal || '-']
        permasalahan_arr << ['2. External']
        permasalahan_arr << [permasalahan.penyebab_external || '-']
      end
    else
      permasalahan_arr = [
        ['-', ''],
        ['Penyebab', ''],
        ['1. Internal'],
        ['-', ''],
        ['2. External'],
        ['-', '']
      ]
    end
    sasaran_cell = pdf.make_table(sasaran_arr, cell_style: {size: 8, border_width: 0}, width: 388)
    indikator_cell = pdf.make_table(indikator_arr, cell_style: {size: 8, border_width: 0}, width: 388)
    satuan_cell = pdf.make_table(satuan_arr, cell_style: {size: 8, border_width: 0}, width: 388)
    target_cell = pdf.make_table(target_arr, cell_style: {size: 8, border_width: 0}, width: 388)
    dasar_hukum_cell = pdf.make_table(dasar_hukum_arr, cell_style: {size: 8, border_width: 0}, width: 300)
    permasalahan_cell = pdf.make_table(permasalahan_arr, cell_style: {size: 8, border_width: 0}, width: 300)
    sasaran_judul = [
      [{ content: "#{index}.", font_style: :bold }, { content: "Sasaran/Rencana Kinerja", font_style: :bold }, ':', sasaran_cell],
      ['', 'Indikator Kinerja (Output)', ':', indikator_cell],
      ['', 'Target', ':', satuan_cell],
      ['', 'Satuan', ':', target_cell]
    ]
    dasar_hukum = [
      ['', 'a.', 'Dasar Hukum', ':', dasar_hukum_cell]
    ]
    gambaran_umum = [
      ['', 'b.', 'Gambaran Umum', ':', { content: sasaran.latar_belakangs.first&.gambaran_umum || '-' }]
    ]
    penerima_manfaat = [
      ['', 'c.', 'Penerima Manfaat', ':', { content: sasaran.penerima_manfaat || '-' }]
    ]
    data_terpilah = [
      ['', 'd.', 'Data Terpilah', ':', { content: sasaran.rincian&.data_terpilah || '-' }]
    ]
    permasalahan = [
      ['', 'e.', 'Permasalahan', ':', permasalahan_cell]
    ]
    rincian_sasaran = [
      ['', 'f.', 'Resiko', ':', { content: sasaran.rincian&.resiko || '-' }]
    ]
    rencana_aksi_judul = [
      ['', 'g.', {content: 'Rencana Aksi dan Anggaran'}]
    ]
    tabel_sasaran = pdf.make_table(sasaran_judul, column_widths: { 0=> 17, 2=> 13 }, cell_style: { size: 8, border_width: 0 }, width: pdf.bounds.width)
    tabel_dasar_hukum = pdf.make_table(dasar_hukum, column_widths: { 0=> 17, 1=>17, 2=> 88, 3=> 12  }, cell_style: { size: 8, border_width: 0, :overflow => :expand }, width: pdf.bounds.width)
    tabel_gambaran_umum = pdf.make_table(gambaran_umum, column_widths: { 0=> 17, 1=>17, 2=> 88, 3=> 12  }, cell_style: { size: 8, border_width: 0, :overflow => :expand }, width: pdf.bounds.width)
    tabel_penerima_manfaat = pdf.make_table(penerima_manfaat, column_widths: { 0=> 17, 1=>17, 2=> 88, 3=> 12  }, cell_style: { size: 8, border_width: 0, :overflow => :expand }, width: pdf.bounds.width)
    tabel_data_terpilah = pdf.make_table(data_terpilah, column_widths: { 0=> 17, 1=>17, 2=> 88, 3=> 12  }, cell_style: { size: 8, border_width: 0, :overflow => :expand }, width: pdf.bounds.width)
    tabel_permasalahan = pdf.make_table(permasalahan, column_widths: { 0=> 17, 1=>17, 2=> 88, 3=> 12  }, cell_style: { size: 8, border_width: 0, :overflow => :expand }, width: pdf.bounds.width)
    tabel_rincian = pdf.make_table(rincian_sasaran, column_widths: { 0=> 17, 1=>17, 2=> 88, 3=> 12  }, cell_style: { size: 8, border_width: 0, :overflow => :expand }, width: pdf.bounds.width)
    tabel_rencana_aksi_judul = pdf.make_table(rencana_aksi_judul, column_widths: { 0=> 17, 1=>17}, cell_style: { size: 8, border_width: 0 })
    # pdf.table(tabel_sasaran, column_widths: { 0=> 17, 2=> 13 }, cell_style: { size: 8, border_width: 0 })
    tabel_sasaran.draw
    tabel_dasar_hukum.draw
    tabel_gambaran_umum.draw
    tabel_penerima_manfaat.draw
    tabel_data_terpilah.draw
    tabel_permasalahan.draw
    tabel_rincian.draw
    tabel_rencana_aksi_judul.draw
    pdf.move_down 10
    data_rencana_aksi = [[{ content: 'No', rowspan: 2 }, { content: 'Tahapan Kerja', rowspan: 2 },
                          { content: 'Target pada bulan', colspan: 12 }, { content: 'Jumlah', rowspan: 2 },
                          { content: 'Pagu Anggaran', rowspan: 2 }, { content: 'Keterangan', rowspan: 2 }], %w[1 2 3 4 5 6 7 8 9 20 11 12]]

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

  tabel_renaksi = pdf.make_table(data_rencana_aksi, column_widths: { 0 => 17, 1 => 130, 14 => 30 }, cell_style: { size: 6, align: :left }, width: pdf.bounds.width)
  if pdf.cursor - tabel_renaksi.height < 0
    pdf.start_new_page
  end
  tabel_renaksi.draw
  data_rencana_aksi.clear

  # Usulan
  pdf.move_down 10
  tabel_usulan = [
    ['', 'h.', 'Usulan yang terakomodir']
  ]
  pdf.table(tabel_usulan, column_widths: { 0=> 17, 1=>17 }, cell_style: { size: 8, border_width: 0 })
  data_penerima_manfaat = [['No', 'Jenis Usulan', 'Usulan', 'Permasalahan/ Uraian', 'Keterangan']]
  count = 0
  sasaran.my_usulan.each do |u|
  count += 1
  keterangan = u.try(:alamat) || u.try(:peraturan_terkait) || u.try(:manfaat)
  tipe = u.class.try(:type) || u.class.name.to_s
  data_penerima_manfaat << [count, tipe, u.usulan, u.uraian, keterangan]
  end
  pdf.move_down 10
  tabel_penerima_manfaat = pdf.make_table(data_penerima_manfaat, column_widths: { 0 => 17, 1 => 50, 2 => 100 },
            cell_style: { size: 6, align: :left }, width: pdf.bounds.width)
  tabel_penerima_manfaat.draw
  pdf.move_down 30
  if pdf.cursor - tabel_penerima_manfaat.height < 0
    pdf.start_new_page
  end
end
pdf.bounding_box([pdf.bounds.width - 300, pdf.cursor - 50], width: pdf.bounds.width - 200) do
  pdf.text "Madiun, #{I18n.l Date.today}", size: 8, align: :center
  pdf.move_down 5
  pdf.text "<strong>Kepala</strong>", size: 8, align: :center, inline_format: true
  pdf.text "<strong>#{@program_kegiatan.opd.nama_opd}</strong>", size: 8, align: :center, inline_format: true
  pdf.move_down 50
  pdf.text "<u>#{@program_kegiatan.opd.nama_kepala || '!!belum disetting'}</u>", size: 8, align: :center, inline_format: true
  pdf.text "#{@program_kegiatan.opd.pangkat_kepala || '!! belum disetting'}", size: 8, align: :center
  pdf.text "NIP. #{@program_kegiatan.opd.nip_kepala || '!! belum disetting'}", size: 8, align: :center
end
end
