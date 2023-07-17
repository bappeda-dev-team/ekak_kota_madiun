class PokinQueries
  extend Memoist

  attr_accessor :tahun, :opd

  def initialize(tahun: '', opd: nil)
    @tahun = tahun
    @opd = opd
  end

  def users
    opd.users
  end

  def user_strategic
    users.includes(:strategis).eselon2
  end

  def strategic
    user_strategic.map { |user| strategi_user(user) }
  end

  def strategic_indikator
    strategic.flatten.map(&:indikator_sasarans)
  end

  def user_tactical
    users.eselon3
  end

  def tactical
    user_tactical.map { |user| strategi_user(user) }
  end

  def tactical_indikator
    tactical.flatten.map(&:indikator_sasarans)
  end

  def user_operational
    users.eselon4
  end

  def operational
    user_operational.map { |user| strategi_user(user) }
  end

  def operational_indikator
    operational.flatten.map(&:indikator_sasarans)
  end

  def user_operational2
    users.staff
  end

  def operational2
    user_operational2.map { |user| strategi_user(user) }
  end

  def operational2_indikator
    operational2.flatten.map(&:indikator_sasarans)
  end

  def data_total_pokin
    {
      strategic: strategic.count,
      strategic_indikator: strategic_indikator.count,

      tactical: tactical.count,
      tactical_indikator: tactical_indikator.count,

      operational: operational.count,
      operational_indikator: operational_indikator.count,

      operational2: operational2.count,
      operational2_indikator: operational2_indikator.count
    }
  end

  def strategi_user(user)
    user.strategis.where("COALESCE(tahun, '') ILIKE ?", "%#{@tahun}%")
  end

  def strategi_kota
    strategic.flatten.map(&:pohon)
  end

  def isu_strategis
    strategi_kota.flatten.map { |pohon| pohon.pohonable.isu }.uniq!
  end
end
