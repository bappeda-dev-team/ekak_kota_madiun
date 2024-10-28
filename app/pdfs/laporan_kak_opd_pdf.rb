class LaporanKakOpdPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper

  def initialize(opd: '', tahun: '', current_page: '', sasarans: [])
    super(page_size: "LETTER")
    @opd = opd
    @tahun = tahun
    @nama_opd = @opd.nama_opd
    @nama_kota = @opd.lembaga.nama_lembaga
    @current_page = current_page
    @sasarans = sasarans
  end

  def print
    title
    move_down 20
    tabel_kak
    move_down 20
    ttd
    footer
  end

  def title
    @judul = 'LAPORAN KAK'
    text @judul.upcase, align: :center
    move_down 3
    text @nama_opd.upcase, align: :center unless @kota == 'kota'
    text @nama_kota.upcase, align: :center
    move_down 3
    text "TAHUN #{@tahun}", align: :center
  end

  # rubocop: disable Metrics
  def ttd
    start_new_page if (cursor - 111).negative?
    bounding_box([bounds.width - 280, cursor - 10], width: bounds.width - 200) do
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

  def footer
    text "Dicetak pada #{@timestamp} via #{@current_page}", valign: :bottom,
                                                            size: 8
  end

  W_NO = 25
  W_PEMILIK_RENCANA = 70
  W_RENCANA_KINERJA = 80
  W_INDIKATOR = 80
  W_TARGET = 50
  W_SATUAN = 50
  W_ANGGARAN = 90

  def header_tabel
    [
      { content: "NO", width: W_NO, align: :center },
      { content: "PEMILIK RENCANA", align: :center, width: W_PEMILIK_RENCANA },
      { content: "RENCANA KINERJA", align: :center, width: W_RENCANA_KINERJA },
      { content: "INDIKATOR", align: :center, width: W_INDIKATOR },
      { content: "TARGET", align: :center, width: W_TARGET },
      { content: "SATUAN", align: :center, width: W_SATUAN },
      { content: "ANGGARAN", align: :center, width: W_ANGGARAN }
    ]
  end

  def tabel_kak
    tabel = [header_tabel]
    @sasarans.each.with_index(1) do |(subk, sasarans), i|
      tahun_n = tahun_fix(@tahun)
      indikator = subk&.indikator_subkegiatan_tahun(tahun_n, @kode_opd)
      pagu = sasarans.map(&:total_anggaran).compact.sum
      subkegiatan = "Subkegiatan: #{subk&.nama_subkegiatan || 'belum terisi'}"
      bg_color = subkegiatan == 'Subkegiatan: belum terisi' ? "F3F7EC" : "FFFFFF"
      tabel << [
        { content: i.to_s, background_color: bg_color },
        { content: subkegiatan, colspan: 2, background_color: bg_color },
        { content:  indikator&.dig(:indikator), background_color: bg_color },
        { content:  indikator&.dig(:target), background_color: bg_color },
        { content:  indikator&.dig(:satuan), background_color: bg_color },
        { content:  "Rp. #{number_with_delimiter(pagu)}", background_color: bg_color }
      ]
      sasarans.each.with_index(1) do |ss, index|
        tabel << [
          { content: "#{i}.#{index}", rowspan: ss.indikator_sasarans.size, background_color: bg_color },
          { content: ss.nama_pemilik, rowspan: ss.indikator_sasarans.size, background_color: bg_color },
          { content: ss.sasaran_kinerja, rowspan: ss.indikator_sasarans.size, background_color: bg_color },
          { content: ss.indikator_sasarans.first.indikator_kinerja, background_color: bg_color },
          { content: ss.indikator_sasarans.first.target, background_color: bg_color },
          { content: ss.indikator_sasarans.first.satuan, background_color: bg_color },
          { content: "Rp. #{number_with_delimiter(ss.total_anggaran)}", rowspan: ss.indikator_sasarans.size,
            background_color: bg_color }
        ]

        ss.indikator_sasarans.drop(1).each do |ind|
          tabel << [
            { content: ind.indikator_kinerja, background_color: bg_color },
            { content: ind.target, background_color: bg_color },
            { content: ind.satuan, background_color: bg_color }
          ]
        end
      end
    end
    pagu_total = @sasarans.values.flatten.map(&:total_anggaran).compact.sum
    tabel << [
      { content: "Total", colspan: 6 },
      { content: "Rp. #{number_with_delimiter(pagu_total)}" }
    ]
    table(tabel, header: true, width: bounds.width) do
      # sub_kosong.background_color = "F3F7EC"
      cells.style(size: 8)
    end
  end

  private

  def tahun_fix(tahun)
    tahun_string = tahun.to_s
    tahun_string.match(/murni|perubahan/) ? tahun_string[/[^_]\d*/, 0] : tahun
  end
end
