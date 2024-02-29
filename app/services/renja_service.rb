class RenjaService
  def initialize(kode_opd: '', tahun: '')
    @kode_opd = kode_opd
    @tahun = tahun
  end

  def opd
    Opd.find_by(kode_unik_opd: @kode_opd)
  end

  def pelaksana_subkegiatan
    opd.users.eselon4
  end

  def program_kegiatans
    @program_kegiatans ||= if @tahun.to_i < 2025
                             ProgramKegiatan.where(kode_skpd: @kode_opd)
                                            .where.not(kode_skpd: [nil, ""])

                           else
                             # mencari program kegiatan yang digunakan
                             # dalam sasaran kinerja
                             # berlakau pada tahun 2025 ++
                             pelaksana_subkegiatan.flat_map do |user|
                               user.sasarans
                                   .includes(:program_kegiatan)
                                   .where(tahun: @tahun)
                                   .where.not(program_kegiatans: { kode_skpd: [nil, ""] })
                                   .map(&:program_kegiatan)
                             end.compact_blank
                           end
  end

  def program_renja
    program_kegiatans.map do |pr|
      { jenis: 'program',
        parent: pr.kode_bidang_urusan,
        kode_opd: pr.kode_sub_skpd,
        kode: pr.kode_program,
        nama: pr.nama_program }
    end.uniq { |pk| pk[:kode] }
  end

  def kegiatan_renja
    program_kegiatans.map do |pr|
      { jenis: 'kegiatan',
        parent: pr.kode_program,
        kode_opd: pr.kode_sub_skpd,
        kode: pr.kode_giat,
        nama: pr.nama_kegiatan }
    end.uniq { |pk| pk[:kode] }
  end

  def subkegiatan_renja
    program_kegiatans.map do |pr|
      { jenis: 'subkegiatan',
        parent: pr.kode_giat,
        kode_opd: pr.kode_sub_skpd,
        kode: pr.kode_sub_giat,
        nama: pr.nama_subkegiatan }
    end.uniq { |pk| pk[:kode] }
  end
end
