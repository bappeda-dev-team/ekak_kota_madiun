prawn_document do |pdf|
  pdf.font_size 16
  judul_rka = pdf.make_table([["RINCIAN BELANJA #{@programKegiatan.opd.nama_opd}"]])
  judul_rka.draw
  pdf.move_down 7
  pdf.font_size 10
  pdf.table([
              ['Urusan Pemerintahan', ':', '5 Unsur Penunjang urusan Pemerintahan'],
              ['Bidang Urusan', ':', '5.01 Perencanaan'],
              ['Program', ':', @programKegiatan.nama_program],
              ['Indikator', ':', 'Dummy'],
              ['Target', ':', 'Dummy'],
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
         { content: 'Rincian Perhitungan', colspan: 4}, { content: 'Jumlah', rowspan: 2 }],
        %w[Koefisien Satuan Harga PPN]
    ]
      cell_perhitungan_deskripsi = ''
      cell_perhitungan_satuan = ''
      cell_perhitungan_harga_satuan = ''
      cell_total = ''
      cell_koefisien = ''
      tabel_perhitungan = ''
      tahapan.anggarans.each do |anggaran|
        header_anggaran << [rekening_anggaran(anggaran.kode_rek), { content: anggaran.uraian, colspan: 5 }, "Rp. #{anggaran.jumlah}"]
        anggaran.perhitungans.each do |perhitungan|
          cell_perhitungan_deskripsi = pdf.make_cell(content: uraian_kode(perhitungan.deskripsi))
          cell_perhitungan_satuan = pdf.make_cell(content: perhitungan.satuan)
          cell_perhitungan_harga_satuan = pdf.make_cell(content:"Rp. #{number_with_delimiter(perhitungan.harga, delimiter: '.')}")
          cell_total = pdf.make_cell(content: "Rp. #{number_with_delimiter((perhitungan.total).to_i, delimiter: '.')}")
          header_anggaran << ['', uraian_kode(perhitungan.deskripsi), 'harus e koefisien', perhitungan.satuan,
                              perhitungan.harga, anggaran.pajak.potongan, perhitungan.total]
          # make helper to make koefisien list
        end
        pdf.table(header_anggaran, cell_style: { size: 7 })
        header_anggaran.clear
      end
    end
  end
end
