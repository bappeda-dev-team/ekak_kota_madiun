class TimKerjaPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper
  def initialize(tim_kerja: {}, opd: '', tahun: '')
    super(page_size: "LETTER")
    @opd = opd
    @tahun = tahun
    @nama_opd = @opd.nama_opd
    @tim_kerja = tim_kerja

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
    rincian_tugas
    move_down 30
    ttd
  end

  def title
    text "Tim Kerja : #{@tim_kerja[:nama_tim]}", size: 10, font_style: :bold
  end

  def tabel_dasar_hukum
    text 'Dasar Hukum', size: 10, font_style: :bold
    move_down 5

    data_dasar_hukum = @tim_kerja[:dasar_hukum].map do |dasar_hukum|
      [dasar_hukum[1].force_encoding('utf-8')]
    end
    table(data_dasar_hukum, width: bounds.width) do
      cells.style(size: 8)
    end
  end

  def susunan_tim_kerja
    text 'Susunan Tim Kerja', size: 10, font_style: :bold
    move_down 5

    lebar_kolom_role = 100
    susunan_tim = @tim_kerja[:susunan_tim].map do |role, susunans|
      susunan_pelaksana = susunans.map do |susunan|
        if susunan[:sasaran_terisi]
          [susunan[:pelaksana]]
        else
          ['']
        end
      end
      if susunans.all? { |ss| ss[:sasaran_terisi] }
        tabel_pelaksana = make_table(susunan_pelaksana, width: bounds.width - lebar_kolom_role) do
          cells.style(size: 8)
        end
        [role[:role], tabel_pelaksana]
      else
        []
      end
    end
    table(susunan_tim, column_widths: { 0 => lebar_kolom_role }) do
      cells.style(size: 8)
    end
  end

  def rincian_tugas
    text 'RINCIAN TUGAS', size: 10, font_style: :bold
    move_down 5

    rincian_tugas = @tim_kerja[:rincian_tugas].map do |tugas|
      [tugas[1]]
    end
    table(rincian_tugas, width: bounds.width) do
      cells.style(size: 8)
    end
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

  private

  def tahun_bener
    @tahun.include?('perubahan') ? @tahun[/[^_]\d*/, 0] : @tahun
  end
end
