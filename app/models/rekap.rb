class Rekap
  attr_accessor :kode_unik_opd

  def initialize(kode_unik_opd:)
    @kode_unik_opd = kode_unik_opd
  end

  def jumlah_rekap
    # FIXME optimize this
    {
      opd: opd.nama_opd,
      musrenbang: jumlah_usulan('Musrenbang'),
      pokir: jumlah_usulan('Pokpir'),
      mandatori: jumlah_usulan('Mandatori'),
      inisiatif_walikota: jumlah_usulan('Inovasi'),
      sasaran: jumlah_sasaran,
      subkegiatan: jumlah_subkegiatan,
      kegiatan: jumlah_kegiatan,
      program: jumlah_program,
      eselon4: jumlah_eselon4,
      eselon3: jumlah_eselon3,
      anggaran: jumlah_anggaran
    }
  end

  def jumlah_usulan(jenis)
    programs.map do |pr|
      pr.sasarans.map do |s|
        s.usulans.select do |u|
          u.usulanable_type == jenis.capitalize
        end
      end
    end.flatten.count
  end

  def jumlah_sasaran
    programs.map(&:sasarans).flatten.count
  end

  def programkegiatan
    opd.program_kegiatans.with_sasarans
  end

  def jumlah_program
    programkegiatan.select(:id_program_sipd).distinct.count
  end

  def jumlah_kegiatan
    programkegiatan.select(:id_giat).distinct.count
  end

  def jumlah_subkegiatan
    programkegiatan.select(:id_sub_giat).distinct.count
  end

  def jumlah_eselon4
    opd.users.asn_aktif.select { |u| u.type == 'User' }.count
  end

  def jumlah_eselon3
    opd.users.asn_aktif.select { |u| u.type == 'Atasan' }.count
  end

  def jumlah_anggaran
    programs.sum(&:my_pagu)
  end

  def programs
    ProgramKegiatan.includes(%i[opd sasarans]).where(opds: { kode_unik_opd: @kode_unik_opd }).with_sasarans
  end

  def opd
    Opd.find_by(kode_unik_opd: @kode_unik_opd)
  end
end
