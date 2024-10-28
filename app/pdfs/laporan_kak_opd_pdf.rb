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
  W_ANGGARAN = 70

  def header_tabel
    [
      { content: "NO", width: W_NO, align: :center },
      { content: "PEMILIK RENCANA", align: :center, width: W_PEMILIK_RENCANA },
      { content: "RENCANA KINERJA", align: :center, width: W_RENCANA_KINERJA },
      { content: "INDIKATOR", align: :center, width: W_INDIKATOR },
      { content: "TARGET", align: :center, width: W_TARGET },
      { content: "SATUAN", align: :center, width: W_SATUAN }
    ]
  end

  def tabel_kak
    tabel = [header_tabel]
    @sasarans.each.with_index(1) do |ss, i|
      tabel << [
        { content: i.to_s, rowspan: ss.indikator_sasarans.size },
        { content: ss.nama_pemilik, rowspan: ss.indikator_sasarans.size },
        { content: ss.sasaran_kinerja, rowspan: ss.indikator_sasarans.size },
        { content: ss.indikator_sasarans.first.indikator_kinerja },
        { content: ss.indikator_sasarans.first.target },
        { content: ss.indikator_sasarans.first.satuan }
      ]

      ss.indikator_sasarans.drop(1).each do |ind|
        tabel << [
          { content: ind.indikator_kinerja },
          { content: ind.target },
          { content: ind.satuan }
        ]
      end
    end
    table(tabel, header: true, width: bounds.width) do
      cells.style(size: 8)
    end
  end
end
