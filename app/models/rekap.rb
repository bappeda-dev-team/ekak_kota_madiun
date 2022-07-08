class Rekap
  attr_accessor :kode_unik_opd

  def initialize(kode_unik_opd:)
    @kode_unik_opd = kode_unik_opd
  end

  def jumlah_rekap
    # FIXME optimize this
    usulans_all = usulans
    jumlah_programkegiatan = programs.select { |p| p.sasarans.present? }
    sasaran = jumlah_programkegiatan.map(&:sasarans).flatten.size
    musrenbang = usulans_all.select { |u| u.usulanable_type == 'Musrenbang' }.size
    pokir = usulans_all.select { |u| u.usulanable_type == 'Pokpir' }.size
    mandatori = usulans_all.select { |u| u.usulanable_type == 'Mandatori' }.size
    inisiatif_walikota = usulans_all.select { |u| u.usulanable_type == 'Inovasi' }.size
    total_usulan = usulans_all.size
    jumlah_pegawai = opd.users.asn_aktif
    pegawai_eselon4 = jumlah_pegawai.select { |u| u.type == 'User' }.size
    pegawai_eselon3 = jumlah_pegawai.select { |u| u.type == 'Atasan' }.size
    subkegiatan = jumlah_programkegiatan.select(&:id_sub_giat).uniq.size
    kegiatan = jumlah_programkegiatan.select(&:id_giat).uniq.size
    program = jumlah_programkegiatan.select(&:id_program_sipd).uniq.size
    [{
      opd: opd.nama_opd,
      musrenbang: musrenbang,
      pokir: pokir,
      mandatori: mandatori,
      inisiatif_walikota: inisiatif_walikota,
      total_usulan: total_usulan,
      sasaran: sasaran,
      subkegiatan: subkegiatan,
      kegiatan: kegiatan,
      program: program,
      eselon4: pegawai_eselon4,
      eselon3: pegawai_eselon3,
      anggaran: jumlah_anggaran
    }]
  end

  def all_rekap
    opds = Opd.where.not(kode_unik_opd: nil).pluck(:kode_unik_opd)
    opds.map { |opd| Rekap.new(kode_unik_opd: opd).jumlah_rekap }.flatten
  end

  def jumlah_usulan(jenis: nil)
    programs.map { |pr| pr.sasarans.map(&:usulans) }.flatten.select { |u| u.usulanable_type == jenis }.count
  end

  def usulans
    programs.map { |pr| pr.sasarans.map(&:usulans) }.flatten
  end

  def jumlah_anggaran
    programs.sum(&:my_pagu)
  end

  def programs
    ProgramKegiatan.where(kode_sub_skpd: @kode_unik_opd)
  end

  def opd
    @opd ||= Opd.find_by(kode_unik_opd: @kode_unik_opd)
  end
end
