class PaguService
  def initialize(tahun: '', jenis: 'ranwal')
    @tahun = tahun
    @jenis = jenis
  end

  def opds
    @opds ||= Opd.opd_resmi
  end
end
