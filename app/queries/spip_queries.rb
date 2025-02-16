class SpipQueries
  extend Memoist

  attr_accessor :tujuan_kota, :tahun, :opd

  def initialize(tujuan_kota, tahun: '', opd: '')
    @tujuan_kota = tujuan_kota
    @tahun = tahun
    @opd = opd
    # change to query pattern later after test
  end

  def pohon_kinerja(kode_opd:)
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
    Visi.by_periode(@tahun)
  end

  def misi_kota(visi)
    visi.misis
  end

  def informasi_umum_sasaran_kota
    visi_kota.transform_values do |visi|
      misi_kota(visi).transform_values do |tujuans_m|
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
      strategi_pohon.sasarans.dengan_nip.where(tahun: @tahun) if strategi_pohon.opd == opd
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

  def spip_sasaran_opd # rubocop:disable Metrics
    pokin = pohon_kinerja(kode_opd: @opd.kode_unik_opd)
    strategic = pokin.strategi_opd.map { |str| str.sasarans.dengan_nip.where(tahun: @tahun) }.flatten
    tactical = pokin.tactical_opd.map { |str| str.sasarans.dengan_nip.where(tahun: @tahun) }.flatten
    operational = pokin.operational_opd.map { |str| str.sasarans.dengan_nip.where(tahun: @tahun) }.flatten
    {
      opd: opd.nama_opd,
      strategic: strategic,
      tactical: tactical,
      operational: operational
    }
  end
end
