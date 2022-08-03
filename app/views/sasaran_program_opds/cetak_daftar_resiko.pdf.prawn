prawn_document(filename: @filename, disposition: "attachment", page_layout: :landscape,
               page_size: [612.0, 1008.0]) do |pdf|
  size_cell = 8
  width_sub_ket = 20
  width_sub = 150
  width_sub_sas = 18
  width_sas_array = 150
  width_ind_sas_array = 150
  width_target_ind_sas_array = 25
  width_satuan_ind_sas_array = 40
  width_pagu_sas_array = 80
  width_resiko_sas_array = 80
  total_width_sas_array = width_sub_sas + width_sas_array + width_ind_sas_array + width_target_ind_sas_array + width_satuan_ind_sas_array + width_pagu_sas_array + width_resiko_sas_array

  pdf.text "DAFTAR RESIKO RENCANa KINERJA", align: :center
  pdf.move_down 3
  pdf.text "RENCANA KERJA #{@opd.nama_opd.upcase} #{@opd.lembaga.nama_lembaga.upcase}", align: :center
  pdf.move_down 3
  pdf.text "TAHUN #{@tahun}", align: :center
  # pdf.text "#{@nama_opd.upcase}", align: :center

  pdf.move_down 20
  header_tabel_subkegiatan = [
    [{ content: "No", align: :center }, { content: "SUB KEGIATAN", align: :center },
     { content: "SASARAN KINERJA", align: :center }]
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
                        { content: "Rp. #{number_with_delimiter(s.total_anggaran)}", width: width_pagu_sas_array },
                        { content: s.rincian&.resiko || '', width: width_resiko_sas_array }]
      end
    end
    sasaran_table = pdf.make_table(sasaran_arr, cell_style: { size: size_cell, valign: :center },
                                                width: total_width_sas_array)

    header_tabel_subkegiatan << [{ content: i.to_s, width: width_sub_ket, align: :center, valign: :center },
                                 { content: pk.nama_subkegiatan, valign: :center, width: width_sub }, sasaran_arr]
  end
  pdf.table(header_tabel_subkegiatan, cell_style: { size: size_cell }, width: pdf.bounds.width, header: true)
end
