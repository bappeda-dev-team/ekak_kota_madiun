class PohonKinerjaPresenter
  attr_accessor :pohon

  delegate :id, :to_param, :metadata,
           to: :pohon
  def initialize(pohon)
    @pohon = pohon
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
        @pohon.status == 'diterima' ? 'pohon-accepted' : 'pohon-rejected'
      else
        ''
      end
    else
      ''
    end
  end

  def processed?
    return false unless @pohon.instance_of?(Pohon)

    @pohon.status? && @pohon.metadata.key?("processed_by")
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
  end

  def diproses_pada
    @pohon.metadata["processed_at"].to_datetime
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

    @pohon.pohon_shareds.where.not(role: %w[opd opd-batal], user_id: nil).order(:user_id)
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
    else
      'Operational'
    end
  end
end
