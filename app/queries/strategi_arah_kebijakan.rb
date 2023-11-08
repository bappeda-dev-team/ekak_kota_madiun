class StrategiArahKebijakan
  extend Memoist

  attr_accessor :tahun, :kode_opd

  def initialize(tahun: '', kode_opd: )
    @tahun = tahun
    @kode_opd = kode_opd
    @opd = Opd.find_by(kode_unik_opd: kode_opd)
  end

  def opd
    @opd
  end

  def isu_strategis_opds
    @opd.isu_strategis_opds
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
end
