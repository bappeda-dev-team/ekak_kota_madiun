class RenjaService
  def initialize(kode_opd: '', tahun: '', jenis: 'ranwal')
    @kode_opd = kode_opd
    @tahun = tahun
    @jenis = jenis
  end

  def opd
    Opd.find_by(kode_unik_opd: @kode_opd)
  end

  def program_kegiatan_renja
    { sub_opd: sub_opd,
      urusan: urusan_opd,
      bidang_urusan: bidang_urusan_opd,
      program: program_renja,
      kegiatan: kegiatan_renja,
      subkegiatan: subkegiatan_renja }
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

  def sub_opd
    program_kegiatans.map do |pr|
      { jenis: 'sub_opd',
        parent: pr.kode_skpd,
        kode_opd: pr.kode_sub_skpd,
        kode: pr.kode_sub_skpd,
        nama: pr.nama_opd_pemilik,
        pagu: 0 }
    end.uniq { |pk| pk[:kode] }
  end

  def urusan_opd
    program_kegiatans.map do |pr|
      { jenis: 'urusan',
        parent: pr.kode_urusan,
        kode_opd: pr.kode_sub_skpd,
        kode: pr.kode_urusan,
        nama: pr.nama_urusan,
        pagu: 0 }
    end.uniq { |pk| pk[:kode] }
  end

  def bidang_urusan_opd
    program_kegiatans.map do |pr|
      { jenis: 'bidang_urusan',
        parent: pr.kode_urusan,
        kode_opd: pr.kode_sub_skpd,
        kode: pr.kode_bidang_urusan,
        nama: pr.nama_bidang_urusan,
        pagu: 0 }
    end.uniq { |pk| pk[:kode] }
  end

  def program_renja
    program_kegiatans.map do |pr|
      { jenis: 'program',
        parent: pr.kode_bidang_urusan,
        kode_opd: pr.kode_sub_skpd,
        kode: pr.kode_program,
        nama: pr.nama_program,
        pagu: 0 }
    end.uniq { |pk| pk[:kode] }
  end

  def kegiatan_renja
    program_kegiatans.map do |pr|
      { jenis: 'kegiatan',
        parent: pr.kode_program,
        kode_opd: pr.kode_sub_skpd,
        kode: pr.kode_giat,
        nama: pr.nama_kegiatan,
        pagu: 0 }
    end.uniq { |pk| pk[:kode] }
  end

  def subkegiatan_renja
    program_kegiatans.map do |pr|
      { jenis: 'subkegiatan',
        parent: pr.kode_giat,
        kode_opd: pr.kode_skpd,
        kode_sub_opd: pr.kode_sub_skpd,
        kode_urusan: pr.kode_urusan,
        kode_bidang_urusan: pr.kode_bidang_urusan,
        kode_program: pr.kode_program,
        kode_kegiatan: pr.kode_giat,
        kode: pr.kode_sub_giat,
        nama: pr.nama_subkegiatan,
        pagu: pr.anggaran_sasarans(@tahun) }
    end.uniq { |pk| pk[:kode] }
  end

  def pagu_subkegiatan(kode_subkegiatan)
    case @jenis
    when 'ranwal'
      pagu_ranwal(kode_subkegiatan)
    when 'rancangan'
      pagu_rancangan(kode_subkegiatan)
    when 'rankir'
      program_kegiatans.sum { |pk| pk.anggaran_sasarans(@tahun) }
    else
      0
    end
  end

  def pagu_ranwal(kode)
    Indikator.where(jenis: "Renstra",
                    sub_jenis: "Subkegiatan",
                    tahun: @tahun,
                    kode: kode,
                    kode_opd: @kode_opd)
             .max_by(&:version)
             .pagu.to_i
  end

  def pagu_rancangan(kode)
    PaguAnggaran.where(jenis: 'RankirGelondong',
                       tahun: @tahun,
                       kode: kode,
                       kode_opd: @kode_opd)
                .sum(:anggaran)
  end
end
