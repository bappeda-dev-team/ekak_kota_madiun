class LaporanKakPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper
  def initialize(opd: '', tahun: '', program_kegiatan: '', sasarans: '')
    super(page_size: "LETTER")
    @opd = opd
    @tahun = tahun
    @nama_opd = @opd.nama_opd
    @kota = @opd.lembaga.nama_lembaga
    @program_kegiatan = program_kegiatan
    @sasarans = sasarans
    @pagu = sasarans.map(&:total_anggaran).compact.sum
    indikators_pks = IndikatorQueries.new(tahun: @tahun, opd: @program_kegiatan.opd,
                                          program_kegiatan: @program_kegiatan)
    @indikator_prg = indikators_pks.indikator_program
    @indikator_keg = indikators_pks.indikator_kegiatan
    @indikator_sub = indikators_pks.indikator_subkegiatan
    # @indikator_prg = program_kegiatan&.indikator_program_tahun(tahun, kode_opd)
    # @indikator_keg = program_kegiatan&.indikator_kegiatan_tahun(tahun, kode_opd)
    # @indikator_sub = program_kegiatan&.indikator_subkegiatan_tahun(tahun, kode_opd)

    # table & cell style
    align_cell = :justify
    @cell_style_common = { size: 8, border_width: 0, align: align_cell }
    @common_cell_width = 388
    @common_widths = { 0 => 17, 1 => 17, 2 => 88, 3 => 12 }
    @common_table_cell_style = { size: 8, border_width: 0, overflow: :expand, align: :justify }
    @common_table_width = bounds.width
    print
  end

  def print
    title
    move_down 20
    tabel_informasi_subkegiatan
    move_down 30
    kak_content
    move_down 20
    ttd
  end

  def title
    text 'KERANGKA ACUAN KERJA/ TERM OF REFERENCE', size: 16, align: :center
    text "KELUARAN (OUTPUT) KEGIATAN TA #{@tahun}", align: :center
  end

  def ttd
    start_new_page if (cursor - 111).negative?
    bounding_box([bounds.width - 300, cursor - 10], width: bounds.width - 200) do
      text "Madiun,    #{I18n.l Date.today, format: '  %B %Y'}", size: 8, align: :center
      move_down 5
      text "<strong>#{@opd.jabatan_kepala_tanpa_opd}</strong>", size: 8, align: :center,
                                                                inline_format: true
      text "<strong>#{@opd.nama_opd}</strong>", size: 8, align: :center, inline_format: true
      move_down 50
      text "<u>#{@opd.nama_kepala || '!!belum disetting'}</u>", size: 8, align: :center,
                                                                inline_format: true
      text @opd.pangkat_kepala || '!! belum disetting', size: 8, align: :center
      text "NIP. #{@opd.nip_kepala_fix_plt || '!! belum disetting'}", size: 8, align: :center
    end
  end

  def tabel_content(content_tabel)
    table(content_tabel, column_widths: { 0 => 150, 1 => 12 }, cell_style: { size: 8, border_width: 0 },
                         width: bounds.width) do
      cells.style(size: 8)
    end
  end

  def tahun_bener
    @tahun.include?('perubahan') ? @tahun[/[^_]\d*/, 0] : @tahun
  end

  def tabel_informasi_subkegiatan
    informasi_subkegiatan = [
      ['Perangkat Daerah', ':', { content: @nama_opd, font_style: :bold }],
      ['Program', ':', { content: @program_kegiatan.nama_program, font_style: :bold }],
      ['Indikator Kinerja Program', ':', @indikator_prg&.dig(:indikator)],
      ['Target', ':', @indikator_prg&.dig(:target)],
      ['Satuan', ':', @indikator_prg&.dig(:satuan)],
      ['', '', ''],
      ['Kegiatan', ':', { content: @program_kegiatan.nama_kegiatan, font_style: :bold }],
      ['Indikator Kinerja Kegiatan (Output)', ':', @indikator_keg&.dig(:indikator)],
      ['Target', ':', @indikator_keg&.dig(:target)],
      ['Satuan', ':', @indikator_keg&.dig(:satuan)],
      ['', '', ''],
      ['Sub Kegiatan', ':', { content: @program_kegiatan.nama_subkegiatan, font_style: :bold }],
      ['Indikator Kinerja Sub Kegiatan (Output)', ':', @indikator_sub&.dig(:indikator)],
      ['Target', ':', @indikator_sub&.dig(:target)],
      ['Satuan', ':', @indikator_sub&.dig(:satuan)],
      ['Jumlah Sasaran/Rencana Kinerja', ':', @sasarans.size],
      ['Pagu Anggaran', ':',
       "Rp. #{number_with_delimiter(@pagu)}"]
    ]
    tabel_content informasi_subkegiatan
  end

  def kak_content
    @sasarans.each.with_index(1) do |sasaran, index|
      sasaran_kinerja(sasaran, index)
      dasar_hukum(sasaran)
      gambaran_umum(sasaran)
      penerima_manfaat(sasaran)
      data_terpilah(sasaran)
      permasalahan(sasaran)
      resiko(sasaran)
      rencana_aksi(sasaran)
      usulan(sasaran)
      if sasaran.hasil_inovasi_sasaran == 'Inovasi'
        inovasi_sasaran(sasaran)
      else
        move_down 30
        start_new_page if (cursor - 50).negative?
      end
    end
  end

  def sasaran_kinerja(sasaran, index)
    sasaran_arr = [[sasaran.sasaran_kinerja]]
    indikator_arr = []
    satuan_arr = []
    target_arr = []
    if sasaran.indikator_sasarans.any?
      sasaran.indikator_sasarans.each do |indikator|
        indikator_arr << [indikator.indikator_kinerja]
        satuan_arr << [indikator.satuan]
        target_arr << [indikator.target]
      end
    else
      indikator_arr = [['-']]
      satuan_arr = [['-']]
      target_arr = [['-']]
    end
    sasaran_cell = make_table(sasaran_arr, cell_style: @cell_style_common, width: @common_cell_width)
    indikator_cell = make_table(indikator_arr, cell_style: @cell_style_common, width: @common_cell_width)
    satuan_cell = make_table(satuan_arr, cell_style: @cell_style_common, width: @common_cell_width)
    target_cell = make_table(target_arr, cell_style: @cell_style_common, width: @common_cell_width)
    sasaran_judul = [
      [{ content: "#{index}.", font_style: :bold }, { content: "Sasaran/Rencana Kinerja", font_style: :bold }, ':',
       sasaran_cell],
      ['', 'Indikator Kinerja (Output)', ':', indikator_cell],
      ['', 'Target', ':', target_cell],
      ['', 'Satuan', ':', satuan_cell]
    ]
    tabel_sasaran = make_table(sasaran_judul, column_widths: { 0 => 25, 2 => 13, 4 => 100 },
                                              cell_style: @common_table_cell_style, width: @common_table_width)
    tabel_sasaran.draw
  end

  # rubocop: disable Metrics
  def dasar_hukum(sasaran)
    dasar_hukum_arr = []
    if sasaran.dasar_hukums.any?
      das_hus = sasaran.dasar_hukums.flat_map(&:split_dasar_hukum)
      das_hus.each.with_index(1) do |das_hu, no|
        dasar_hukum_arr << ["#{no}. #{das_hu}"]
      end
    else
      dasar_hukum_arr = [['-']]
    end
    dasar_hukum_cell = make_table(dasar_hukum_arr, cell_style: @cell_style_common, width: @common_cell_width)
    dasar_hukum = [
      ['', 'a.', 'Dasar Hukum', ':', dasar_hukum_cell]
    ]
    tabel_dasar_hukum = make_table(dasar_hukum, column_widths: @common_widths,
                                                cell_style: @common_table_cell_style, width: @common_table_width)
    tabel_dasar_hukum.draw
  end

  def gambaran_umum(sasaran)
    latar_belakang_arr = []
    if sasaran.latar_belakangs.any?
      sasaran.latar_belakangs.each do |latar_belakang|
        latar_belakang_arr << [latar_belakang.gambaran_umum_fix_encode]
      end
    else
      latar_belakang_arr = [['-']]
    end
    latar_belakang_cell = make_table(latar_belakang_arr, cell_style: @cell_style_common, width: @common_cell_width)
    gambaran_umum = [
      ['', 'b.', 'Gambaran Umum', ':', latar_belakang_cell]
    ]
    tabel_gambaran_umum = make_table(gambaran_umum, column_widths: @common_widths,
                                                    cell_style: @common_table_cell_style, width: @common_table_width)
    tabel_gambaran_umum.draw
  end

  def penerima_manfaat(sasaran)
    penerima_manfaat = [
      ['', 'c.', 'Jenis Layanan', ':', { content: sasaran.jenis_layanan || '-' }],
      ['', '', 'Model Layanan', ':', { content: sasaran.rincian&.model_layanan || '-' }],
      ['', '', 'Penjelasan', ':', { content: sasaran.rincian&.jalur_layanan || '-' }],
      ['', '', 'Penerima Manfaat', ':', { content: sasaran.penerima_manfaat || '-' }]
    ]
    tabel_penerima_manfaat = make_table(penerima_manfaat, column_widths: @common_widths,
                                                          cell_style: @common_table_cell_style, width: @common_table_width)
    tabel_penerima_manfaat.draw
  end

  def data_terpilah(sasaran)
    data_terpilah = [
      ['', 'd.', 'Data Terpilah', ':', { content: sasaran.rincian&.data_terpilah || '-' }]
    ]
    tabel_data_terpilah = make_table(data_terpilah, column_widths: @common_widths,
                                                    cell_style: @common_table_cell_style, width: @common_table_width)
    tabel_data_terpilah.draw
  end

  def permasalahan(sasaran)
    permasalahan_arr = []
    if sasaran.permasalahans.any?
      sasaran.permasalahans.each do |permasalahan|
        permasalahan_arr << [permasalahan.permasalahan]
        permasalahan_arr << ['Penyebab', '']
        permasalahan_arr << ['1. Internal']
        permasalahan_arr << [permasalahan.penyebab_internal || '-']
        permasalahan_arr << ['2. External']
        permasalahan_arr << [permasalahan.penyebab_external || '-']
      end
    else
      permasalahan_arr = [
        ['-', ''],
        ['Penyebab', ''],
        ['1. Internal'],
        ['-', ''],
        ['2. External'],
        ['-', '']
      ]
    end
    permasalahan_cell = make_table(permasalahan_arr, cell_style: @cell_style_common, width: @common_cell_width)
    permasalahan = [
      ['', 'e.', 'Permasalahan', ':', permasalahan_cell]
    ]
    tabel_permasalahan = make_table(permasalahan, column_widths: @common_widths,
                                                  cell_style: @common_table_cell_style, width: @common_table_width)
    tabel_permasalahan.draw
  end

  def resiko(sasaran)
    resiko_sasaran = [
      ['', 'f.', 'Resiko', ':', { content: sasaran.rincian&.resiko || '-', inline_format: true }]
    ]
    tabel_resiko = make_table(resiko_sasaran, column_widths: @common_widths,
                                              cell_style: @common_table_cell_style, width: @common_table_width)
    tabel_resiko.draw
  end

  def rencana_aksi(sasaran)
    rencana_aksi_judul = [
      ['', 'g.', { content: 'Rencana Aksi dan Anggaran' }]
    ]
    tabel_rencana_aksi_judul = make_table(rencana_aksi_judul, column_widths: { 0 => 17, 1 => 17 },
                                                              cell_style: @common_table_cell_style)
    tabel_rencana_aksi_judul.draw
    move_down 10
    data_rencana_aksi = [[{ content: 'No', rowspan: 2 },
                          { content: 'Tahapan Kerja', rowspan: 2 },
                          { content: 'Target pada bulan', colspan: 12 },
                          { content: 'Jumlah', rowspan: 2 },
                          { content: 'Pagu Anggaran', rowspan: 2 },
                          { content: 'Keterangan', rowspan: 2 }],
                         %w[1 2 3 4 5 6 7 8 9 10 11 12]]

    sasaran.tahapans.where.not(tahapans: { id_rencana: nil }).each.with_index(1) do |tahapan, i|
      data_rencana_aksi << [i, tahapan.tahapan_kerja,
                            tahapan.find_target_bulan(1),
                            tahapan.find_target_bulan(2),
                            tahapan.find_target_bulan(3),
                            tahapan.find_target_bulan(4),
                            tahapan.find_target_bulan(5),
                            tahapan.find_target_bulan(6),
                            tahapan.find_target_bulan(7),
                            tahapan.find_target_bulan(8),
                            tahapan.find_target_bulan(9),
                            tahapan.find_target_bulan(10),
                            tahapan.find_target_bulan(11),
                            tahapan.find_target_bulan(12),
                            tahapan.target_total,
                            "Rp. #{number_with_delimiter(tahapan.anggaran_tahapan)}",
                            tahapan.keterangan]
    end
    data_rencana_aksi << [{ content: "Total sasaran ini adalah #{sasaran.waktu_total} bulan", colspan: 14 },
                          sasaran.jumlah_target, "Rp. #{number_with_delimiter(sasaran.total_anggaran)}", '']

    tabel_renaksi = make_table(data_rencana_aksi, column_widths: { 0 => 18, 1 => 130, 14 => 30 },
                                                  cell_style: { size: 6, align: :left }, width: bounds.width)
    start_new_page if (cursor - tabel_renaksi.height).negative?
    tabel_renaksi.draw
    data_rencana_aksi.clear
  end

  def usulan(sasaran)
    move_down 10
    tabel_usulan = [
      ['', 'h.', 'Usulan yang terakomodir']
    ]
    table(tabel_usulan, column_widths: { 0 => 18, 1 => 17 }, cell_style: { size: 8, border_width: 0 })
    data_usulan_terakomodir = [['No', 'Jenis Usulan', 'Usulan', 'Permasalahan/ Uraian', 'Keterangan']]
    count = 0
    sasaran.my_usulan.each do |u|
      count += 1
      keterangan = u.try(:alamat) || u.try(:peraturan_terkait) || u.try(:manfaat)
      tipe = u.class.try(:type) || u.class.name.to_s
      data_usulan_terakomodir << [count, tipe, u&.usulan, u&.uraian, keterangan&.force_encoding('utf-8')]
    end
    move_down 10
    tabel_usulan_terakomodir = make_table(data_usulan_terakomodir,
                                          column_widths: { 0 => 18, 1 => 50, 2 => 100 },
                                          cell_style: { size: 6, align: :center }, width: bounds.width, header: true)
    tabel_usulan_terakomodir.draw
  end

  def inovasi_sasaran(sasaran)
    move_down 10
    inovasi_judul = [
      ['', 'i.', 'Inovasi dan nilai kebaruan']
    ]
    table(inovasi_judul, column_widths: { 0 => 18, 1 => 17 }, cell_style: { size: 8, border_width: 0 })

    tabel_inovasi = [
      ['', '', 'i.1', 'Judul inovasi', '', ':', sasaran.inovasi_sasaran],
      ['', '', 'i.2', 'Jenis inovasi', '', ':', sasaran.jenis_inovasi_sasaran],
      ['', '', 'i.3', 'Nilai kebaruan', '', ':', { content: sasaran.gambaran_nilai_kebaruan_sasaran, align: :justify }]
    ]
    table(tabel_inovasi, column_widths: { 0 => 18, 1 => 12, 2 => 18, 4 => 12 },
                         cell_style: { size: 8, border_width: 0, inline_format: true })

    move_down 30
    start_new_page if (cursor - 50).negative?
  end

  private

  def tabel_maker(data)
    make_table(data) do
      cells.style(size: 8)
    end
  end
end
