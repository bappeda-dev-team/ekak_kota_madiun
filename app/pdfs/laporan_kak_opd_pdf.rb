class LaporanKakOpdPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper

  def initialize(opd: '', tahun: '', current_page: '')
    super(page_size: "LETTER")
    @opd = opd
    @tahun = tahun
    @nama_opd = @opd.nama_opd
    @nama_kota = @opd.lembaga.nama_lembaga
    @current_page = current_page
  end

  def print
    title
    move_down 20
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

  def footer
    text "Dicetak pada #{@timestamp} via #{@current_page}", valign: :bottom,
                                                            size: 8
  end
end
