prawn_document(filename: @filename, disposition: "attachment", page_layout: :landscape,
               page_size: [612.0, 1008.0]) do |pdf|
  size_cell = 8
  height_nested = 50
  height_row = 50
  width_nested = 100
  width_sub_ket = 20
  width_sas_array = 140
  width_ind_sas_array = 120
  height_ind_sas_array = 100
  width_sub = 100
  rowspan = 0
  pdf.text "DAFTAR SASARAN KINERJA PER SUB KEGIATAN", align: :center
  pdf.move_down 3
  pdf.text "RENCANA KERJA  BADAN PERENCANAAN, PENELITIAN DAN PENGEMBANGAN DAERAH KOTA MADIUN", align: :center
  pdf.move_down 3
  pdf.text "TAHUN #{@tahun}", align: :center
  # pdf.text "#{@nama_opd.upcase}", align: :center

  pdf.move_down 20
  header_tabel_subkegiatan = [
    [{ content: "No", align: :center }, { content: "SUB KEGIATAN", align: :center },
     { content: "INDIKATOR", align: :center }, { content: "TARGET", align: :center }, { content: "SATUAN", align: :center },
     { content: "PAGU ANGGARAN", align: :center },
     { content: "SASARAN KINERJA", align: :center },
     { content: "INDIKATOR", align: :center },
     { content: "TARGET", align: :center },
     { content: "SATUAN", align: :center },
     { content: "PAGU ANGGARAN", align: :center },
     { content: "JENIS USULAN", align: :center },
     { content: "CATATAN", align: :center }]
  ]

  @program_kegiatans.limit(5).each.with_index(1) do |pk, i|
    sasaran_arr = []
    indikator_sasaran_arr = []
    target_indikator_sasaran_arr = []
    satuan_indikator_sasaran_arr = []
    pk.sasarans.where(tahun: @tahun).each.with_index(1) do |s, no|
      # indikator_table = pdf.make_table(indikator_sasaran_arr, cell_style: { size: size_cell, height: height_nested, valign: :center },
      #                                                         width: width_nested)
      sasaran_arr << [{ content: no.to_s, align: :center, width: width_sub_ket, height: 100, rowspan: s.indikator_sasarans.size },
                      { content: s.sasaran_kinerja, align: :left, width: width_sas_array, height: 100,
                        rowspan: s.indikator_sasarans.size }]
      s.indikator_sasarans.each do |ind|
        indikator_sasaran_arr << [{ content: ind.indikator_kinerja, width: width_ind_sas_array }]
        target_indikator_sasaran_arr << [{ content: ind.target, width: 100 }]
        satuan_indikator_sasaran_arr << [{ content: ind.satuan, width: 100 }]
      end
    end
    sasaran_table = pdf.make_table(sasaran_arr,
                                   cell_style: { size: size_cell, valign: :center }, width: width_sub_ket + width_sas_array)
    indikator_table = pdf.make_table(indikator_sasaran_arr,
                                     cell_style: { size: size_cell, valign: :center }, width: width_ind_sas_array)

    header_tabel_subkegiatan << [{ content: i.to_s, width: width_sub_ket, align: :center, valign: :center },
                                 { content: pk.nama_subkegiatan, valign: :center, width: width_sub },
                                 { content: pk.indikator_subkegiatan, valign: :center, width: width_sub },
                                 { content: pk.target_subkegiatan, valign: :center, align: :center, width: width_sub_ket },
                                 { content: pk.satuan_target_subkegiatan, valign: :center, align: :center, width: width_sub_ket },
                                 {
                                   content: "Rp. #{number_with_delimiter(pk.sasarans.where(tahun: @tahun).map(&:total_anggaran).compact.sum)}", width: width_sub_ket, valign: :center
                                 }, sasaran_table, indikator_table]
  end
  footer_tabel_subkegiatan = [{ content: "Jumlah", colspan: 5 },
                              "Rp. #{number_with_delimiter(@program_kegiatans.map do |pr|
                                                             pr.sasarans.sudah_lengkap.map do |s|
                                                               s.total_anggaran
                                                             end.compact.sum
                                                           end.compact.sum)}"]
  header_tabel_subkegiatan << footer_tabel_subkegiatan
  pdf.table(header_tabel_subkegiatan, cell_style: { size: size_cell }, width: pdf.bounds.width, header: true)
end
