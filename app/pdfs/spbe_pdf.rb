class SpbePdf < Prawn::Document
  include ActionView::Helpers::NumberHelper

  def initialize(opd: '', tahun: '', programs: '', spbes: '', current_page: '', domain: '')
    super(page_layout: :landscape, page_size: "LETTER")
    @opd = opd
    @tahun = tahun
    @nama_opd = @opd.nama_opd
    @kota = @opd.lembaga.nama_lembaga
    @programs = programs
    @spbes = spbes
    @domain = domain
    @judul = "Tabel Peta Rencana Usulan #{@domain} SPBE"
    @current_page = current_page
    @timestamp = Time.now
    print
  end

  def print
    title
    move_down 20
    tabel_spbe
    move_down 20
    ttd
    footer
  end

  def title
    text @judul.upcase, align: :center
    move_down 3
    text @nama_opd.upcase, align: :center
    text @kota.upcase, align: :center
    move_down 3
    text "TAHUN #{@tahun}", align: :center
  end

  def ttd
    start_new_page if (cursor - 111).negative?
    bounding_box([bounds.width - 370, cursor - 5], width: bounds.width - 200) do
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

  def header_tabel
    [
      { content: "No", width: 20, align: :center },
      { content: "Nama OPD", align: :center },
      { content: "Nama Program pada Rencana Kerja", align: :center },
      { content: "Jenis Layanan pada Standar Pelayanan", align: :center },
      { content: "Nama Aplikasi", align: :center },
      { content: "Detail Kebutuhan", align: :center },
      { content: 'Domain', align: :center },
      { content: "Tahun Pelaksanaan", align: :center },
      { content: "Keterangan", align: :center }
    ]
  end

  def tabel_spbe
    tabel = [header_tabel]
    @spbes.each.with_index(1) do |(program, spbes), i|
      spbes.map do |spbe|
        spbe.spbe_rincians.map do |spbe_rincian|
          tabel << [
            { content: i.to_s, valign: :top },
            { content: program.opd.nama_opd },
            { content: program.nama_program },
            { content: spbe.jenis_pelayanan },
            { content: spbe.nama_aplikasi },
            { content: spbe_rincian&.detail_kebutuhan },
            { content: spbe_rincian.domain_spbe },
            { content: spbe_rincian.tahun_spbe },
            { content: spbe_rincian&.keterangan }
          ]
        end
      end
    end
    table(tabel, header: true) do
      cells.style(size: 8)
    end
  end

  private

  def tabel_maker(data)
    make_table(data) do
      cells.style(size: 8)
    end
  end
end
