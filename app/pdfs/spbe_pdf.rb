class SpbePdf < Prawn::Document
  include ActionView::Helpers::NumberHelper

  def initialize(opd: '', tahun: '', programs: '', spbes: '', tanggal_cetak: '', domain: '', kota: '')
    super(page_layout: :landscape, page_size: "LETTER")
    @opd = opd
    @tahun = tahun
    if @opd.present?
      @nama_opd = @opd.nama_opd
      @nama_kota = @opd.lembaga.nama_lembaga
    else
      @nama_opd = ''
      @nama_kota = 'KOTA MADIUN'
    end
    @programs = programs
    @spbes = spbes
    @domain = domain.blank? || domain == 'all' ? '' : domain
    @judul = "Tabel Peta Rencana SPBE"
    @tanggal_cetak = tanggal_cetak
    @timestamp = Time.now
    @kota = kota
  end

  def print
    title
    move_down 20
    tabel_spbe
    move_down 20
    return if @kota == 'kota'

    ttd
  end

  def title
    text @judul.upcase, align: :center
    text @domain.upcase, align: :center
    move_down 3
    text @nama_opd.upcase, align: :center unless @kota == 'kota'
    text @nama_kota.upcase, align: :center
    move_down 3
    text "TAHUN #{@tahun}", align: :center
  end

  # rubocop: disable Metrics
  def ttd
    start_new_page if (cursor - 111).negative?
    bounding_box([bounds.width - 370, cursor - 5], width: bounds.width - 200) do
      text "Madiun, #{@tanggal_cetak}", size: 8, align: :center
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

  W_NAMA_OPD = 70
  W_PROGRAM = 70
  W_TACTICAL = 70
  W_LAYANAN = 80
  W_APLIKASI = 100
  W_KEBUTUHAN = 100
  W_DOMAIN = 70
  W_TAHUN = 50
  W_KET = 70

  def header_tabel
    [
      { content: "No", width: 20, align: :center },
      { content: "Nama OPD", align: :center, width: W_NAMA_OPD },
      { content: "Nama Program pada Rencana Kerja", align: :center, width: W_PROGRAM },
      { content: "Strategi Tactical", align: :center, width: W_TACTICAL },
      { content: "Jenis Layanan pada Standar Pelayanan", align: :center, width: W_LAYANAN },
      { content: "Nama Aplikasi", align: :center, width: W_APLIKASI },
      { content: "Detail Kebutuhan", align: :center, width: W_KEBUTUHAN },
      { content: 'Domain', align: :center, width: W_DOMAIN },
      { content: "Tahun Pelaksanaan", align: :center, width: W_TAHUN },
      { content: "Keterangan", align: :center, width: W_KET }
    ]
  end

  def tabel_spbe
    tabel = [header_tabel]
    spbe_tabel = @spbes.flat_map do |spbe|
      spbe.spbe_rincians.map do |spbe_rincian|
        [
          { content: spbe.opd_pemohon },
          { content: spbe.nama_program },
          { content: spbe.strategi_tactical },
          { content: spbe.jenis_pelayanan },
          { content: spbe.nama_aplikasi },
          { content: spbe_rincian&.detail_kebutuhan },
          { content: spbe_rincian.domain_spbe },
          { content: spbe_rincian.tahun_pemohon_spbe },
          { content: spbe_rincian&.keterangan }
        ]
      end
    end

    sorted_tabel = spbe_tabel.sort_by do |sub_array|
      sub_array[0][:content]
    end

    nomor_tabel = sorted_tabel.each.with_index(1) do |cont, i|
      cont.unshift({ content: i.to_s })
    end

    cetak = tabel + nomor_tabel

    table(cetak, header: true) do
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
