module JenisJabatansHelper
  def dropdown_jenis_jabatan(_tahun, selected: '')
    options_for_select(JenisJabatan.pluck(:nama_jenis, :id), selected)
  end
end
