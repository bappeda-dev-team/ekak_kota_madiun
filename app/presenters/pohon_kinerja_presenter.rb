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

  def exists?
    pohonable.nil?
  end

  def keterangan
    @pohon.instance_of?(Pohon) ? @pohon.keterangan : ''
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
    return unless @pohon.instance_of?(Pohon)

    @pohon.status? && @pohon.metadata.key?("processed_by")
  end

  def taken?
    return unless @pohon.instance_of?(StrategiPohon)

    @pohon.takens.any?
  end

  def takens
    return unless @pohon.instance_of?(StrategiPohon)

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
      "#{to_real_name(prefix).capitalize} - Kota"
    end
  end

  def title_up
    # suffix = @pohon.instance_of?(Pohon) ? '- Kota' : ''
    prefix = @pohon.role.chomp("_pohon_kota")
    if prefix.include?('eselon') || prefix.include?('staff')
      to_real_name_up(prefix)
    else
      "#{to_real_name_up(prefix).capitalize} - Kota"
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
    @pohon.pohon_shareds.where.not(role: %w[opd opd-batal], user_id: nil).order(:user_id)
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
