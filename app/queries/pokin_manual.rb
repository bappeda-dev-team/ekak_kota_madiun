class PokinManual
  extend Memoist

  attr_accessor :tahun, :opd

  def initialize(tahun: '', opd: nil)
    @tahun = tahun
    @opd = opd
  end

  def opd_induk
    @opd.opd_induk
  end

  def strategi_kota
    opd_id = if opd_induk
               opd_induk.id
             else
               @opd.id
             end
    pohons = Pohon.where(opd_id: opd_id)
    pohons.map(&:pohonable).filter do |pohon|
      pohon.tahun.match(/#{@tahun}(\S*|\b)/)
    end
  end

  def id_opd_induk
    if opd_induk
      opd_induk.id
    else
      @opd.id
    end
  end

  def strategi_in_opd
    StrategiPohon.where(opd_id: id_opd_induk.to_s, tahun: @tahun)
  end

  def strategi_by_role
    strategi_in_opd.group_by(&:role)
  end

  def list_strategis
    strategi_by_role(strategi_in_specific_opd)
  end
end
