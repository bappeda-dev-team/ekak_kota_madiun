class SpipQueries
  extend Memoist

  attr_accessor :tujuan_kota, :tahun, :opd

  def initialize(tujuan_kota, tahun: '', opd: '')
    @tujuan_kota = tujuan_kota
    @tahun = tahun
    @opd = opd
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

  def sasaran_opd
    strategi_kotas.select { |sk| sk.tahun.include?(@tahun) }.to_h do |strategi_kota|
      sasaran_opds = strategi_kota.opds.to_h do |opd|
        [opd.nama_opd, opd.strategi_eselon2.map(&:sasaran)]
      end
      [strategi_kota.sasaran_kotum_sasaran, sasaran_opds]
    end
  end

  def spip_sasaran_opd
    @opd.strategi_eselon2.where(tahun: @tahun).group_by(&:opd)
  end

  def strategi_kotas
    @tujuan_kota.sasarans.map(&:strategi_kota).flatten!
  end

  memoize :strategi_kotas
end
