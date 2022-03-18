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
              ['Indikator', ':', ''],
              ['Target', ':', ''],
              ['Kegiatan', ':', @programKegiatan.nama_kegiatan],
              ['Indikator', ':', @programKegiatan.indikator_kinerja],
              ['Target', ':', @programKegiatan.target],
              ['Sub Kegiatan', ':', @programKegiatan.nama_subkegiatan],
              ['Indikator', ':', @programKegiatan.indikator_subkegiatan],
              ['Target', ':', @programKegiatan.target_subkegiatan],
              ['Pagu Anggaran', ':', @programKegiatan.my_pagu]
            ], cell_style: { borders: [] })
  pdf.start_new_page

  # new page
  pdf.move_down 5
  pdf.font_size 8
  # sasaran_kinerja
  @programKegiatan.sasarans.each.with_index(1) do |sasaran, nomor|
    pdf.text nomor.to_s, size: 10
    pdf.table([
                ['Sasaran/ Rencana Kinerja', ':', sasaran.sasaran_kinerja],
                ['Indikator', ':', sasaran.indikator_kinerja],
                ['Target', ':', sasaran.target],
                ['Pagu Anggaran', ':', sasaran.total_anggaran],
                ['Sub Kegiatan', ':', '5.01.01.2.01.01 Penyusunan Dokumen Perenanaan Perangkat Daerah'],
              ], cell_style: { borders: [] })
    # tahapan
    sasaran.tahapans.each.with_index(1) do |tahapan, index|
      pdf.text "Tahapan #{index}.  #{tahapan.tahapan_kerja}", size: 10
      tahapan.anggarans.each do |anggaran|
        pdf.table([
                    [{ content: "Kode rekening", rowspan: 2 }, { content: "Uraian", rowspan: 2 }, { content: 'Rincian Perhitungan', colspan: 4}, {content: 'Jumlah', rowspan: 2}],
                    %w[Koefisien Satuan Harga PPN],
                    [anggaran.kode_rek, { content: anggaran.uraian, colspan: 5 }, "Rp. #{anggaran.jumlah}"]
                  ])
      end
    end
  end
end
