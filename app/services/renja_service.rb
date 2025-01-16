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
    items = program_kegiatans.map do |pr|
      { jenis: 'sub_opd',
        parent: pr.kode_skpd,
        kode_opd: pr.kode_sub_skpd,
        kode: pr.kode_sub_skpd,
        nama: pr.nama_opd_pemilik,
        pagu: 0 }
    end
    items.uniq { |pk| pk.values_at(:kode) }.sort_by { |pk| pk.values_at(:kode) }
  end

  def urusan_opd
    items = program_kegiatans.map do |pr|
      { jenis: 'urusan',
        parent: pr.kode_urusan,
        kode_opd: pr.kode_sub_skpd,
        kode: pr.kode_urusan,
        nama: pr.nama_urusan,
        pagu: 0 }
    end
    items.uniq { |pk| pk.values_at(:kode) }.sort_by { |pk| pk.values_at(:kode) }
  end

  def bidang_urusan_opd
    items = program_kegiatans.map do |pr|
      { jenis: 'bidang_urusan',
        parent: pr.kode_urusan,
        kode_opd: pr.kode_sub_skpd,
        kode: pr.kode_bidang_urusan,
        nama: pr.nama_bidang_urusan,
        pagu: 0 }
    end
    items.uniq { |pk| pk.values_at(:kode) }.sort_by { |pk| pk.values_at(:kode) }
  end

  def program_renja
    items = program_kegiatans.map do |pr|
      { jenis: 'program',
        parent: pr.kode_bidang_urusan,
        kode_opd: pr.kode_sub_skpd,
        kode: pr.kode_program,
        nama: pr.nama_program,
        indikators: indikators(pr.kode_program, 'Program', pr.kode_sub_skpd),
        pagu: 0 }
    end
    items.uniq { |pk| pk.values_at(:kode, :kode_opd) }.sort_by { |pk| pk.values_at(:kode) }
  end

  def kegiatan_renja
    items = program_kegiatans.map do |pr|
      { jenis: 'kegiatan',
        parent: pr.kode_program,
        kode_opd: pr.kode_sub_skpd,
        kode: pr.kode_giat,
        nama: pr.nama_kegiatan,
        indikators: indikators(pr.kode_giat, 'Kegiatan', pr.kode_sub_skpd),
        pagu: 0 }
    end
    items.uniq { |pk| pk.values_at(:kode, :kode_opd) }.sort_by { |pk| pk.values_at(:kode) }
  end

  def subkegiatan_renja
    items = program_kegiatans.map do |pr|
      { jenis: 'subkegiatan',
        parent: pr.kode_giat,
        kode_opd: pr.kode_skpd,
        kode_sub_opd: pr.kode_sub_skpd,
        kode_urusan: pr.kode_urusan,
        kode_bidang_urusan: pr.kode_bidang_urusan,
        kode_program: pr.kode_program,
        kode_kegiatan: pr.kode_giat,
        kode: pr.kode_sub_giat,
        kode_tweak: kode_tweak(pr.kode_sub_giat),
        nama: pr.nama_subkegiatan,
        indikators: indikators(pr.kode_sub_giat, 'Subkegiatan', pr.kode_sub_skpd),
        pagu: pagu_subkegiatan(pr.kode_sub_giat, pr.kode_sub_skpd) }
    end
    if sub_opd.size > 1
      items.uniq { |pk| pk.values_at(:kode_sub_opd, :kode) }.sort_by { |pk| pk.values_at(:kode_tweak, :kode_sub_opd) }
    else
      items.uniq { |pk| pk.values_at(:kode) }.sort_by { |pk| pk.values_at(:kode_tweak) }
    end
  end

  def kode_tweak(kode) # khusus subkegiatan
    if kode.scan(/\d+$/).last.size == 2
      kode.gsub(/[.](?!.*[.])/, ".00\\1")
    else
      kode
    end
  end

  def pagu_subkegiatan(kode_subkegiatan, kode_opd)
    case @jenis
    when 'ranwal'
      pagu_ranwal(kode_subkegiatan, kode_opd)
    when 'rancangan'
      pagu_rancangan(kode_subkegiatan, kode_opd)
    when 'rankir'
      pagu_rankir(kode_subkegiatan, kode_opd)
    else
      0
    end
  end

  def pagu_ranwal(kode, kode_opd)
    Indikator.where(jenis: "Renstra",
                    sub_jenis: "Subkegiatan",
                    tahun: @tahun,
                    kode: kode,
                    kode_opd: kode_opd)
             .max_by(&:version)
             &.pagu.to_i
  end

  def pagu_rancangan(kode, kode_opd)
    ProgramKegiatan.where(kode_sub_giat: kode, kode_sub_skpd: kode_opd).map do |sub|
      sub.sasarans.includes(%i[indikator_sasarans])
         .where(tahun: @tahun, keterangan: nil)
         .filter_map(&:total_anggaran_rankir_1).sum
    end.sum
  end

  def pagu_rankir(kode, kode_opd)
    pelaksana_subkegiatan.flat_map do |user|
      user.sasarans
          .joins(:program_kegiatan)
          .includes(%i[anggarans])
          .where(tahun: @tahun, program_kegiatans: { kode_sub_giat: kode, kode_sub_skpd: kode_opd })
          .where.not(indikator_sasarans: [nil, ""])
          .where.not(program_kegiatans: { kode_skpd: [nil, ""] })
          .map { |s| s.anggarans.compact.sum(&:jumlah) }
    end.compact_blank.sum
  end

  def indikators(kode, jenis, opd)
    indikator = Indikator.where(jenis: "Renstra",
                                sub_jenis: jenis,
                                tahun: @tahun,
                                kode: kode,
                                kode_opd: opd)
                         .max_by(&:version)
    {
      indikator: indikator&.indikator,
      target: indikator&.target,
      satuan: indikator&.satuan
    }
  end
end
