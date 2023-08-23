module StrategisHelper
  def strategi_garis(strategis, selected)
    options_for_select(strategis.map { |str| [str.strategi, str.strategi] }, selected: selected)
  end
end
