prawn_document(filename: @filename) do |pdf|
  pdf.text "DAFTAR SUB KEGIATAN #{@jenis_asli}", align: :center
  pdf.text "KOTA MADIUN TAHUN #{@tahun}", align: :center
  pdf.text "PERANGKAT DAERAH #{@nama_opd}", align: :center

  pdf.move_down 20
  header_tabel_usulan = [
    [{ content: 'No' }, { content: 'Usulan', align: :center }, { content: 'Sub Kegiatan' },
     { content: 'Pagu Anggaran' }, { content: 'Lokasi' }, { content: 'Keterangan' }]
  ]
  @program_kegiatans.each.with_index(1) do |pk, i|
    usulan_arr = []
    lokasi_arr = []
    keterangan_arr = []
    pk.usulans.where(usulanable_type: @jenis).each do |us|
      keterangan = us.usulanable.try(:alamat) || us.usulanable.try(:peraturan_terkait) || us.usulanable.try(:manfaat)
      usulan_arr << [{ content: us.usulanable.usulan, size: 6, width: 100 }]
      lokasi_arr << [{content: us.usulanable.uraian, size: 6, width: 100}]
    end
    header_tabel_usulan << [{ content: i.to_s, width: 18, align: :center, valign: :center, rowspan: pk.usulans.where(usulanable_type: @type).count  },
                            usulan_arr, { content: pk.nama_subkegiatan, width: 200, valign: :center, rowspan: pk.usulans.where(usulanable_type: @type).count },
                            { content: "Rp. #{pk.my_pagu}", valign: :center, rowspan: pk.usulans.where(usulanable_type: @type).count  },
                            lokasi_arr, '-']
  end

  pdf.table(header_tabel_usulan, cell_style: { size: 6 }, width: pdf.bounds.width)
end
