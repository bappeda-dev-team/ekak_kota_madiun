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

  def sasarans_filter(_tahun_sasaran, sasarans)
    if tahun.match(/(_)/)
      sasarans.select { |s| s.tahun == _tahun_sasaran }
    else
      sasarans.reject { |s| s.tahun&.match?(/(_)/) }
    end
  end

  def laporan_rencana_kinerja
    program_kegiatans_by_opd.map do |pk|
      sasarans_filter(@tahun, pk.sasarans)
    end.compact_blank!.flatten.group_by(&:program_kegiatan)
  end

  def sasarans_by_user
    asn_aktif_by_opd.map do |user_aktif|
      { user_aktif => sasarans_filter(@tahun, user_sasarans(user_aktif)).group_by(&:program_kegiatan) }
    end
  end

  def user_sasarans(users)
    users.sasarans.dengan_sub_kegiatan
  end

  def program_kegiatans_by_opd
    opd.program_kegiatans
  end

  def asn_aktif_by_opd
    opd.users.asn_aktif
  end

  def total_pagu
    laporan_rencana_kinerja.each_value.map { |sasarans| sasarans.map(&:total_anggaran).compact.sum }.inject(:+)
  end

  def total_sasaran_aktif
    sasarans_by_user.map do |user_aktif|
      user_aktif.each_value.map do |sasarans|
        sasarans.count
      end.compact.sum
    end.inject(:+)
  end

  def total_usulan_sasaran(tipe_usulan)
    asn_aktif_by_opd.map do |user_aktif|
      sasarans_filter(@tahun, user_sasarans(user_aktif)).map(&:my_usulan).flatten.filter do |s|
        s.instance_of?(tipe_usulan)
      end.size
    end.inject(:+)
  end

  def total_usulan_musrenbang
    {
      musrenbang: total_usulan_sasaran(Musrenbang),
      pokir: total_usulan_sasaran(Pokpir),
      mandatori: total_usulan_sasaran(Mandatori),
      inisiatif_walikota: total_usulan_sasaran(Inovasi)
    }
  end

  private

  def opd
    @opd ||= Opd.find_by(kode_unik_opd: @kode_unik_opd)
  end
end
