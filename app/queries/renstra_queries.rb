class RenstraQueries
  def initialize(kode_opd: '', tahun_awal: '', tahun_akhir: '', jenis_periode: 'RPJMD')
    @kode_opd = kode_opd
    @tahun_awal = tahun_awal
    @tahun_akhir = tahun_akhir
    @jenis_periode = jenis_periode
  end

  def periode
    @periode ||= (@tahun_awal..@tahun_akhir)
  end

  def opd
    Opd.find_by(kode_unik_opd: @kode_opd)
  end

  def opd_induk
    { jenis: 'opd',
      parent: @kode_opd,
      kode_opd: opd.kode_unik_opd,
      kode: opd.kode_unik_opd,
      nama: opd.nama_opd,
      pagu: 0 }
  end

  def program_kegiatan_renstra
    { opd: opd_induk,
      sub_opd: sub_opd,
      urusan: urusan_opd,
      bidang_urusan: bidang_urusan_opd,
      program: programs,
      kegiatan: kegiatans,
      subkegiatan: subkegiatans }
  end

  def pelaksana_subkegiatan
    opd.users.eselon4
  end

  def program_kegiatans
    @program_kegiatans ||= if @tahun_awal.to_i < 2025
                             ProgramKegiatan.where(kode_skpd: @kode_opd)
                                            .where.not(kode_skpd: [nil, ""])

                           else
                             # mencari program kegiatan yang digunakan
                             # dalam sasaran kinerja
                             # berlakau pada tahun 2025 ++
                             pelaksana_subkegiatan.flat_map do |user|
                               user.sasarans
                                   .includes(:program_kegiatan)
                                   .where(tahun: periode)
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

  def programs
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

  def kegiatans
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

  def subkegiatans
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
    if kode.scan(/\d+$/).last&.size == 2
      kode.gsub(/[.](?!.*[.])/, ".00\\1")
    else
      kode
    end
  end

  def pagu_subkegiatan(kode_subkegiatan, kode_opd)
    pagu_ranwal(kode_subkegiatan, kode_opd)
  end

  def indikator_renstra(kode, sub_jenis, opd, tahun)
    indikator_base = Indikator.where(jenis: "Renstra",
                                     sub_jenis: sub_jenis,
                                     tahun: tahun,
                                     kode: kode,
                                     kode_opd: opd)

    indikators = if tahun.to_i < 2025
                   indikator_base
                 else
                   indikator_base.where(sub_sub_jenis: [@jenis_periode, '', nil])
                 end
    indikators.max_by(&:version)
  end

  def rpd_any?(kode, sub_jenis, opd, tahun)
    Indikator.where(jenis: "Renstra",
                    sub_jenis: sub_jenis,
                    sub_sub_jenis: ['', 'RPD'],
                    tahun: tahun,
                    kode: kode,
                    kode_opd: opd)
             .max_by(&:version)
  end

  def pagu_ranwal(kode, kode_opd)
    periode.to_h do |tahun|
      indikator = indikator_renstra(kode, "Subkegiatan", kode_opd, tahun)
      [tahun, indikator&.pagu.to_i]
    end
  end

  def indikators(kode, jenis, opd)
    periode.to_h do |tahun|
      indikator = indikator_renstra(kode, jenis, opd, tahun)
      [tahun, {
        indikator: indikator&.indikator,
        target: indikator&.target,
        satuan: indikator&.satuan
      }]
    end
  end
end
