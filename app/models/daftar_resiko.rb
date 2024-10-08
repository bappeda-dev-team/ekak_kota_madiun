# handle daftar resiko for admin and asn
class DaftarResiko
  def initialize(tahun:, kode_unik_opd: nil)
    @kode_unik_opd = kode_unik_opd
    @tahun = tahun.to_s
  end

  def daftar_resiko_eselon3(nip: '')
    sasarans = Sasaran.where(nip_asn: nip, tahun: tahun)
    strategis = sasarans.map(&:strategi).compact_blank
    strategi_bawahans = strategis.flat_map do |strategi|
      strategi.strategi_bawahans.where(tahun: tahun)
    end
    sasaran_bawahans = strategi_bawahans.uniq.flat_map { |str| sasarans_filter(tahun, str.sasarans.dengan_sub_kegiatan) }
    sasaran_bawahans.compact_blank!.flatten.group_by(&:program_kegiatan)
  end

  def daftar_resiko_asn(nip: '')
    program_kegiatans_by_opd.with_sasarans_rincian.map do |pk|
      sasarans_asn = pk.sasarans.where(sasarans: { nip_asn: nip })
      sasarans_filter(tahun, sasarans_asn)
    end.compact_blank!.flatten.group_by(&:program_kegiatan)
  end

  def daftar_resiko_sasaran(sasaran_id: '')
    program_kegiatans_by_opd.with_sasarans_rincian.map do |pk|
      sasarans_asn = pk.sasarans.where(sasarans: { id: sasaran_id })
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
    kode_opd = if @kode_unik_opd.last == '0'
                 @kode_unik_opd
               else
                 @kode_unik_opd.gsub(/\d$/, '0')
               end

    @opd ||= Opd.find_by(kode_unik_opd: kode_opd)
  end

  def tahun
    @tahun = @tahun.match(/murni/) ? @tahun[/[^_]\d*/, 0] : @tahun
  end
end
