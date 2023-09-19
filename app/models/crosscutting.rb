# Get opd with shared strategi pohon
class Crosscutting
  attr_accessor :strategi

  def initialize(strategi_id)
    @strategi = StrategiPohon.find(strategi_id)
  end

  def id
    @strategi.id
  end

  def opd_pemilik
    @strategi.opd
  end

  def kode_opd_pemilik
    opd_pemilik.kode_unik_opd
  end

  def external
    @strategi.pohon_shareds.where(role: 'opd').order(:opd_id)
  end

  def daftar_terpilih
    @strategi.pohon_shareds.where(role: 'opd').pluck(:opd_id)
  end
end
