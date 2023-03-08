module HomeHelper
  def warna_sasaran(status_sasaran)
    row_color = {
      hangus: 'text-danger',
      blm_lengkap: 'text-warning',
      krg_lengkap: 'text-info',
      digunakan: 'text-success',
      siap_ditarik: 'text-success',
    }.freeze
    row_color[status_sasaran.to_sym]
  end

  def bg_sasaran(status_sasaran)
    row_color = {
      hangus: 'bg-danger',
      blm_lengkap: 'bg-warning',
      digunakan: 'bg-success',
      siap_ditarik: 'bg-success',
    }.freeze
    row_color[status_sasaran.to_sym]
  end
end
