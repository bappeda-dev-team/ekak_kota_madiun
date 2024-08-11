# handle daftar resiko for admin and asn
class DaftarResiko
  def initialize(tahun:, kode_unik_opd: nil)
    @kode_unik_opd = kode_unik_opd
    @tahun = tahun.to_s
  end

  def daftar_resiko_asn(nip: '')
    program_kegiatans_by_opd.with_sasarans_rincian.map do |pk|
      sasarans_asn = pk.sasarans.where(sasarans: { nip_asn: nip })
      sasarans_filter(tahun, sasarans_asn)
    end.compact_blank!.flatten.group_by(&:program_kegiatan)
  end

  def sasarans_filter(tahun_sasaran, sasarans)
    sasarans.dengan_rincian.where(tahun: tahun_sasaran)
            .where.not(nip_asn: [nil, ""])
            .select { |sas| sas.deleted_at.blank? }
  end

  def daftar_resiko_opd
    program_kegiatans_by_opd.with_sasarans_rincian.map do |pk|
      sasarans_filter(tahun, pk.sasarans)
    end.compact_blank!.flatten.group_by(&:program_kegiatan)
  end

  def program_kegiatans_by_opd
    opd.program_kegiatans
  end

  def opd
    @opd ||= Opd.find_by(kode_unik_opd: @kode_unik_opd)
  end

  def tahun
    @tahun = @tahun.match(/murni/) ? @tahun[/[^_]\d*/, 0] : @tahun
  end
end
