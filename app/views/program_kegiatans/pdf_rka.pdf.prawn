prawn_document(filename: @filename, disposition: "attachment") do |pdf|
  # pdf.font_families.clear
  # pdf.font_families.update("TiroKannada" => {
  #                                     normal: "vendor/assets/fonts/TiroKannada-Regular.ttf",
  #                                     italic: "vendor/assets/fonts/TiroKannada-Italic.ttf",
  #                                     bold: "vendor/assets/fonts/NotoSerif-Bold.ttf"
  #                                     })
  # pdf.font "TiroKannada"
  # pdf.font_size 16
  judul_rka = pdf.make_table([["RINCIAN BELANJA"], [@programKegiatan.opd.nama_opd]], width: pdf.bounds.width)
  judul_rka.draw
  pdf.move_down 7
  pdf.font_size 10
  pdf.table([
              ['Urusan Pemerintahan', ':', { content: @programKegiatan.opd.text_urusan, font_style: :bold }],
              ['Bidang Urusan', ':', { content: @programKegiatan.opd.text_bidang_urusan, font_style: :bold }],
              ['Program', ':', { content: @programKegiatan.nama_program, font_style: :bold }],
              ['Indikator', ':', @programKegiatan.indikator_program],
              ['Target', ':', "#{@programKegiatan.target_program} #{@programKegiatan.satuan_target_program}"],
              ['Kegiatan', ':', { content: @programKegiatan.nama_kegiatan, font_style: :bold }],
              ['Indikator', ':', @programKegiatan.indikator_kinerja],
              ['Target', ':', "#{@programKegiatan.target} #{@programKegiatan.satuan}"],
              ['Sub Kegiatan', ':', { content: @programKegiatan.nama_subkegiatan, font_style: :bold }],
              ['Indikator', ':', @programKegiatan.indikator_subkegiatan],
              ['Target', ':', "#{@programKegiatan.target_subkegiatan} #{@programKegiatan.satuan}"],
              ['Pagu Anggaran', ':',
               "Rp. #{number_with_delimiter(@programKegiatan.sasarans.sudah_lengkap.map(&:total_anggaran).compact.sum)}"]
            ], cell_style: { borders: [] }, width: pdf.bounds.width)
  pdf.move_down 20
  pdf.text 'Sumber Dana', style: :bold, indent_paragraphs: 5
  header_sumber_dana = [['No', 'Sasaran', 'Pemilik Sasaran', 'Pagu', 'Sumber Dana']]
  @programKegiatan.sasarans.each.with_index(1) do |sasaran_sumber_dana, no|
    header_sumber_dana << [no, sasaran_sumber_dana.sasaran_kinerja,
                           sasaran_sumber_dana.user.nama,
                           { content: "Rp. #{number_with_delimiter(sasaran_sumber_dana.total_anggaran)}" },
                           sasaran_sumber_dana.sumber_dana]
  end
  pdf.table(header_sumber_dana, cell_style: { size: 8, column_widths: { 0 => 10, 1 => 150, 2 => 50 } },
                                width: pdf.bounds.width, position: 5)
  pdf.start_new_page

  # new page
  pdf.move_down 5
  pdf.font_size 8
  # sasaran_kinerja
  @programKegiatan.sasarans.each.with_index(1) do |sasaran, nomor|
    pdf.move_down 20
    pdf.text "#{nomor}. ", size: 8
    pdf.table([
                ["Sasaran/ Rencana Kinerja", ':', sasaran.sasaran_kinerja],
                ['Indikator', ':', sasaran.indikator_kinerja],
                ['Target', ':', "#{sasaran.target} #{sasaran.satuan}"],
                ['Pagu Anggaran', ':',
                 "Rp. #{number_with_delimiter(sasaran.total_anggaran)} | Sumber Dana : #{sasaran.sumber_dana}"],
                ['Sub Kegiatan', ':',
                 "#{sasaran.program_kegiatan.kode_sub_giat} #{sasaran.program_kegiatan.nama_subkegiatan}" || '-']
              ], cell_style: { borders: [] })
    pdf.move_down 5
    # tahapan
    sasaran.tahapans.each.with_index(1) do |tahapan, index|
      pdf.move_down 10
      pdf.start_new_page if (pdf.cursor - 111).negative?
      pdf.text "Tahapan #{index}.  #{tahapan.tahapan_kerja}"
      pdf.move_down 5
      header_anggaran = [
        [{ content: 'Kode rekening', rowspan: 2 }, { content: 'Uraian', rowspan: 2 },
         { content: 'Rincian Perhitungan', colspan: 4 }, { content: 'Jumlah', rowspan: 2 }],
        %w[Koefisien Satuan Harga PPN]
      ]
      if tahapan.anggarans.exists?
        tahapan.anggarans.each do |anggaran|
          header_anggaran << [rekening_anggaran(anggaran.kode_rek), { content: anggaran.uraian, colspan: 5 },
                              { content: "Rp. #{number_with_delimiter(anggaran.jumlah)}", align: :right }]
          anggaran.perhitungans.each do |perhitungan|
            deskripsi = perhitungan.spesifikasi&.include?('Belanja Gaji') ? perhitungan.deskripsi : uraian_kode(perhitungan.deskripsi)
            header_anggaran << ['', deskripsi, perhitungan.list_koefisien, perhitungan.satuan,
                                { content: "Rp. #{number_with_delimiter(perhitungan.harga)}", align: :right },
                                { content: perhitungan.plus_pajak.to_s },
                                { content: "Rp. #{number_with_delimiter(perhitungan.total)}", align: :right }]
          end
        end
      else
        header_anggaran << ['-', '-', '-', '-', '-', '-', { content: "0", align: :right }]
      end
      pdf.table(header_anggaran, cell_style: { size: 6 }, width: pdf.bounds.width)
      pdf.move_down 5
      pdf.text "Pemilik Sasaran : #{sasaran.user.nama}"
      header_anggaran.clear
    end
  end
end
