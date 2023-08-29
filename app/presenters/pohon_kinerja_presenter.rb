class PohonKinerjaPresenter
  attr_accessor :pohon

  delegate :id, :to_param, :metadata,
           to: :pohon
  def initialize(pohon)
    @pohon = pohon
  end

  def pohonable
    @pohon.instance_of?(Pohon) ? @pohon.pohonable : @pohon
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

  def element_class_name
    @pohon.role.dasherize
  end

  def title
    # suffix = @pohon.instance_of?(Pohon) ? '- Kota' : ''
    prefix = @pohon.role.chomp("_pohon_kota")
    if prefix.include?('eselon')
      to_real_name(prefix)
    else
      "#{to_real_name(prefix).capitalize} - Kota"
    end
  end

  def title_up
    # suffix = @pohon.instance_of?(Pohon) ? '- Kota' : ''
    prefix = @pohon.role.chomp("_pohon_kota")
    if prefix.include?('eselon')
      to_real_name_up(prefix)
    else
      "#{to_real_name_up(prefix).capitalize} - Kota"
    end
  end

  def jenis
    prefix = @pohon.role.chomp("_pohon_kota")
    to_real_name_up(prefix)
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
