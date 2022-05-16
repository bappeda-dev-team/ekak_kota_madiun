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
  pdf.table(tabel_program_kegiatan, cell_style: { size: 8, border_width: 0 })
  # after tabel pertama
  pdf.move_down 30
  # loop sasaran 
  
  @program_kegiatan.sasarans.where.not(program_kegiatan: nil).each.with_index(1) do |sasaran, index|
    dasar_hukum_cell = pdf.make_cell(content: sasaran.dasar_hukums.size.to_s)
    tabel_sasaran = [
      [index, { content: "Sasaran/Rencana Kinerja #{index}", font_style: :bold }, ':', { content: sasaran.sasaran_kinerja }],
      ['', 'Indikator Kinerja Sub Kegiatan (Output)', ':', { content: @program_kegiatan.indikator_subkegiatan }],
      ['', 'Target', ':', { content: @program_kegiatan.target_subkegiatan.to_s }],
      ['', 'Satuan', ':', { content: @program_kegiatan.satuan_target_subkegiatan.to_s }],
      ['', '', '', ''],
      ['a.', 'Dasar Hukum', ':', dasar_hukum_cell],
      ['b.', 'Gambaran Umum', ':', { content: sasaran.latar_belakangs.first&.gambaran_umum }],
      ['c.', 'Penerima Manfaat', ':', { content: sasaran.penerima_manfaat }],
      ['d.', 'Data Terpilah', ':', { content: sasaran.rincian&.data_terpilah }],
      ['e.', 'Permasalahan', ':', { content: sasaran.permasalahans.first&.permasalahan }],
      ['f.', 'Penyebab', '', ''],
      ['', '1. Internal', ':', { content: sasaran.permasalahans.first&.penyebab_internal }],
      ['', '2. External', ':', { content: sasaran.permasalahans.first&.penyebab_external }],
      ['g.', 'Resiko', ':', { content: sasaran.rincian&.resiko }],
      ['h.', 'Rencana Aksi dan Anggaran', ':', { content: 'Pending' }],
      ['i.', 'Usulan yang terakomodir', '', ''],
      ['', 'Musrenbang', '', ''],
      ['', 'Pokir', '', ''],
      ['', 'Mandatori', '', ''],
      ['', 'Inisiatif Walikota', '', '']
    ]
    pdf.table(tabel_sasaran, cell_style: { size: 8, border_width: 0 })
    pdf.move_down 30
  end
end
