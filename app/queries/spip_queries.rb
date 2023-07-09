class SpipQueries
  attr_accessor :tujuan_kota, :opds

  def initialize(tujuan_kota, opds: nil)
    @tujuan_kota = tujuan_kota
    @opds = opds
  end

  def informasi_umum_sasaran_kota
    @tujuan_kota.visis.group_by(&:visi)
                .transform_values { |tujuans| tujuans.group_by(&:misi) }
  end

  def daftar_opd
    [@opds]
  end

  def sasaran_opd
    # sasaran pemda
    # opd
    # sasaran
    sasraran_pemda = @tujuan_kota.sasaran_kota
  end

  def spip_sasaran_opd; end
end
