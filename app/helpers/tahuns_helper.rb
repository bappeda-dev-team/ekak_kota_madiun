module TahunsHelper
  def selected_tahun(tahun)
    options_for_select([[tahun, tahun]], selected: tahun)
  end
end
