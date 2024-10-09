module JabatansHelper
  def option_jabatans
    Jabatan.pluck(:nama_jabatan, :id_jabatan)
  end

  def option_status_jabatans
    JabatanUser::STATUS_JABATAN_USER
  end
end
