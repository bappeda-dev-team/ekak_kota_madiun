module JabatansHelper
  def option_jabatans
    Jabatan.pluck(:nama_jabatan, :id_jabatan)
  end
end
