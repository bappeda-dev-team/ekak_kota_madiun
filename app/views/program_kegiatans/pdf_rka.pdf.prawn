prawn_document do |pdf|
  pdf.font_size 16
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
              ['Pagu Anggaran', ':', "Rp. #{number_with_delimiter(@programKegiatan.my_pagu, delimiter: '.')}"]
            ], cell_style: { borders: [] }, width: pdf.bounds.width)
  pdf.start_new_page

  # new page
  pdf.move_down 5
  pdf.font_size 8
  # sasaran_kinerja
  @programKegiatan.sasarans.each.with_index(1) do |sasaran, nomor|
    pdf.move_down 20
    pdf.text "#{nomor}. ", size: 8
    pdf.table([
                ['Sasaran/ Rencana Kinerja', ':', sasaran.sasaran_kinerja],
                ['Indikator', ':', sasaran.indikator_kinerja],
                ['Target', ':', "#{sasaran.target} #{sasaran.satuan}"],
                ['Pagu Anggaran', ':', "Rp. #{number_with_delimiter(sasaran.total_anggaran, delimiter: '.')}"],
                ['Sub Kegiatan', ':', '5.01.01.2.01.01 Penyusunan Dokumen Perenanaan Perangkat Daerah']
              ], cell_style: { borders: [] })
    pdf.move_down 5
    # tahapan
    sasaran.tahapans.each.with_index(1) do |tahapan, index|
      pdf.move_down 10
      pdf.text "Tahapan #{index}.  #{tahapan.tahapan_kerja}"
      pdf.move_down 5
      header_anggaran = [
        [{ content: 'Kode rekening', rowspan: 2 }, { content: 'Uraian', rowspan: 2 },
         { content: 'Rincian Perhitungan', colspan: 4 }, { content: 'Jumlah', rowspan: 2 }],
        %w[Koefisien Satuan Harga PPN]
      ]
      tahapan.anggarans.each do |anggaran|
        header_anggaran << [rekening_anggaran(anggaran.kode_rek), { content: anggaran.uraian, colspan: 5 },
                            { content: "Rp. #{number_with_delimiter(anggaran.jumlah, delimiter: '.')}", align: :right }]
        anggaran.perhitungans.each do |perhitungan|
          header_anggaran << ['', uraian_kode(perhitungan.deskripsi), perhitungan.list_koefisien, perhitungan.satuan,
                              { content: "Rp. #{number_with_delimiter(perhitungan.harga, delimiter: '.')}", align: :right },
                              { content: perhitungan.plus_pajak.to_s },
                              { content: "Rp. #{number_with_delimiter(perhitungan.total, delimiter: '.')}", align: :right }]
        end
      end
      pdf.table(header_anggaran, cell_style: { size: 6 }, width: pdf.bounds.width)
      pdf.move_down 5
      pdf.text "Pemilik Sasaran : #{sasaran.user.nama}"
      header_anggaran.clear
    end
  end
end
