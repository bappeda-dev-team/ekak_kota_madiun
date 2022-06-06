prawn_document(filename: @filename, page_layout: :landscape) do |pdf|
  pdf.text 'GENDER ANALYSIS PATHWAY (GAP)', size: 16, align: :center
  # tabel pertama
  pdf.move_down 20
  header_gap_atas = [
    [{ content: 'Nama Kebijakan', rowspan: 2, valign: :center, align: :center },
     { content: 'Data Pembuka Wawasan', rowspan: 2, valign: :center, align: :center },
     { content: 'Isu Gender', colspan: 3, align: :center },
     { content: 'Kebijakan dan Rencana kedeapan', colspan: 2, align: :center }, { content: 'Pengukuran Hasil', colspan: 2, align: :center }],
  ]
  sub_header_gap = [{ content: 'Faktor Kesenjangan', align: :center }, { content: 'Sebab Kesenjangan Internal', align: :center },
                    { content: 'Sebab Kesenjangan Eksternal', align: :center}, { content: 'Reformulasi tujuan', align: :center },
                    { content: 'Rencana Aksi', align: :center }, { content: 'Basis data', align: :center },
                    { content: 'Indikator Kinerja', align: :center }]
  subkegiatan = []
  @program_kegiatan.sasarans.each do |s|
    subkegiatan << [{content: @program_kegiatan.nama_subkegiatan + '-subgiat'}]
    s.permasalahans.each do |perm|
      subkegiatan << [{content: s.rincian&.data_terpilah}, { content: perm.permasalahan, align: :center }, { content: perm.penyebab_internal}, { content: perm.penyebab_external}]
    end
    subkegiatan.flatten!
  end
  # subkegiatan << data_wawasan
  header_gap_atas << sub_header_gap << subkegiatan
  pdf.table(header_gap_atas, cell_style: { size: 8 }, width: pdf.bounds.width)
end
