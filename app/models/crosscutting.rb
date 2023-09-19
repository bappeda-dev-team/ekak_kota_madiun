# Get opd with shared strategi pohon
class Crosscutting
  attr_accessor :strategi

  def initialize(strategi_id)
    @strategi = StrategiPohon.find(strategi_id)
  end

  def opd_pemilik
    @strategi.opd
  end

  def external
    @strategi.pohon_shareds.where(role: 'opd').order(:opd_id)
  end
end
