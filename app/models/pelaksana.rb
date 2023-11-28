# get pelaksana strategi
class Pelaksana
  def initialize(strategi_id)
    @strategi_id = strategi_id
  end

  def strategi
    StrategiPohon.find(@strategi_id)
  end

  def id
    strategi.id
  end

  def role
    strategi.role
  end

  def cascading
    strategi.pohon_shareds.where.not(role: %w[opd opd-batal], user_id: nil).order(:user_id)
  end

  def daftar_terpilih
    cascading.pluck(:opd_id)
  end
end
