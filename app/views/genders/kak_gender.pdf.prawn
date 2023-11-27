prawn_document(filename: @filename, disposition: 'attachment') do |pdf|
  # pdf.font_families.clear
  # pdf.font_families.update("TiroKannada" => {
  #                                     normal: "vendor/assets/fonts/TiroKannada-Regular.ttf",
  #                                     italic: "vendor/assets/fonts/TiroKannada-Italic.ttf",
  #                                     bold: "vendor/assets/fonts/NotoSerif-Bold.ttf"
  #                                     })
  # pdf.font "TiroKannada"
  pdf.text 'PERNYATAAN ANGGARAN GENDER', size: 16, align: :center
  pdf.text '(GENDER BUDGET STATEMENT)', align: :center
  # tabel pertama
  pdf.move_down 20
  cell_pembuka_wawasan = []
  cell_penyebab_internal = []
  cell_penyebab_external = []
  if @gender.sasaran.present?
    cell_pembuka_wawasan << ['-', @gender.data_terpilah.to_sentence || '-']
    cell_penyebab_internal << ['-', @gender.penyebab_internal.to_sentence || '-']
    cell_penyebab_external << ['-', @gender.penyebab_external.to_sentence || '-']
  else
    cell_pembuka_wawasan << ['-', '-']
    cell_penyebab_internal << ['-', '-']
    cell_penyebab_external << ['-', '-']
  end
  # width table, the table_subtable is the first child
  # the subtable is the 2nd child table
  table_subtable_width = pdf.bounds.width - 70
  col_0_subtable_width = 12
  subtable_width = table_subtable_width - 32

  tabel_pembuka_wawasan = pdf.make_table(cell_pembuka_wawasan,
                                         cell_style: { size: 8, border_width: 0 },
                                         column_widths: { 0 => col_0_subtable_width, 1 => subtable_width })

  tabel_faktor_kesenjangan = pdf.make_table([
                                              ['Akses', @gender.akses || '-'],
                                              ['Partisipasi', @gender.partisipasi || '-'],
                                              ['Kontrol', @gender.kontrol || '-'],
                                              ['Manfaat', @gender.manfaat || '-']
                                            ],
                                            cell_style: { size: 8, border_width: 0 },
                                            column_widths: { 0 => 46 },
                                            width: 150.mm)

  tabel_internal = pdf.make_table(cell_penyebab_internal,
                                  cell_style: { size: 8, border_width: 0 },
                                  column_widths: { 0 => col_0_subtable_width, 1 => subtable_width })

  tabel_external = pdf.make_table(cell_penyebab_external,
                                  cell_style: { size: 8, border_width: 0 },
                                  column_widths: { 0 => col_0_subtable_width, 1 => subtable_width })
  tabel_kesenjangan = pdf.make_table([
                                       ['1.', { content: 'Data Pembuka Wawasan' }],
                                       ['', tabel_pembuka_wawasan],
                                       ['2.', { content: 'Isu dan Faktor Kesenjangan Gender' }],
                                       ['', 'a. Faktor Kesenjangan'],
                                       ['', tabel_faktor_kesenjangan],
                                       ['', 'b. Penyebab Internal'],
                                       ['', tabel_internal],
                                       ['', 'c. Penyebab Eksternal'],
                                       ['', tabel_external]
                                     ],
                                     cell_style: { size: 8, border_width: 0 },
                                     column_widths: { 0 => 20 }, width: table_subtable_width)

  indikator_program = @program_kegiatan&.indikator_program_tahun(@tahun, @opd.kode_unik_opd)
  indikator_kegiatan = @program_kegiatan&.indikator_kegiatan_tahun(@tahun, @opd.kode_unik_opd)
  indikator_subkegiatan = @program_kegiatan&.indikator_subkegiatan_tahun(@tahun, @opd.kode_unik_opd)

  tabel_capaian_program = pdf.make_table([
                                           ['1.', { content: 'Tolok Ukur' }],
                                           ['', '-'],
                                           ['2.', 'Indikator Kinerja dan Target Kinerja'],
                                           ['-',
                                            "#{indikator_program&.dig(:indikator) || '-'} #{indikator_program&.dig(:target) || '-'} #{indikator_program&.dig(:satuan) || '-'}"]
                                         ],
                                         cell_style: { size: 8, border_width: 0 },
                                         column_widths: { 0 => 20 }, width: table_subtable_width)
  tabel_rencana_aksi = pdf.make_table([
                                        [{ content: 'Kegiatan', rowspan: 5, borders: [:right], border_width: 0 }],
                                        [@program_kegiatan.nama_kegiatan || '-'],
                                        ["Masukan: Rp. #{number_with_delimiter(indikator_kegiatan&.dig(:pagu)) || 0}"],
                                        ["Keluaran: #{indikator_kegiatan&.dig(:indikator) || '-'}"],
                                        ["Hasil: #{indikator_kegiatan&.dig(:target) || '-'} #{indikator_kegiatan&.dig(:satuan) || '-'}"],
                                        [{ content: 'Sub Kegiatan', rowspan: 5, borders: [:right], border_width: 0 }],
                                        [@program_kegiatan.nama_kegiatan || '-'],
                                        ["Masukan: Rp. #{number_with_delimiter(indikator_subkegiatan&.dig(:pagu)) || 0}"],
                                        ["Keluaran: #{indikator_subkegiatan&.dig(:indikator) || '-'}"],
                                        ["Hasil: #{indikator_subkegiatan&.dig(:target) || '-'} #{indikator_subkegiatan&.dig(:satuan) || '-'}"]
                                      ],
                                      cell_style: { size: 8, border_width: 0 }, width: table_subtable_width)
  tabel_program_kegiatan = [
    ['SKPD', { content: @program_kegiatan.opd.nama_opd, font_style: :bold }],
    ['TAHUN ANGGARAN', { content: @tahun, font_style: :bold }],
    ['PROGRAM', { content: @program_kegiatan.nama_program }],
    ['KODE PROGRAM', { content: @program_kegiatan.kode_program }],
    [{ content: 'ANALISIS SITUASI' }, { content: tabel_kesenjangan }],
    ['CAPAIAN PROGRAM', tabel_capaian_program],
    ['JUMLAH ANGGARAN SUBKEGIATAN',
     { content: "Rp. #{number_with_delimiter(@gender.anggaran_gender)}", font_style: :bold }],
    ['RENCANA AKSI', tabel_rencana_aksi]
  ]
  pdf.table(tabel_program_kegiatan,
            column_widths: { 0 => 70 },
            cell_style: { size: 8, border_width: 1 },
            width: pdf.bounds.width)
  # after tabel pertama
  pdf.move_down 30
  # loop sasaran
  pdf.start_new_page if (pdf.cursor - 111).negative?
  pdf.bounding_box([pdf.bounds.width - 300, pdf.cursor - 10], width: pdf.bounds.width - 200) do
    pdf.text "Madiun, #{I18n.l Date.today}", size: 8, align: :center
    pdf.move_down 5
    pdf.text "<strong>Kepala</strong>", size: 8, align: :center, inline_format: true
    pdf.text "<strong>#{@program_kegiatan.opd.nama_opd}</strong>", size: 8, align: :center, inline_format: true
    pdf.move_down 50
    pdf.text "<u>#{@program_kegiatan.opd.nama_kepala || '!!belum disetting'}</u>", size: 8, align: :center,
                                                                                   inline_format: true
    pdf.text @program_kegiatan.opd.pangkat_kepala || '!! belum disetting', size: 8, align: :center
    pdf.text "NIP. #{@program_kegiatan.opd.nip_kepala || '!! belum disetting'}", size: 8, align: :center
  end
end
