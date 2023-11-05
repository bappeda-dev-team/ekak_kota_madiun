module JabatansHelper
  def option_jabatans(tahun_asli)
    Jabatan.where(tahun: tahun_asli).pluck(:nama_jabatan, :id_jabatan)
  end
end
