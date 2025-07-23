class PohonKinerjaPresenter
  attr_accessor :pohon

  delegate :id, :to_param, :metadata,
           to: :pohon
  def initialize(pohon)
    @pohon = pohon
  end

  def pohon_id
    @pohon.instance_of?(Pohon) ? @pohon.pohonable : @pohon
  end

  def real
    @pohon
  end

  def pohonable
    @pohon.instance_of?(Pohon) ? @pohon.pohonable : @pohon
  end

  def type
    real.class.name
  end

  def parent_type
    real.parent_pohon
  end

  def parent_pohon
    real.parent_pohon.pohonable
  end

  def parent_parent_type
    parent_type.parent_pohon
  end

  def parent_parent_pohon
    parent_type.parent_pohon.pohonable
  end

  def parent_parent_parent_type
    parent_parent_type.parent_pohon
  end

  def parent_parent_parent_pohon
    parent_parent_type.parent_pohon.pohonable
  end

  def exists?
    pohonable.nil?
  end

  def keterangan
    @pohon.keterangan
  end

  def tombol_partial
    @pohon.instance_of?(Pohon) ? 'pohon_kinerja/item_pohon_tombol' : 'pohon_kinerja/item_pohon_tombol_opd'
  end

  def tombol_foot
    @pohon.instance_of?(Pohon) ? 'pohon_kinerja/item_pohon_foot' : 'pohon_kinerja/item_pohon_foot_opd'
  end

  def status
    if @pohon.instance_of?(Pohon)
      if @pohon.status?
        case @pohon.status
        when 'diterima'
          processed? && 'pohon-accepted'
        when 'crosscutting'
          'pohon-crosscutting'
        else
          'pohon-rejected'
        end
      else
        ''
      end
    else
      ''
    end
  end

  def processed?
    return false unless @pohon.instance_of?(Pohon)

    strategi = @pohon.strategi_dari_kota_finder

    strategi.present? && strategi.role != 'deleted'
  end

  def taken?
    return false unless @pohon.instance_of?(StrategiPohon)

    @pohon.takens.any?
  end

  def takens
    return false unless @pohon.instance_of?(StrategiPohon)

    @pohon.takens
  end

  def diproses_oleh
    User.find(@pohon.metadata["processed_by"])
  rescue ActiveRecord::RecordNotFound
    'user-tidak-ditemukan'
  end

  def diproses_pada
    @pohon.metadata["processed_at"].to_datetime
  rescue NoMethodError
    Time.now
  end

  def keterangan_proses
    @pohon.metadata["keterangan"]
  end

  def status_ket
    @pohon.status.titleize
  end

  def role
    @pohon.role
  end

  def role_atasan
    case role
    when 'eselon_3'
      'eselon_2'
    when 'eselon_4'
      'eselon_3'
    when 'staff'
      'eselon_4'
    else
      ''
    end
  end

  def role_pohon_atas
    case role
    when 'eselon_3', 'tactical_pohon_kota'
      %w[eselon_2 strategi_pohon_kota]
    when 'eselon_4', 'operational_pohon_kota'
      %w[eselon_3 tactical_pohon_kota]
    when 'staff'
      'eselon_4'
    else
      ''
    end
  end

  def role_bawahan
    case role
    when 'eselon_2'
      'eselon_3'
    when 'eselon_3'
      'eselon_4'
    else
      'staff'
    end
  end

  def judul_form
    case role_bawahan
    when 'eselon_3'
      'Tactical'
    when 'eselon_4'
      'Operational'
    else
      'Operational - n'
    end
  end

  def element_class_name
    @pohon.role.dasherize
  end

  def title
    # suffix = @pohon.instance_of?(Pohon) ? '- Kota' : ''
    prefix = @pohon.role.chomp("_pohon_kota")
    if prefix.include?('eselon') || prefix.include?('staff')
      to_real_name(prefix)
    else
      "#{to_real_name(prefix).capitalize}"
    end
  end

  def title_up
    # suffix = @pohon.instance_of?(Pohon) ? '- Kota' : ''
    prefix = @pohon.role.chomp("_pohon_kota")
    if prefix.include?('eselon') || prefix.include?('staff')
      to_real_name_up(prefix)
    elsif @pohon.role == 'opd'
      "#{to_real_name_up(prefix).capitalize} - OPD"
    else
      "#{to_real_name_up(prefix).capitalize} - Dari Kota"
    end
  end

  def jenis
    prefix = @pohon.role.chomp("_pohon_kota")
    to_real_name_up(prefix)
  end

  def crosscuttings
    return [] if @pohon.instance_of?(Pohon)

    ctx = Crosscutting.new(@pohon.id)
    ctx.external
  rescue NoMethodError
    []
  end

  def pelaksana
    return [] if @pohon.instance_of?(Pohon)

    @pohon.pohon_shareds.where.not(role: %w[opd opd-batal], user_id: nil).order(:user_id).limit(50)
  rescue NoMethodError
    []
  end

  def dibagikans
    # return unless @pohon.instance_of?(StrategiPohon)

    @pohon.pohon_shareds
  rescue NoMethodError
    []
  end

  def warna_pohon
    case @pohon.role
    when 'eselon_2'
      'strategic-pohon'
    when 'eselon_3'
      'tactical-pohon'
    when 'eselon_4'
      'operational-pohon'
    else
      'staff-pohon'
    end
  end

  def indikators
    pohonable.indikators
  end

  def rencana_kinerjas
    return false if @pohon.instance_of?(Pohon)

    @pohon.sasarans.dengan_nip
  end

  def rencana_kinerja_subkegiatans
    rencana_kinerjas.group_by(&:program_kegiatan)
  end

  def pohon_kota
    return unless type != 'Pohon'

    @pohon.strategi_asli.role.include?('kota') ? '- Dari Kota' : ''
  rescue StandardError
    ''
  end

  def dari_kota?
    title_up&.include?('Kota')
  rescue NoMethodError
    false
  end

  def pohon_kota_id
    return unless type != 'Pohon'

    @pohon.strategi_asli.role.include?('kota') ? @pohon.strategi_cascade_link : ''
  rescue StandardError
    ''
  end

  def reviews
    pohonable.reviews
  end

  def child_inovasi
    if role == 'eselon_2'
      pohonable.strategi_bawahans.flat_map do |chl|
        chl.strategi_bawahans.flat_map do |stra|
          sasaran_inovasi(stra)
        end
      end
    elsif role == 'eselon_3'
      pohonable.strategi_bawahans.flat_map do |stra|
        sasaran_inovasi(stra)
      end
    else
      sasaran_inovasi(pohonable)
    end
  end

  def sasaran_inovasi(strategi)
    strategi.sasarans.select { |ss| ss.hasil_inovasi_sasaran == 'Inovasi' }
  end

  # recursion baby
  def parent_tematik_aktif?(pohon_target)
    if pohon_target.role == 'pohon_kota'
      !pohon_target.is_active
    else
      parent_tematik_aktif?(pohon_target.parent_pohon)
    end
  rescue NoMethodError
    false
  end

  def indikator_users
    ind_users = pelaksana.to_h do |pl|
      [pl.user, pl.user.indikators.by_strategi_id(real.id)]
    end
    ind_users.select { |_, inds| inds.any? }
  end

  private

  def to_real_name(role)
    if %w[strategi eselon_2].include?(role)
      'Tactical'
    else
      'Operational'
    end
  end

  def to_real_name_up(role)
    if %w[strategi eselon_2].include?(role)
      'Strategic'
    elsif %w[tactical eselon_3].include?(role)
      'Tactical'
    elsif %w[opd].include?(role)
      'Crosscutting'
    else
      'Operational'
    end
  end
end
