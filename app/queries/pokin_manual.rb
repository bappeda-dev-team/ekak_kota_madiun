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

  def id_opd_induk
    if opd_induk
      opd_induk.id
    else
      @opd.id
    end
  end
  memoize :id_opd_induk

  def strategi_in_opd
    StrategiPohon.where(opd_id: id_opd_induk.to_s, tahun: @tahun)
  end
  memoize :strategi_in_opd

  def strategi_by_role
    strategi_in_opd.group_by(&:role)
  end

  def list_strategis
    strategi_by_role(strategi_in_specific_opd)
  end

  def strategis_pohon
    strategi_kepala = strategi_by_role['eselon_2']
    strategi_kepala.map(&:pohon).uniq.group_by(&:isu_strategis_disasar)
  rescue StandardError
    { "Belum Terisi" => [] }
  end

  def jumlah
    strategi_in_opd.select(%i[id role]).unscope(:order).group(:role).count(:id)
  end
end
