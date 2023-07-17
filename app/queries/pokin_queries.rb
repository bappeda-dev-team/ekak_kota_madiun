class PokinQueries
  extend Memoist

  attr_accessor :tahun, :opd

  def initialize(tahun: '', opd: nil)
    @tahun = tahun
    @opd = opd
  end

  def users
    @opd.users.includes(:strategis)
  end

  def opd_induk
    @opd.opd_induk
  end

  def user_strategic
    if opd_induk
      opd_induk.users.eselon2
    else
      users.eselon2
    end
  end

  def user_tactical2
    if opd_induk
      opd_induk.users.eselon2b
    else
      users.eselon2b
    end
  end

  def user_tactical
    users.eselon3
  end

  def user_operational
    users.eselon4
  end

  def user_operational2
    users.staff
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

  def tactical2
    user_tactical2.map { |user| strategi_user(user) }.flatten
  end

  def tactical_indikator2
    tactical2.flatten.map(&:indikator_sasarans)
  end

  def tactical2_list_id
    tactical2.pluck(:id)
  end

  def tactical2_susun
    tactical2.select do |tact2|
      strategic_list_id.include?(tact2.strategi_ref_id.to_i)
    end
  end

  def tactical
    user_tactical.map { |user| strategi_user(user) }.flatten
  end

  def tactical_indikator
    tactical.flatten.map(&:indikator_sasarans)
  end

  def tactical_list_id
    tactical.pluck(:id)
  end

  def tactical_susun
    strategic_list = if opd_induk
                       tactical2_list_id
                     else
                       strategic_list_id
                     end
    tactical.select do |tact|
      strategic_list.include?(tact.strategi_ref_id.to_i)
    end
  end

  def operational
    user_operational.map { |user| strategi_user(user) }.flatten
  end

  def operational_indikator
    operational.flatten.map(&:indikator_sasarans)
  end

  def operational_list_id
    operational.pluck(:id)
  end

  def operational_susun
    operational.select do |oper|
      tactical_list_id.include?(oper.strategi_ref_id.to_i)
    end
  end

  def operational2
    user_operational2.map { |user| strategi_user(user) }.flatten
  end

  def operational2_indikator
    operational2.flatten.map(&:indikator_sasarans)
  end

  def operational2_susun
    operational2.select do |oper2|
      operational_list_id.include?(oper2.strategi_ref_id.to_i)
    end
  end

  def operational2_list_id
    operational2.pluck(:id)
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

  def isu_strategis
    strategi_kota.map(&:isu)
  end
end
