module JenisJabatansHelper
  def dropdown_jenis_jabatan(tahun)
    options_for_select(JenisJabatan.where(tahun: tahun).pluck(:nama_jenis, :id))
  end
end
