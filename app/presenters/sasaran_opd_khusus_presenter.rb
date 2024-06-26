class SasaranOpdKhususPresenter
  def initialize(strategi:, tahun:)
    @strategi = strategi
    @tahun = tahun
  end

  def role
    @strategi.role
  end

  def renaksi
    if role == 'eselon_4'
      @strategi.sasaran_kinerja
    else
      @strategi.strategi
    end
  end

  def sub_pohons
    @strategi.strategi_bawahans
  end

  def programs
    # just eselon_3
    @strategi.strategi_bawahans.flat_map do |strategi|
      strategi.sasarans.map(&:program_kegiatan)
    end.compact_blank.reject { |prg| prg.nama_program =~ /PROGRAM PENUNJANG/ }
  end

  def opd
    @strategi.opd
  end

  def jenis
    @strategi.role
  end
end
