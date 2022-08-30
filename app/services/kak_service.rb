# KakService(tahun: 2022, kode_unik_opd: '5.01.01.xx', program_kegiatan: optional)
# used for get pk by opd, sasarans by user on opd selected
# compatible with tahun kelompok_anggaran
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

  def sasarans_filter(tahun_sasaran, sasarans)
    if tahun.match(/(_)/)
      sasarans.select { |s| s.tahun == tahun_sasaran }
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

  def isu_strategis
    all_isu = program_kegiatans_by_opd.map do |pk|
      {
        nama_program: pk.nama_program,
        kode_program: pk.kode_program,
        indikator: pk.indikator_program,
        target: pk.target_program,
        satuan: pk.satuan_target_program,
        subkegiatan: pk.nama_subkegiatan,
        indikator_sub: pk.indikator_subkegiatan,
        target_sub: pk.target_subkegiatan,
        satuan_sub: pk.satuan_target_subkegiatan,
        isu_strategis: pk.isu_strategis,
        permasalahans: pk.permasalahans.map(&:permasalahan)
      }
    end
    all_isu.group_by { |key, _value| key[:kode_program] }
  end

  def hash_by_pluck(collections)
    collections.each_with_object({}) do |(key1, key2, key3), result|
      result[key1] ||= {}
      reulst[key1][key2] = key3
    end
  end

  def total_pagu
    laporan_rencana_kinerja.each_value.map { |sasarans| sasarans.map(&:total_anggaran).compact.sum }.inject(:+)
  end

  def total_sasaran_aktif
    sasarans_by_user.map do |collections|
      collections.values.map do |program_kegiatans|
        program_kegiatans.values.map(&:size)
      end
    end.flatten.inject(:+)
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

  def opd
    @opd ||= Opd.find_by(kode_unik_opd: @kode_unik_opd)
  end
end
