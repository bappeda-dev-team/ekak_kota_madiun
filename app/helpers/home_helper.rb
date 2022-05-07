module HomeHelper
  def warna_sasaran(status_sasaran)
    row_color = {
      hangus: 'text-danger',
      blm_lengkap: 'text-warning',
      digunakan: 'text-success'
    }.freeze
    row_color[status_sasaran.to_sym]
  end
end
