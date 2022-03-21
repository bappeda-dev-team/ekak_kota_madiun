prawn_document do |pdf|
  pdf.font_size 16
  judul_rka = pdf.make_table([["RINCIAN BELANJA #{@programKegiatan.opd.nama_opd}"]])
  judul_rka.draw
  pdf.move_down 7
  pdf.font_size 10
  pdf.table([
              ['Urusan Pemerintahan', ':', @programKegiatan.opd.text_urusan],
              ['Bidang Urusan', ':', @programKegiatan.opd.text_bidang_urusan],
              ['Program', ':', @programKegiatan.nama_program],
              ['Indikator', ':', @programKegiatan.indikator_program],
              ['Target', ':', "#{@programKegiatan.target_program} #{@programKegiatan.satuan_target_program}"],
              ['Kegiatan', ':', @programKegiatan.nama_kegiatan],
              ['Indikator', ':', @programKegiatan.indikator_kinerja],
              ['Target', ':', "#{@programKegiatan.target} #{@programKegiatan.satuan}"],
              ['Sub Kegiatan', ':', @programKegiatan.nama_subkegiatan],
              ['Indikator', ':', @programKegiatan.indikator_subkegiatan],
              ['Target', ':', "#{@programKegiatan.target_subkegiatan} #{@programKegiatan.satuan}"],
              ['Pagu Anggaran', ':', "Rp. #{number_with_delimiter(@programKegiatan.my_pagu, delimiter: '.')}"]
            ], cell_style: { borders: [] })
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
                ['Pagu Anggaran', ':', sasaran.total_anggaran],
                ['Sub Kegiatan', ':', '5.01.01.2.01.01 Penyusunan Dokumen Perenanaan Perangkat Daerah'],
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
        header_anggaran << [rekening_anggaran(anggaran.kode_rek), { content: anggaran.uraian, colspan: 5 }, { content: "Rp. #{anggaran.jumlah}", align: :right}]
        anggaran.perhitungans.each do |perhitungan|
          header_anggaran << ['', uraian_kode(perhitungan.deskripsi), perhitungan.list_koefisien, perhitungan.satuan,
                              { content: perhitungan.harga.to_s, align: :right }, { content: anggaran.plus_pajak.to_s}, { content: "Rp. #{perhitungan.total}", align: :right }]
        end
      end
      pdf.table(header_anggaran, cell_style: { size: 6 }, width: pdf.bounds.width)
      header_anggaran.clear
    end
  end
end
