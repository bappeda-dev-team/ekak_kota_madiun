prawn_document(filename: @filename, page_layout: :landscape, disposition: "attachment") do |pdf|
  # pdf.font_families.clear
  # pdf.font_families.update("DejaVuSans" =>
  #   {
  #     normal: "vendor/assets/fonts/DejaVuSans.ttf",
  #     italic: "vendor/assets/fonts/DejaVuSans.ttf",
  #     bold: "vendor/assets/fonts/DejaVuSans-Bold.ttf"
  #   })
  # pdf.font "DejaVuSans"
  size_cell = 8
  height_nested = 80
  pdf.text "DAFTAR TEMATIK #{@nama_file}", align: :center
  pdf.move_down 3
  pdf.text "KOTA MADIUN TAHUN #{@tahun}", align: :center

  pdf.move_down 20
  header_tabel_usulan = [
    [{ content: 'No', align: :center }, { content: 'Sasaran Kinerja', align: :center },
     { content: 'Anggaran', align: :center },
     { content: 'Sub Kegiatan', align: :center },
     { content: 'Program', align: :center },
     { content: 'OPD', align: :center }]
  ]

  @tematiks.each.with_index(1) do |tematik, i|
    # indikator_arr = []
    # target_arr = []
    # satuan_arr = []
    # if tematik.indikator_sasarans.empty?
    #   rowspan = 1
    #   indikator_arr << ['-']
    #   target_arr << ['-']
    #   satuan_arr << ['-']
    # else
    #   rowspan = tematik.indikator_sasarans.count
    #   tematik.indikator_sasarans.each do |indikator|
    #     indikator_arr << [{ content: indikator.indikator_kinerja, align: :center }]
    #     target_arr << [{ content: indikator.target.to_s, align: :center }]
    #     satuan_arr << [{ content: indikator.satuan, align: :center }]
    #   end
    # end
    # indikator_table = pdf.make_table(indikator_arr,
    #                                  cell_style: { size: size_cell, height: height_nested },
    #                                  width: width_nested)
    # target_table = pdf.make_table(target_arr,
    #                               cell_style: { size: size_cell, height: height_nested },
    #                               width: 20)
    # satuan_table = pdf.make_table(satuan_arr,
    #                               cell_style: { size: size_cell, height: height_nested },
    #                               width: 20)
    header_tabel_usulan << [{ content: i.to_s, height: height_nested, align: :center,
                              valign: :center },
                            { content: tematik.sasaran_kinerja, height: height_nested, width: 85, align: :left,
                              valign: :center, size: size_cell },
                            { content: "Rp. #{number_with_delimiter(tematik.total_anggaran)}", height: height_nested,
                              width: 40, valign: :center, size: size_cell },
                            { content: tematik.program_kegiatan&.nama_subkegiatan || '-', height: height_nested,
                              width: 60, valign: :center, size: size_cell },
                            { content: tematik.program_kegiatan&.nama_program || '-', height: height_nested, width: 60,
                              valign: :center, size: size_cell, padding: 2 },
                            { content: tematik.opd.nama_opd, height: height_nested, width: 40, valign: :center,
                              size: size_cell, padding: 5 }]
  end
  footer_tabel_usulan = [{ content: 'Jumlah', colspan: 2 },
                         "Rp. #{number_with_delimiter(@tematiks.map(&:total_anggaran).compact.sum)}",
                         { content: '', colspan: 3 }]
  header_tabel_usulan << footer_tabel_usulan
  pdf.table(header_tabel_usulan,
            column_widths: { 0 => 50 },
            cell_style: { size: size_cell, padding: 5 }, width: pdf.bounds.width)
end
