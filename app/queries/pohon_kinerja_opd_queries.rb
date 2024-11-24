class PohonKinerjaOpdQueries
  extend Memoist

  attr_accessor :tahun, :kode_opd

  def initialize(tahun: '', kode_opd: '')
    @tahun = tahun
    @kode_opd = kode_opd
  end

  def opd
    Opd.find_by(kode_unik_opd: @kode_opd)
  end

  def pohon_opd
    StrategiPohon.where(opd_id: opd.id, tahun: @tahun)
                 .includes(:indikators, :opd, :pohon_shareds)
  end
  memoize :pohon_opd

  def pohon_kota
    Pohon.where(pohonable_type: 'Strategi',
                tahun: @tahun, opd_id: opd.id,
                status: [nil, '', 'diterima'])
         .includes(:pohonable, pohonable: [:indikator_sasarans])
  end
  memoize :pohon_kota

  def pohon_crosscutting
    Pohon.where(pohonable_type: 'StrategiPohon',
                tahun: @tahun, opd_id: opd.id,
                status: 'crosscutting')
         .includes(:pohonable, pohonable: [:indikators])
  end
  memoize :pohon_crosscutting

  # dynamic method
  # Define dynamic methods for each role
  %w[strategi tactical operational staff].each do |role|
    # kota
    define_method("#{role}_kota") do
      pohon_kota.rewhere(role: "#{role}_pohon_kota")
    end

    # opd
    define_method("#{role}_opd") do
      pohon_opd.rewhere(role: "eselon_#{role_index(role)}")
               .select { |pp| pp.deleted_at.nil? }
    end
  end

  # Alias method to pohon_crosscutting
  def strategi_crosscutting
    pohon_crosscutting
  end

  # only get the operational (with subkegiatan)
  def sasaran_operational_opd
    operational_opd.flat_map do |op|
      op.sasarans.includes(:program_kegiatan).dengan_rincian.where(tahun: @tahun)
    end
  end

  # pohon excluding staff
  def all_strategi_opd
    pohon_opd.rewhere(role: %w[eselon_2 eselon_3 eselon_4])
  end

  private

  def role_index(role)
    case role
    when 'strategi' then 2
    when 'tactical' then 3
    when 'operational' then 4
    when 'staff' then nil # Use nil or another index if staff doesn't follow the same pattern
    end
  end
end
