module SpbesHelper
  def rowspan_spbe(spbes)
    rincian_size = spbes.inject(0) do |sum, spbe|
      sum + spbe.spbe_rincians.length
    end
    spbes.size + rincian_size + 1
  end
end
