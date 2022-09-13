class DaftarResikoPdf < Prawn::Document
  def initialize(opd: '', tahun: '', program_kegiatans: '')
    super page_layout: :landscape
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
    table(subkegiatan, cell_style: { size: 8 }) do
      cells.padding = 8
    end
  end

  def header_tabel
    [{ content: "No" }, { content: "SUB KEGIATAN", align: :center }]
  end

  def subkegiatan
    tabel_subkegiatan = [header_tabel]
    @program_kegiatans.each.with_index(1) do |pk, i|
      tabel_subkegiatan << [{ content: i.to_s, valign: :center },
                            { content: pk.nama_subkegiatan, valign: :center }]
    end
    tabel_subkegiatan
  end
end
