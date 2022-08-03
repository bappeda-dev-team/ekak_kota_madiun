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

  def program_kegiatans_by_opd
    opd.program_kegiatans
  end

  def pk_sasaran_tanpa_cloning
    program_kegiatans_by_opd.filter_map { |pk| pk.sasarans.reject { |s| s.tahun.match?(/(_)/) } }.compact_blank!
  end

  def pk_sasaran_dengan_cloning
    program_kegiatans_by_opd.filter_map { |pk| pk.sasarans.select { |s| s.tahun.match?(/(_)/) } }.compact_blank!
  end

  def total_pagu(pk_sasarans)
    pk_sasarans.each_value.map { |item| item.sum(&:total_anggaran) }.compact.sum
  end

  def pk_sasarans(program_kegiatan: @program_kegiatan)
    program_kegiatan.sasarans.reject { |s| s.tahun.match?(/(_)/) }
  end

  private

  def opd
    @opd ||= Opd.find_by(kode_unik_opd: @kode_unik_opd)
  end

  def tanpa_cloning(sasarans)
    sasarans.reject { |s| s.tahun.match?(/(_)/) }
  end
end
