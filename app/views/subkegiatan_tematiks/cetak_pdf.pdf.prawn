prawn_document(filename: @filename, page_layout: :landscape, disposition: "inline") do |pdf|
  pdf.font_families.clear
  pdf.font_families.update("TiroKannada" => {
                                      normal: "vendor/assets/fonts/TiroKannada-Regular.ttf",
                                      italic: "vendor/assets/fonts/TiroKannada-Italic.ttf",
                                      bold: "vendor/assets/fonts/NotoSerif-Bold.ttf"
                                      })
  pdf.font "TiroKannada"
  size_cell = 8
  height_nested = 200
  width_nested = 100
  rowspan = 0
  pdf.text "DAFTAR TEMATIK #{@nama_file}", align: :center
  pdf.move_down 3
  pdf.text "KOTA MADIUN TAHUN #{@tahun}", align: :center

  pdf.move_down 20
  header_tabel_usulan = [
    [{ content: 'No', align: :center }, { content: 'Sasaran Kinerja', align: :center },
     { content: 'Indikator', align: :center }, { content: 'Target', align: :center },
     { content: 'Satuan', align: :center }, { content: 'Anggaran', align: :center },
     { content: 'Sub Kegiatan', align: :center }, { content: 'Program', align: :center },
     { content: 'OPD', align: :center }]
  ]

  @tematiks.each.with_index(1) do |tematik, i|
    indikator_arr = []
    target_arr = []
    satuan_arr = []
    if tematik.indikator_sasarans.empty?
      rowspan = 1
      indikator_arr << ['-']
      target_arr << ['-']
      satuan_arr << ['-']
    else
      rowspan = tematik.indikator_sasarans.count
      tematik.indikator_sasarans.each do |indikator|
        indikator_arr << [{ content: indikator.indikator_kinerja, align: :center }]
        target_arr << [{ content: indikator.target.to_s, align: :center }]
        satuan_arr << [{ content: indikator.satuan, align: :center }]
      end
    end
    indikator_table = pdf.make_table(indikator_arr, cell_style: { size: size_cell, height: height_nested }, width: 30)
    target_table = pdf.make_table(target_arr, cell_style: { size: size_cell, height: height_nested }, width: 20)
    satuan_table = pdf.make_table(satuan_arr, cell_style: { size: size_cell, height: height_nested }, width: 20)
    header_tabel_usulan << [{ content: i.to_s, height: height_nested, width: 10, align: :center, valign: :center, rowspan: rowspan },
                            { content: tematik.sasaran_kinerja, height: height_nested, width: 85, align: :left, valign: :center, rowspan: rowspan, size: size_cell },
                            indikator_table, target_table, satuan_table,
                            { content: "Rp. #{number_with_delimiter(tematik.total_anggaran)}", height: height_nested, width: 40, valign: :center, rowspan: rowspan, size: size_cell },
                            { content: tematik.program_kegiatan&.nama_subkegiatan || '-', height: height_nested, width: 60, valign: :center, rowspan: rowspan, size: size_cell },
                            { content: tematik.program_kegiatan&.nama_program || '-', height: height_nested, width: 60, valign: :center, rowspan: rowspan, size: size_cell, padding: 2 },
                            { content: tematik.opd.nama_opd, height: height_nested, width: 40, valign: :center, rowspan: rowspan, size: size_cell, padding: 5 }]
  end
  footer_tabel_usulan = ['Jumlah', '', '', '', '', "Rp. #{number_with_delimiter(@tematiks.map(&:total_anggaran).compact.sum)}", '', '', '']
  header_tabel_usulan << footer_tabel_usulan
  pdf.table(header_tabel_usulan, cell_style: { size: size_cell }, width: pdf.bounds.width)
end
