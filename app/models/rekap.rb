class Rekap
  attr_accessor :kode_unik_opd

  def initialize(kode_unik_opd:)
    @kode_unik_opd = kode_unik_opd
  end

  def jumlah_rekap
    # FIXME optimize this
    musrenbang = jumlah_usulan(jenis: 'Musrenbang')
    pokir = jumlah_usulan(jenis: 'Pokir')
    mandatori = jumlah_usulan(jenis: 'Mandatori')
    inisiatif_walikota = jumlah_usulan(jenis: 'Inovasi')
    total_usulan = musrenbang + pokir + mandatori + inisiatif_walikota
    {
      opd: opd.nama_opd,
      musrenbang: musrenbang,
      pokir: pokir,
      mandatori: mandatori,
      inisiatif_walikota: inisiatif_walikota,
      total_usulan: total_usulan,
      sasaran: jumlah_sasaran,
      subkegiatan: jumlah_subkegiatan,
      kegiatan: jumlah_kegiatan,
      program: jumlah_program,
      eselon4: jumlah_eselon4,
      eselon3: jumlah_eselon3,
      anggaran: jumlah_anggaran
    }
  end

  def jumlah_usulan(jenis: nil)
    # programs.map do |pr|
    #   pr.sasarans.map do |s|
    #     s.usulans.select do |u|
    #       u.usulanable_type == jenis
    #     end
    #   end
    # end.flatten.count
    programs.map { |pr| pr.sasarans.map(&:usulans) }.flatten.select { |u| u.usulanable_type == jenis }.count
  end

  def jumlah_sasaran
    programs.map(&:sasarans).flatten.count
  end

  def jumlah_program
    programs.select(:id_program_sipd).distinct.count
  end

  def jumlah_kegiatan
    programs.select(:id_giat).distinct.count
  end

  def jumlah_subkegiatan
    programs.select(:id_sub_giat).distinct.count
  end

  def jumlah_eselon4
    @opd.users.asn_aktif.select { |u| u.type == 'User' }.count
  end

  def jumlah_eselon3
    @opd.users.asn_aktif.select { |u| u.type == 'Atasan' }.count
  end

  def jumlah_anggaran
    programs.sum(&:my_pagu)
  end

  def programs
    ProgramKegiatan.where(kode_sub_skpd: @kode_unik_opd).with_sasarans
  end

  def opd
    @opd ||= Opd.find_by(kode_unik_opd: @kode_unik_opd)
  end
end
