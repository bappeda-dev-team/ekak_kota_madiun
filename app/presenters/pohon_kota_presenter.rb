class PohonKotaPresenter
  attr_accessor :pohon

  delegate :id, :to_param, :metadata,
           to: :pohon
  def initialize(pohon, selected = nil)
    @pohon = pohon
    @selected = selected
  end

  def real
    @pohon
  end

  def parent
    @pohon.pohon_ref_id
  end

  def pohonable
    @pohon.instance_of?(Pohon) ? @pohon.pohonable : @pohon
  end

  def nama
    @pohon.pohonable_type.downcase.include?('tematik') ? @pohon.pohonable.tema : @pohon.pohonable
  end

  def strategi?
    @pohon.pohonable.instance_of?(Strategi) || @pohon.pohonable.instance_of?(StrategiPohon)
  end

  def hide_detail?
    strategi? ? 'detail d-none' : ''
  end

  def strategi
    pohonable.strategi
  rescue NoMethodError
    '-'
  end

  def type
    pohonable.type
  rescue NoMethodError
    "- #{@pohon.pohonable_type}"
  end

  def exists?
    pohonable.nil?
  end

  def keterangan
    jenis_tematiks = %w[Tematik SubTematik SubSubTematik]
    if @pohon.pohonable_type.in? jenis_tematiks
      @pohon.pohonable.keterangan
    else
      @pohon.keterangan
    end
  end

  def opd
    @pohon.opd.nama_opd
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
    case @pohon.role
    when 'strategi_pohon_kota'
      'eselon_2'
    when 'tactical_pohon_kota'
      'eselon_3'
    when 'operational_pohon_kota'
      'eselon_4'
    else
      @pohon.role
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

  def pagu
    sasarans = fetch_sasarans(@pohon, role)
    sasarans.sum(&:total_anggaran)
  rescue NoMethodError
    0
  end

  def fetch_sasarans(pohon, role)
    return [] unless pohon

    case role
    when 'pohon_kota'
      childs = deep_fetch(pohon, 4)
    when 'sub_pohon_kota'
      childs = deep_fetch(pohon, 3)
    when 'sub_sub_pohon_kota'
      childs = deep_fetch(pohon, 2)
    when 'eselon_2'
      childs = deep_fetch(pohon, 1)
    when 'eselon_3'
      childs = fetch_pohonable(pohon)
    when 'eselon_4'
      return pohon.pohonable&.sasarans&.select { |sas| sas.program_kegiatan.presence } || []
    else
      return []
    end

    childs.flat_map { |child| child.sasarans if child.respond_to?(:sasarans) }.compact_blank
  end

  def deep_fetch(pohon, depth)
    return [] if pohon.nil? || depth.zero?

    sub_pohons = if depth == 4 && @selected.present?
                   pohon.sub_pohons.where(id: @selected.to_i)
                 else
                   pohon.sub_pohons
                 end
    sub_pohons.flat_map do |sub|
      # Ensure `pohonable` is not nil before calling `.flat_map`
      next unless sub.respond_to?(:sub_pohons)

      # Fetch pohonable objects at each level
      pohonables = sub.sub_pohons.map(&:pohonable).compact_blank

      # Recursively go deeper
      pohonables + deep_fetch(sub, depth - 1)
    end.compact_blank
  end

  def fetch_pohonable(pohon)
    pohon.sub_pohons.map(&:pohonable).compact_blank
  end

  def program_pohon
    sasarans = sub_pohon_program_elements
    case role
    when 'eselon_2'
      sasarans.flat_map(&:program_kegiatan).uniq { |pk| pk.nama_urusan }
    when 'eselon_4'
      sasarans.flat_map(&:program_kegiatan).uniq { |pk| pk.nama_kegiatan }
    else
      sasarans.flat_map(&:program_kegiatan).uniq { |pk| pk.nama_program }
    end
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
    prefix = case @pohon.role
             when 'pohon_kota'
               'Tematik Kota'
             when 'sub_pohon_kota'
               'Sub-Tematik Kota'
             when 'sub_sub_pohon_kota'
               'Sub Sub-Tematik Kota'
             when 'strategi_pohon_kota'
               'Strategic'
             else
               @pohon.role.chomp("_pohon_kota")
             end
    prefix.titleize
  end

  def jenis
    prefix = @pohon.role.chomp("_pohon_kota")
    to_real_name_up(prefix)
  end

  def warna_pohon
    role_asli = @pohon.role.chomp("_kota")
    role_asli.dasherize
  end

  def indikators
    pohonable.indikators
  end

  def rencana_kinerjas
    return unless strategi?

    if @pohon.pohonable.instance_of?(StrategiPohon)
      @pohon.pohonable.sasarans.dengan_nip
    else
      @pohon.pohonable.strategi_pokin
    end
  end

  def komentars
    @pohon.komentars
  end

  def warna_row
    case @pohon.role
    when 'strategi_pohon_kota'
      'table-danger'
    when 'tactical_pohon_kota'
      'table-info'
    when 'operational_pohon_kota'
      'table-success'
    else
      'table-light'
    end
  end

  private

  def sub_pohon_program_elements
    case role
    when 'pohon_kota'
      childs = @pohon.sub_pohons.flat_map do |suba|
        suba.sub_pohons.flat_map do |subx|
          subx.sub_pohons.flat_map do |sub|
            sub.sub_pohons.flat_map { |suby| suby.sub_pohons.flat_map(&:pohonable) }.compact_blank
          end
        end
      end
      sasarans = childs.flat_map(&:sasarans).select { |sas| sas.program_kegiatan.presence }.compact_blank
    when 'sub_pohon_kota'
      childs = @pohon.sub_pohons.flat_map do |subx|
        subx.sub_pohons.flat_map do |sub|
          sub.sub_pohons.flat_map { |suby| suby.sub_pohons.flat_map(&:pohonable) }.compact_blank
        end
      end
      sasarans = childs.flat_map(&:sasarans).select { |sas| sas.program_kegiatan.presence }.compact_blank
    when 'sub_sub_pohon_kota'
      childs = @pohon.sub_pohons.flat_map do |sub|
        sub.sub_pohons.flat_map { |suby| suby.sub_pohons.flat_map(&:pohonable) }.compact_blank
      end
      sasarans = childs.flat_map(&:sasarans).select { |sas| sas.program_kegiatan.presence }.compact_blank
    when 'eselon_2'
      childs = @pohon.sub_pohons.flat_map { |sub| sub.sub_pohons.flat_map(&:pohonable) }.compact_blank
      sasarans = childs.flat_map(&:sasarans).select { |sas| sas.program_kegiatan.presence }.compact_blank
    when 'eselon_3'
      childs = @pohon.sub_pohons.flat_map(&:pohonable).compact_blank
      sasarans = childs.flat_map(&:sasarans).select { |sas| sas.program_kegiatan.presence }.compact_blank
    when 'eselon_4'
      sasarans = @pohon.pohonable.sasarans.select { |sas| sas.program_kegiatan.presence }.compact_blank
    end
    sasarans
  end

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
