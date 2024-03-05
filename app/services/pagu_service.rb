class PaguService
  def initialize(tahun: '', jenis: 'ranwal')
    @tahun = tahun
    @jenis = jenis
  end

  def opds
    @opds ||= Opd.opd_resmi
  end

  def program_kegiatan_opd
    opds.map do |opd|
      {
        nama_opd: opd.nama_opd,
        kode_opd: opd.kode_unik_opd,
        jumlah_program: program_opd(opd).size,
        jumlah_kegiatan: kegiatan_opd(opd).size,
        jumlah_subkegiatan: subkegiatan_opd(opd).size
      }
    end
  end

  def program_opd(opd)
    program_kegiatans(opd)
      .uniq { |pk| pk.values_at(:kode_program, :kode_sub_skpd) }
  end

  def kegiatan_opd(opd)
    program_kegiatans(opd)
      .uniq { |pk| pk.values_at(:kode_giat, :kode_sub_skpd) }
  end

  def subkegiatan_opd(opd)
    program_kegiatans(opd)
      .uniq { |pk| pk.values_at(:kode_sub_giat) }
  end

  def pelaksana_subkegiatan(opd)
    opd.users.eselon4
  end

  def program_kegiatans(opd)
    if @tahun.to_i < 2025
      ProgramKegiatan.where(kode_skpd: opd.kode_unik_opd)
                     .where.not(kode_skpd: [nil, ""])

    else
      pelaksana_subkegiatan(opd).flat_map do |user|
        user.sasarans
            .includes(:program_kegiatan)
            .where(tahun: @tahun)
            .where.not(program_kegiatans: { kode_skpd: [nil, ""] })
            .map(&:program_kegiatan)
      end.compact_blank
    end
  end
end
