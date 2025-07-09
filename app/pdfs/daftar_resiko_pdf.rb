class DaftarResikoPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper

  def initialize(opd: '', tahun: '', program_kegiatans: '')
    super(page_layout: :landscape, page_size: "A2")
    @opd = opd
    @tahun = tahun
    @nama_opd = @opd.nama_opd
    @kota = @opd.lembaga.nama_lembaga
    @program_kegiatans = program_kegiatans
    print
  end

  def print
    title
    move_down 20
    tabel_daftar_resiko(subkegiatan)
    move_down 50
    ttd
  end

  def title
    text "DAFTAR RESIKO RENCANA KINERJA", align: :center
    move_down 3
    text @nama_opd.upcase, align: :center
    text @kota.upcase, align: :center
    move_down 3
    text "TAHUN #{@tahun}", align: :center
  end

  def ttd
    start_new_page if (cursor - 90).negative?
    bounding_box([bounds.width - 660, cursor - 10], width: bounds.width - 500) do
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

  def tabel_daftar_resiko(content_tabel)
    table(content_tabel, header: true) do
      cells.style(size: 8)
    end
  end

  def header_tabel
    [{ content: "No" }, { content: "SUB KEGIATAN", align: :center },
     tabel_maker(subheader_tabel)]
  end

  def subheader_tabel
    [[{ content: "No", width: 40, align: :center },
      { content: "SASARAN", width: 200, align: :center },
      { content: "INDIKATOR", width: 150, align: :center },
      { content: "T", width: 30, align: :center },
      { content: "S", width: 70, align: :center },
      { content: "PAGU", width: 80, align: :center },
      { content: "RISIKO", width: 180, align: :center },
      { content: "KEMUNGKINAN", width: 70, align: :center },
      { content: "DAMPAK", width: 150, align: :center },
      { content: "SKALA DAMPAK", width: 50, align: :center },
      { content: "SKALA / PETA RISIKO", width: 75, align: :center },
      { content: "PIHAK YANG TERKENA", width: 100, align: :center },
      { content: "RTP", width: 110, align: :center }]]
  end

  def subkegiatan
    tabel_subkegiatan = [header_tabel]
    @program_kegiatans.each.with_index(1) do |(pk, sasarans), i|
      tabel_subkegiatan << [{ content: i.to_s, valign: :top },
                            { content: pk.nama_subkegiatan, valign: :top, width: 250 }, sasarans(sasarans, i)]
    end
    tabel_subkegiatan
  end

  def sasarans(sasarans, no_sub)
    sasaran_arr = []
    # warning, not loop indikator
    sasarans.each.with_index(1) do |s, no|
      nilai_kemungkinan = s.rincian&.kemungkinan&.nilai
      nilai_skala_dampak = s.rincian&.skala_dampak&.nilai
      peta_resiko = ApplicationController.helpers.peta_resiko(nilai_kemungkinan, nilai_skala_dampak)
      nilai_peta_resiko = ApplicationController.helpers.nilai_peta_resiko(peta_resiko)
      sasaran_arr << [{ content: "#{no_sub}.#{no}", align: :center, width: 40 },
                      { content: s.sasaran_kinerja, align: :left, width: 200 },
                      { content: s.indikator_sasarans&.first&.indikator_kinerja, width: 150 },
                      { content: s.indikator_sasarans&.first&.target.to_s, width: 30 },
                      { content: s.indikator_sasarans&.first&.satuan, width: 70 },
                      { content: "Rp. #{number_with_delimiter(s&.total_anggaran || 0)}", width: 80 },
                      { content: s.rincian&.resiko || '-', width: 180 },
                      { content: s.rincian&.kemungkinan&.deskripsi || '-', width: 70, align: :center },
                      { content: s.rincian&.dampak || '-', width: 150, align: :center },
                      { content: s.rincian&.skala_dampak&.deskripsi || '-', width: 50, align: :center },
                      { content: "(#{peta_resiko}) #{nilai_peta_resiko}", width: 75, align: :center },
                      { content: s&.penerima_manfaat || '-', width: 100, align: :center },
                      { content: s.rtp_sasaran.to_s, width: 110, align: :center }]
    end
    tabel_maker sasaran_arr
  end

  def indikators(indikator_sasarans)
    indikators = indikator_sasarans.map do |ind|
      [{ content: ind.indikator_kinerja, width: 150 },
       { content: ind.target.to_s, width: 30 },
       { content: ind.satuan, width: 70 }]
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
