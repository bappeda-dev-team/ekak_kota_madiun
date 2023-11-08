module TahunsHelper
  def selected_tahun(tahun)
    options_for_select([[tahun, tahun]], selected: tahun)
  end

  def tahun_without_perubahan(tahun)
    tahun.gsub('_perubahan', '')
  end
end
