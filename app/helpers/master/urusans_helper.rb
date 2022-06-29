module Master::UrusansHelper
  def dropdown_urusan
    options_for_select(Master::Urusan.pluck(:tahun).uniq)
  end
end
