# To get rencana kinerja ( sasaran ) by OPD and program_kegiatan
# pk = ProgramKegiatan ( subkegitan )
class KakServices
  attr_reader :kode_unik_opd, :program_kegiatan

  def initialize(kode_unik_opd: nil, program_kegiatan: nil)
    @kode_unik_opd = kode_unik_opd
    @program_kegiatan = program_kegiatan
  end

  def sasaran_kak_tanpa_cloning
    pk_sasaran_tanpa_cloning.flatten.group_by(&:program_kegiatan)
  end

  def sasaran_kak_dengan_cloning(tahun: nil)
    pk_sasaran_dengan_cloning(tahun: tahun).flatten.group_by(&:program_kegiatan)
  end

  def kak_user_program_kegiatan_sasaran_tanpa_kloning
    sasaran_kak_by_user_tanpa_cloning.transform_values { |value| value.group_by(&:program_kegiatan) }
  end

  def sasaran_kak_by_user_tanpa_cloning
    pk_user_sasaran_tanpa_cloning.flatten.group_by(&:user)
  end

  def program_kegiatans_by_opd
    opd.program_kegiatans
  end

  def pk_sasaran_tanpa_cloning
    program_kegiatans_by_opd.filter_map { |pk| pk.sasarans.reject { |s| s.tahun&.match?(/(_)/) } }.compact_blank!
  end

  def pk_sasaran_dengan_cloning(tahun: nil)
    program_kegiatans_by_opd.filter_map { |pk| pk.sasarans.select { |s| s.tahun == tahun } }.compact_blank!
  end

  def pk_user_sasaran_tanpa_cloning
    opd.users.asn_aktif.filter_map { |ss| ss.sasarans.dengan_sub_kegiatan.reject { |s| s.tahun&.match?(/(_)/) } }
  end

  def total_pagu(kak_sasaran_collection)
    kak_sasaran_collection.each_value.map { |item| item.sum(&:total_anggaran) }.sum
  rescue NoMethodError
    false
  end

  def pk_sasarans(program_kegiatan: @program_kegiatan)
    program_kegiatan.sasarans.reject { |s| s.tahun.match?(/(_)/) }
  end

  private

  def opd
    @opd ||= Opd.find_by(kode_unik_opd: @kode_unik_opd)
  end
end
