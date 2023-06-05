module SpbesHelper
  def rowspan_spbe(spbes)
    sasaran_size = spbes.inject(0) do |sum, spbe|
      sum + spbe.sasaran.operational_objectives.length
    end
    spbes.size + sasaran_size + 1
  end
end
