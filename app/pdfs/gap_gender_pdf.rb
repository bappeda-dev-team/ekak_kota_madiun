class GapGenderPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper

  def initialize(opd: '', tahun: '', gender: '')
    super page_layout: :landscape, page_size: "LETTER"
    @opd = opd
    @tahun = tahun
    @nama_opd = @opd.nama_opd
    @kota = @opd.lembaga.nama_lembaga
    @gender = gender
    @program_kegiatan = @gender.program_kegiatan
    print
  end

  def print
    title
    move_down 20
    tabel_gender(gender)
    move_down 30
    move_down 20
    ttd
  end

  def title
    text "GENDER ANALYSIS PATHWAY", align: :center
    move_down 3
    text "Tahun: #{@tahun}", align: :center
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

  def header_tabel
    [[{ content: "KEBIJAKAN / PROGRAM / KEGIATAN / SUBKEGIATAN", rowspan: 2, width: 70 },
      { content: "DATA PEMBUKA WAWASAN", align: :center, rowspan: 2, width: 70 },
      { content: "ISU GENDER", colspan: 3, align: :center },
      { content: "KEBIJAKAN DAN RENCANA KEDEPAN", colspan: 2, align: :center },
      { content: "PENGUKURAN HASIL", colspan: 2, align: :center }],
     [{ content: "FAKTOR KESENJANGAN", width: 70, align: :center },
      { content:  "SEBAB INTERNAL", width: 70, align: :center },
      { content:  "SEBAB EXTERNAL", width: 70, align: :center },
      { content:  "REFORMULASI TUJUAN", width: 70, align: :center },
      { content:  "RENCANA AKSI", width: 70, align: :center },
      { content:  "BASELINE", width: 70, align: :center },
      { content:  "INDIKATOR", width: 70, align: :center }]]
  end

  def gender
    # main table
    data_gender = header_tabel
    data_gender << [{ content: @program_kegiatan.nama_subkegiatan },
                    { content: @gender.sasaran.sasaran_kinerja },
                    { content: @gender.faktor_kesenjangan },
                    { content: @gender.penyebab_internal },
                    { content: @gender.penyebab_external },
                    { content: @gender.reformulasi_tujuan },
                    { content: @gender.sasaran.tahapans.first.tahapan_kerja },
                    { content: @gender.data_terpilah },
                    { content: @gender.indikator }]
    # create cell
  end

  def data_pembuka_wawasan
    pembuka_wawasan = [
      { content: @gender.sasaran.sasaran_kinerja },
      { content: @gender.sasaran.penerima_manfaat },
      { content: @gender.sasaran.rincian.data_terpilah }
    ]
  end

  private

  def tabel_gender(content_tabel)
    table(content_tabel, header: true) do
      cells.style(size: 8)
    end
  end

  def tabel_maker(data)
    make_table(data) do
      cells.style(size: 8)
    end
  end
end
