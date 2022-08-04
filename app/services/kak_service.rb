# To get rencana kinerja ( sasaran ) by OPD and program_kegiatan
# pk = ProgramKegiatan ( subkegitan )
class KakService
  attr_reader :kode_unik_opd, :program_kegiatan

  def initialize(tahun:, kode_unik_opd: nil, program_kegiatan: nil)
    @kode_unik_opd = kode_unik_opd
    @program_kegiatan = program_kegiatan
    @tahun = tahun.to_s
  end

  def tahun
    @tahun = @tahun.match(/murni/) ? @tahun[/[^_]\d*/, 0] : @tahun
  end

  def tahun_sasaran_matcher(tahun_sasaran)
    tahun_sasaran&.match?(/(_)/)
  end

  def laporan_rencana_kinerja
    program_kegiatans_by_opd.filter_map do |pk|
      pk.sasarans.reject do |s|
        tahun_sasaran_matcher(s.tahun)
      end
    end.compact_blank!.flatten.group_by(&:program_kegiatan)
  end

  def laporan_rencana_kinerja_users
    sasarans_by_user.transform_values { |value| value.group_by(&:program_kegiatan) }
  end

  def sasarans_by_user
    asn_aktif_by_opd.filter_map do |user_aktif|
      user_aktif.sasarans.dengan_sub_kegiatan.reject do |s|
        tahun_sasaran_matcher(s.tahun)
      end
    end.flatten.group_by(&:user)
  end

  def program_kegiatans_by_opd
    opd.program_kegiatans
  end

  def asn_aktif_by_opd
    opd.users.asn_aktif
  end

  def total_pagu(kak_sasaran_collection)
    kak_sasaran_collection.each_value.map { |item| item.map(&:total_anggaran).compact.sum }.inject(:+)
  end

  private

  def opd
    @opd ||= Opd.find_by(kode_unik_opd: @kode_unik_opd)
  end
end
