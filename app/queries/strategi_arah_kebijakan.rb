class StrategiArahKebijakan
  extend Memoist

  attr_accessor :tahun, :kode_opd
  attr_reader :opd

  def initialize(tahun: '', kode_opd:)
    @tahun = tahun
    @kode_opd = kode_opd
    @opd = Opd.find_by(kode_unik_opd: kode_opd)
  end

  def tahun_tanpa_perubahan
    tahun.gsub('_perubahan', '')
  rescue NoMethodError
    ''
  end

  def isu_strategis_opds
    @opd.isu_strategis_opds.where(tahun: [@tahun, tahun_tanpa_perubahan])
  end

  def tujuan_opds
    @opd.tujuan_opds
  end

  def pokin_opd
    PohonKinerjaOpdQueries.new(tahun: @tahun, kode_opd: @kode_opd)
  end

  def strategi_opds
    pokin_opd.strategi_opd
  end

  def tactical_opds
    pokin_opd.tactical_opd
  end

  def tujuan_strategi_opds
    strategi_opds.group_by { |st_opd| st_opd.tujuan }
  end
end
