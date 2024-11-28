class InovasiAsnPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper
  def initialize(tim_kerja: {}, opd: '', tahun: '', sasaran: '', strategi_atasan: '', tanggal_cetak: '')
    super(page_size: "LETTER")
    @opd = opd
    @tahun = tahun
    @nama_opd = @opd.nama_opd
    @tim_kerja = tim_kerja
    @sasaran = sasaran
    @nama_tim = tim_kerja[:nama_tim]
    @strategi_atasan = strategi_atasan
    @tanggal_cetak = tanggal_cetak
    # penting memanggil method ini di init
    # method ini yang akan "menggambar" pdf
    print
  end

  # susun content pdf disini
  def print
    title
    move_down 20
    tabel_dasar_hukum
    move_down 20
    susunan_tim_kerja
    move_down 20
    inovator
    move_down 20
    rincian_tugas
    move_down 20
    gambaran_nilai_kebaruan
    move_down 20
    jenis_standar_pelayanan
    move_down 20
    tujuan_inovasi
    move_down 30
    ttd
  end

  def title
    text "Tim Kerja : #{@nama_tim}", size: 10, font_style: :bold
  end

  def tabel_dasar_hukum
    text 'Dasar Hukum', size: 10, font_style: :bold
    move_down 5

    data_dasar_hukum = if @tim_kerja[:dasar_hukum].any?
                         @tim_kerja[:dasar_hukum].map do |dasar_hukum|
                           [dasar_hukum[1].force_encoding('utf-8')]
                         end
                       else
                         [['-']]
                       end
    table(data_dasar_hukum, width: bounds.width) do
      cells.style(size: 8)
    end
  end

  LEBAR_KOLOM_ROLE = 100 # fixed width to set maximize child table cell width
  def susunan_tim_kerja
    text 'Susunan Tim Kerja', size: 10, font_style: :bold
    move_down 5

    #  [role | pelaksana]
    #  [    |  pelaksana]
    susunan_tim = @tim_kerja[:susunan_tim].map do |role, susunans|
      [role[:role], tabel_pelaksana(susunans)]
    end
    table(susunan_tim, column_widths: { 0 => LEBAR_KOLOM_ROLE }) do
      cells.style(size: 8)
    end
  end

  def inovator
    text 'Inovator', size: 10, font_style: :bold
    move_down 5

    # inovator
    inovator = @tim_kerja[:susunan_tim].select do |_, susunans|
      susunans.any? { |ss| ss[:is_inovator] }
    end.flatten
    nama_inovator = [
      [inovator.last[:pelaksana]]
    ]

    table(nama_inovator, width: bounds.width) do
      cells.style(size: 8)
    end
  end

  def rincian_tugas
    text 'Rincian Tugas', size: 10, font_style: :bold
    move_down 5

    rincian_tugas = if @tim_kerja[:rincian_tugas].any?
                      @tim_kerja[:rincian_tugas].map do |tugas|
                        [tugas[1]]
                      end
                    else
                      [['-']]
                    end
    table(rincian_tugas, width: bounds.width) do
      cells.style(size: 8)
    end
  end

  def gambaran_nilai_kebaruan
    text 'Gambaran Nilai Kebaruan Inovasi', size: 10, font_style: :bold
    move_down 5

    nilai_kebaruan = [[@sasaran.gambaran_nilai_kebaruan]]
    table(nilai_kebaruan, width: bounds.width) do
      cells.style(size: 8)
    end
  end

  def jenis_standar_pelayanan
    text 'Jenis Standar Pelayanan', size: 10, font_style: :bold
    move_down 5

    standar_pelayanan = [
      ['Jenis Layanan', 'Model Layanan', 'Penjelasan Online (alat yang digunakan)'],
      [@sasaran.jenis_layanan || '-',
       @sasaran.rincian&.model_layanan || '-',
       @sasaran.rincian&.jalur_layanan || '-']
    ]
    table(standar_pelayanan, width: bounds.width) do
      cells.style(size: 8)
    end
  end

  def tujuan_inovasi
    text 'Tujuan Inovasi', size: 10, font_style: :bold
    move_down 5

    tujuan = [
      [@strategi_atasan.strategi]
    ]
    table(tujuan, width: bounds.width) do
      cells.style(size: 8)
    end
  end

  # rubocop: disable Metrics
  def ttd
    start_new_page if (cursor - 111).negative?
    bounding_box([bounds.width - 300, cursor - 10], width: bounds.width - 200) do
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

  private

  def tabel_pelaksana(susunans)
    # pelaksana with sasaran_terisi => true
    susunan_pelaksana = susunans.map do |susunan|
      [susunan[:pelaksana]]
    end

    # this is needed for set each cell max width to fill the empty space and set font size
    make_table(susunan_pelaksana, width: bounds.width - LEBAR_KOLOM_ROLE) do
      cells.style(size: 8)
    end
  end

  def tahun_bener
    @tahun.include?('perubahan') ? @tahun[/[^_]\d*/, 0] : @tahun
  end
end
