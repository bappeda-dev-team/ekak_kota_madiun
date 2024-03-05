class PaguService
  def initialize(tahun: '', jenis: 'ranwal')
    @tahun = tahun
    @jenis = jenis
  end

  def opds
    opd_resmi = Opd.opd_resmi
    @opds ||= opd_resmi.map do |opd|
      {
        nama: opd.nama_opd,
        kode: opd.kode_unik_opd
      }
    end
  end
end
