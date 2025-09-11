# WARNING : require htmlpdf
class IkuSakipPdf
  def initialize(tahun: '', kode_opd: '')
    @tahun = tahun
    @kode_opd = kode_opd
    @tahun_bener = parse_tahun
  end

  def generate
    pokin_opd = PohonKinerjaOpdQueries.new(tahun: @tahun, kode_opd: @kode_opd)
    opd = pokin_opd.opd

    nama_opd           = opd.nama_opd
    jabatan_kepala_opd = opd.jabatan_kepala_tanpa_opd
    nama_kepala_opd    = opd.nama_kepala
    nip_kepala_opd     = opd.nip_kepala_fix_plt
    pangkat_kepala_opd = opd.pangkat_kepala

    tujuan_opd  = opd.tujuan_opds.by_periode(@tahun_bener).uniq(&:tujuan)
    sasaran_opd = pokin_opd.strategi_opd.map(&:sasarans).flatten.compact_blank
    iku_opd     = tujuan_opd + sasaran_opd

    iku_opd_hash = iku_opd
                   .map { |ts| [ts, ts.indikators.shown] }
                   .select { |_, indikators| indikators.present? }
                   .to_h

    title = "IKU SAKIP OPD"

    # render ke PDF
    pdf_html = ApplicationController.render(
      template: "indikators/cetak_iku_sakip",
      layout: "pdf_baru",
      assigns: {
        tahun: @tahun,
        tahun_bener: @tahun_bener,
        kode_opd: @kode_opd,
        nama_opd: nama_opd,
        jabatan_kepala_opd: jabatan_kepala_opd,
        nama_kepala_opd: nama_kepala_opd,
        nip_kepala_opd: nip_kepala_opd,
        pangkat_kepala_opd: pangkat_kepala_opd,
        iku_opd: iku_opd_hash,
        title: title
      }
    )

    WickedPdf.new.pdf_from_string(
      pdf_html,
      orientation: "Landscape",
      page_size: "Legal"
    )
  end

  private

  def parse_tahun
    if @tahun&.match(/murni|perubahan/)
      @tahun[/[^_]\d*/, 0]
    else
      @tahun
    end
  end
end
