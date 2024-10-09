class SpbePdf < Prawn::Document
  include ActionView::Helpers::NumberHelper

  def initialize(opd: '', tahun: '', programs: '', spbes: '', timestamp: '')
    super(page_layout: :landscape, page_size: "LETTER")
    @opd = opd
    @tahun = tahun
    @nama_opd = @opd.nama_opd
    @kota = @opd.lembaga.nama_lembaga
    @programs = programs
    @spbes = spbes
    @judul = "Tabel Peta Rencana Usulan Aplikasi SPBE"
    @timestamp = timestamp
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

  def my_app_name
    "https://kak.madiunkota.go.id"
  end

  def footer
    text "Dicetak pada #{@timestamp} via #{my_app_name}", valign: :bottom,
                                                          size: 8
  end

  def header_tabel
    [
      { content: "No", width: 20, align: :center },
      { content: "Nama OPD", align: :center },
      { content: "Nama Program pada Rencana Kerja", align: :center },
      { content: "Jenis Layanan pada Standar Pelayanan", align: :center },
      { content: "Nama Aplikasi", align: :center },
      { content: "Tahun Pelaksanaan", align: :center },
      { content: "Keterangan", align: :center }
    ]
  end

  def tabel_spbe
    tabel = [header_tabel]
    @spbes.each.with_index(1) do |(program, spbes), i|
      tabel << [
        { content: i.to_s, valign: :top },
        { content: program.opd.nama_opd },
        { content: program.nama_program }
      ]
      spbes.map do |spbe|
        tahun_spbe = "#{spbe.spbe_rincians.first.tahun_awal}-#{spbe.spbe_rincians.first.tahun_akhir} "
        keterangan_spbe = "#{spbe.spbe_rincians.first.keterangan}"
        tabel << [
          { content: spbe.jenis_pelayanan },
          { content: spbe.nama_aplikasi },
          { content: tahun_spbe },
          { content: keterangan_spbe }
        ]
      end
    end
    table(tabel, header: true) do
      cells.style(size: 8)
    end
  end

  def sasarans(sasarans)
    sasaran_arr = []
    # warning, not loop indikator
    sasarans.each.with_index(1) do |s, no|
      nilai_kemungkinan = s.rincian&.kemungkinan&.nilai
      nilai_skala_dampak = s.rincian&.skala_dampak&.nilai
      peta_resiko = ApplicationController.helpers.peta_resiko(nilai_kemungkinan, nilai_skala_dampak)
      nilai_peta_resiko = ApplicationController.helpers.nilai_peta_resiko(peta_resiko)
      sasaran_arr << [{ content: no.to_s, align: :center, width: 20 },
                      { content: s.sasaran_kinerja, align: :left, width: 75 },
                      { content: s.indikator_sasarans&.first&.indikator_kinerja, width: 75 },
                      { content: s.indikator_sasarans&.first&.target.to_s, width: 30 },
                      { content: s.indikator_sasarans&.first&.satuan, width: 30 },
                      { content: "Rp. #{number_with_delimiter(s&.total_anggaran || 0)}", width: 65 },
                      { content: s.rincian&.resiko || '-', width: 75 },
                      { content: s.rincian&.kemungkinan&.deskripsi || '-', width: 50, align: :center },
                      { content: s.rincian&.dampak || '-', width: 75, align: :center },
                      { content: s.rincian&.skala_dampak&.deskripsi || '-', width: 50, align: :center },
                      { content: "(#{peta_resiko}) #{nilai_peta_resiko}", width: 55,
                        align: :center }]
    end
    tabel_maker sasaran_arr
  end

  def indikators(indikator_sasarans)
    indikators = indikator_sasarans.map do |ind|
      [{ content: ind.indikator_kinerja, width: 75 },
       { content: ind.target.to_s, width: 30 },
       { content: ind.satuan, width: 30 }]
    end
    tabel_maker indikators
  end

  private

  def tabel_maker(data)
    make_table(data) do
      cells.style(size: 8)
    end
  end
end
