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

  def strategi_kota
    pohon_kota.rewhere(role: 'strategi_pohon_kota')
  end

  def tactical_kota
    pohon_kota.rewhere(role: 'tactical_pohon_kota')
  end

  def operational_kota
    pohon_kota.rewhere(role: 'operational_pohon_kota')
  end

  def strategi_opd
    pohon_opd.rewhere(role: 'eselon_2')
  end

  def tactical_opd
    pohon_opd.rewhere(role: 'eselon_3')
  end

  def operational_opd
    pohon_opd.rewhere(role: 'eselon_4')
  end

  def staff_opd
    pohon_opd.rewhere(role: 'staff')
  end

  def strategi_crosscutting
    pohon_crosscutting
  end

  def all_strategi_opd
    pohon_opd.rewhere(role: %w[eselon_2 eselon_3 eselon_4])
  end
end
