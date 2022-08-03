prawn_document(filename: @filename, disposition: "attachment", page_layout: :landscape,
               page_size: [612.0, 1008.0]) do |pdf|
  size_cell = 8
  width_sub_ket = 20
  width_sub = 150
  width_ind_sub = 100
  width_target_sub = 20
  width_satuan_sub = 50
  width_pagu_sub = 50
  width_sub_sas = 18
  width_sas_array = 100
  width_ind_sas_array = 100
  width_target_ind_sas_array = 25
  width_satuan_ind_sas_array = 40
  width_pagu_sas_array = 80
  width_usulan_type = 80
  total_width_sas_array = width_sub_sas + width_sas_array + width_ind_sas_array + width_target_ind_sas_array + width_satuan_ind_sas_array + width_pagu_sas_array

  rowspan = @program_kegiatans.map { |up| up.sasarans.where(tahun: @tahun).size }.compact
  pdf.text "DAFTAR RESIKO RENCANa KINERJA", align: :center
  pdf.move_down 3
  pdf.text "RENCANA KERJA  BADAN PERENCANAAN, PENELITIAN DAN PENGEMBANGAN DAERAH KOTA MADIUN", align: :center
  pdf.move_down 3
  pdf.text "TAHUN #{@tahun}", align: :center
  # pdf.text "#{@nama_opd.upcase}", align: :center

  pdf.move_down 20
  header_tabel_subkegiatan = [
    [{ content: "No", align: :center }, { content: "SUB KEGIATAN", align: :center },
     { content: "SASARAN KINERJA", align: :center },
     { content: "KETERANGAN", align: :center }]
  ]

  @program_kegiatans.each.with_index(1) do |pk, i|
    sasaran_arr = []
    pk.sasarans.where(tahun: @tahun).each.with_index(1) do |s, no|
      s.indikator_sasarans.each do |ind|
        sasaran_arr << [{ content: no.to_s, align: :center, width: width_sub_sas, rowspan: s.indikator_sasarans.size },
                        { content: s.sasaran_kinerja, align: :left, width: width_sas_array,
                          rowspan: s.indikator_sasarans.size },
                        { content: ind.indikator_kinerja, width: width_ind_sas_array },
                        { content: ind.target.to_s, width: width_target_ind_sas_array },
                        { content: ind.satuan, width: width_satuan_ind_sas_array },
                        { content: "Rp. #{number_with_delimiter(s.total_anggaran)}", width: width_pagu_sas_array }]
      end
    end
    sasaran_table = pdf.make_table(sasaran_arr, cell_style: { size: size_cell, valign: :center },
                                                width: total_width_sas_array)

    header_tabel_subkegiatan << [{ content: i.to_s, width: width_sub_ket, align: :center, valign: :center },
                                 { content: pk.nama_subkegiatan, valign: :center, width: width_sub },
                                 { content: pk.indikator_subkegiatan, valign: :center, width: width_ind_sub },
                                 { content: pk.target_subkegiatan, valign: :center, align: :center, width: width_target_sub },
                                 { content: pk.satuan_target_subkegiatan, valign: :center, align: :center, width: width_satuan_sub },
                                 {
                                   content: "Rp. #{number_with_delimiter(pk.sasarans.where(tahun: @tahun).map(&:total_anggaran).compact.sum)}", width: width_pagu_sub, valign: :center
                                 }, sasaran_table,
                                 { content: "", width: width_satuan_sub }]
  end
  footer_tabel_subkegiatan = [{ content: "Jumlah", colspan: 5 },
                              "Rp. #{number_with_delimiter(@program_kegiatans.map do |pr|
                                                             pr.sasarans.sudah_lengkap.map do |s|
                                                               s.total_anggaran
                                                             end.compact.sum
                                                           end.compact.sum)}"]
  header_tabel_subkegiatan << footer_tabel_subkegiatan
  pdf.table(header_tabel_subkegiatan, cell_style: { size: size_cell }, width: pdf.bounds.width, header: true)
  pdf.text rowspan
end
