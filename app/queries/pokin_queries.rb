class PokinQueries
  extend Memoist

  attr_accessor :tahun, :opd

  def initialize(tahun: '', opd: nil)
    @tahun = tahun
    @opd = opd
  end

  def users
    opd.users.includes(:strategis)
  end

  def opd_induk
    opd.opd_induk
  end

  def user_strategic
    if opd_induk
      opd_induk.users.eselon2
    else
      users.eselon2
    end
  end

  def strategic
    user_strategic.map { |user| strategi_user(user) }.flatten
  end

  def strategic_indikator
    strategic.flatten.map(&:indikator_sasarans)
  end

  def strategic_list_id
    strategic.pluck(:id)
  end

  def user_tactical2
    if opd_induk
      opd_induk.users.eselon2b
    else
      users.eselon2b
    end
  end

  def tactical2
    user_tactical2.map { |user| strategi_user(user) }.flatten
  end

  def tactical_indikator2
    tactical2.flatten.map(&:indikator_sasarans)
  end

  def user_tactical
    users.eselon3
  end

  def tactical
    user_tactical.map { |user| strategi_user(user) }.flatten
  end

  def tactical_susun
    tactical.select do |tact|
      strategic_list_id.include?(tact.strategi_ref_id.to_i)
    end
  end

  def tactical_indikator
    tactical.flatten.map(&:indikator_sasarans)
  end

  def tactical_list_id
    tactical.pluck(:id)
  end

  def user_operational
    users.eselon4
  end

  def operational
    user_operational.map { |user| strategi_user(user) }.flatten
  end

  def operational_indikator
    operational.flatten.map(&:indikator_sasarans)
  end

  def operational_susun
    operational.select do |oper|
      tactical_list_id.include?(oper.strategic_ref_id.to_i)
    end
  end

  def operational_list_id
    operational.pluck(:id)
  end

  def user_operational2
    users.staff
  end

  def operational2
    user_operational2.map { |user| strategi_user(user) }.flatten
  end

  def operational2_indikator
    operational2.flatten.map(&:indikator_sasarans)
  end

  def operational2_susun
    operational2.select do |oper2|
      operational_list_id.include?(oper2.strategic_ref_id.to_i)
    end
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
    # broken
    if opd_induk
      opd_induk.strategic.uniq!
    else
      strategic.flatten.map(&:pohon)
    end
  end

  def isu_strategis
    if opd_induk
      opd_induk.isu_strategis_pohon(@tahun)
    else
      strategi_kota.flatten.map { |pohon| pohon.pohonable.isu }.uniq!
    end
  end
end
