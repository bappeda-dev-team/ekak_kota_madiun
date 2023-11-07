class SpipQueries
  extend Memoist

  attr_accessor :tujuan_kota, :tahun, :opd

  def initialize(tujuan_kota, tahun: '', opd: '')
    @tujuan_kota = tujuan_kota
    @tahun = tahun
    @opd = opd
    # change to query pattern later after test
  end

  def pohon_kinerja(kode_opd: )
    PohonKinerjaOpdQueries.new(kode_opd: kode_opd, tahun: @tahun)
  end

  def strategi_kotas
    @tujuan_kota.sasarans.map(&:strategi_kota).flatten!
  end
  memoize :strategi_kotas

  def opd_khusus
    [145]
  end

  def tahun_murni
    @tahun.include?('murni') ? @tahun[/[^_]\d*/, 0] : @tahun
  end

  def tahun_perubahan
    @tahun.include?('perubahan') ? @tahun[/[^_]\d*/, 0] : @tahun
  end

  def visi_kota
    @tujuan_kota.visis.group_by(&:visi)
  end

  def misi_kota(tujuans)
    tujuans.group_by(&:misi)
  end

  def informasi_umum_sasaran_kota
    visi_kota.transform_values do |tujuans|
      misi_kota(tujuans).transform_values do |tujuans_m|
        tujuans_m.to_h do |tujuan|
          [tujuan, tujuan.sasaran_kota]
        end
      end
    end
  end

  def daftar_opd
    strategi_kotas.map do |strategi_kota|
      strategi_kota.opds.select(:nama_opd)
    end.flatten.uniq(&:nama_opd)
  end

  def mapper_strategi_kota_opd(opd)
    pokin = pohon_kinerja(kode_opd: opd.kode_unik_opd)
    pokin_strategi = pokin.strategi_opd.filter_map do |strategi_pohon|
      # map strategi_pohon to sasarans
      strategi_pohon.sasarans.dengan_nip if strategi_pohon.opd == opd
    end
    pokin_strategi.flatten
  end

  def sasaran_opd
    strategi_kotas.select { |sk| sk.tahun.include?(tahun_perubahan) }.to_h do |strategi_kota|
      sasaran_opds = strategi_kota.opds.to_h do |opd|
        [opd.nama_opd, mapper_strategi_kota_opd(opd)]
      end
      [strategi_kota.sasaran_kotum_sasaran, sasaran_opds]
    end
  end

  def spip_sasaran_opd
    # example of dependency injection (PokinQueries)
    if @opd.id.in?(opd_khusus)
      # @opd.strategi_eselon2b.where(tahun: @tahun).group_by(&:opd)
      @pokin.tactical2.group_by(&:opd)
    else
      # @opd.strategi_eselon2.where(tahun: @tahun).group_by(&:opd)
      @pokin.strategic.group_by(&:opd)
    end
    # strategis = @pokin.strategi_in_specific_opd
    # grouping = @pokin.strategi_by_role(strategis)
    # eselon3 = grouping["eselon_3"]
    # tactical2 = eselon3.map(&:strategi_atasan)
    # @pokin.tactical2.group_by(&:opd)
  end
end
