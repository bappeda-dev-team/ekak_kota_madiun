class RadPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper

  def initialize(sasaran_kota: '', tahun: '', sub_tematik: '')
    super page_layout: :landscape, page_size: "LETTER"
    @tahun = tahun
    @sub_tematik = sub_tematik
    @sasaran_kota = sasaran_kota
    print
  end

  def print
    title
    move_down 20
    tabel_gender(gender)
    move_down 30
    move_down 10
  end

  def title
    text "LAPORAN RENCANA AKSI DAERAH", align: :center
    move_down 3
    text "#{@sub_tematik.upcase} KOTA MADIUN", align: :center
    move_down 3
    text "Tahun: #{@tahun}/2023", align: :center
  end

  def ttd
    start_new_page if (cursor - 100).negative?
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

  def header_tabel
    [[{ content: "No", width: 50 },
      { content: "Sasaran OPD", align: :center, width: 550 },
      { content: "ISU GENDER", colspan: 3, align: :center },
      { content: "KEBIJAKAN DAN RENCANA KEDEPAN", colspan: 2, align: :center },
      { content: "PENGUKURAN HASIL", colspan: 2, align: :center }]]
  end

  def gender
    # main table
    data_gender = header_tabel
    data_gender << [{ content: @gender.program_kegiatan_subkegiatan },
                    { content: @gender.data_pembuka_wawasan },
                    { content: @gender.faktor_kesenjangan },
                    { content: @gender.penyebab_internal_non_html },
                    { content: @gender.penyebab_external_non_html },
                    { content: @gender.reformulasi_tujuan },
                    { content: @gender.rencana_aksi_tahapan },
                    { content: @gender.data_baseline },
                    { content: @gender.indikator_gender }]
    # create cell
  end

  private

  def tabel_gender(content_tabel)
    table(content_tabel, header: true) do
      cells.style(size: 8, inline_format: true)
    end
  end

  def tabel_maker(data)
    make_table(data, header: true) do
      cells.style(size: 8, inline_format: true)
    end
  end
end
