class StrategiArahKebijakan
  extend Memoist

  attr_accessor :kode_opd
  attr_reader :opd

  def initialize(kode_opd:, tahun_strategi: '')
    @tahun_strategi = tahun_strategi
    @kode_opd = kode_opd
    @opd = Opd.find_by(kode_unik_opd: kode_opd)
  end

  def tahun_tanpa_perubahan
    tahun = @tahun_strategi
    tahun.gsub('_perubahan', '') if tahun.include?('_perubahan')
  rescue NoMethodError
    ''
  end

  def tahun_murni(tahun)
    tahun.match(/murni|perubahan/) ? tahun[/[^_]\d*/, 0] : tahun
    "#{tahun}_murni"
  rescue NoMethodError
    ''
  end

  def isu_strategis_opds
    tahun_x = tahun_murni(@tahun_strategi)
    @opd.isu_strategis_opds.where(tahun: [@tahun_strategi, tahun_x])
  end

  def tujuan_opds
    @opd.tujuan_opds
  end

  def pokin_opd
    PohonKinerjaOpdQueries.new(tahun: @tahun_strategi, kode_opd: @kode_opd)
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
