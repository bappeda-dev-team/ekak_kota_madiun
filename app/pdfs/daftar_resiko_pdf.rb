class DaftarResikoPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper
  def initialize(opd: '', tahun: '', program_kegiatans: '')
    super page_layout: :landscape, page_size: "LETTER"
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
    tabel_daftar_resiko
  end

  def title
    text "DAFTAR RESIKO RENCANA KINERJA", align: :center
    move_down 3
    text @nama_opd.upcase, align: :center
    text @kota.upcase, align: :center
    move_down 3
    text "TAHUN #{@tahun}", align: :center
  end

  def tabel_daftar_resiko
    table(content_tabel, header: true) do
      cells.style(size: 8)
    end
  end

  def header_tabel
    [{ content: "No" }, { content: "SUB KEGIATAN", align: :center }, { content: "SASARAN" }]
  end

  def content_tabel
    subkegiatan
  end

  # data tabel

  def subkegiatan
    tabel_subkegiatan = [header_tabel]
    @program_kegiatans.each.with_index(1) do |pk, i|
      row_awal = pk.sasarans.map { |sas| sas.indikator_sasarans.size }.compact.reduce(:+)
      row_dalam = pk.sasarans.size + row_awal
      tabel_subkegiatan << [{ content: i.to_s, valign: :top },
                            { content: pk.nama_subkegiatan, valign: :top, width: 100 }, sasarans(pk.sasarans)]
    end
    tabel_subkegiatan
  end

  def sasarans(sasarans)
    sasaran_arr = []
    sasarans.where(tahun: @tahun).each.with_index(1) do |s, no|
      sasaran_arr << [{ content: no.to_s, align: :center, width: 20 },
                      { content: s.sasaran_kinerja, align: :left, width: 75 },
                      indikators(s.indikator_sasarans),
                      { content: "Rp. #{number_with_delimiter(s&.total_anggaran || 0)}", width: 50 },
                      { content: s.rincian&.resiko || '-', width: 75 },
                      { content: s.rincian&.kemungkinan&.deskripsi || '-', width: 30 },
                      { content: s.rincian&.dampak || '-', width: 75 },
                      { content: s.rincian&.skala_dampak&.deskripsi || '-', width: 30 },
                      { content: "(#{s.rincian&.peta_resiko}) #{s.rincian&.nilai_peta_resiko}", width: 75 }]
    end
    tabel_maker sasaran_arr
  end

  def indikators(indikator_sasarans)
    indikators = indikator_sasarans.map do |ind|
      [{ content: ind.indikator_kinerja, width: 75 },
       { content: ind.target, width: 20 },
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
