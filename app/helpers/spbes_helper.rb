module SpbesHelper
  def rowspan_spbe(spbes)
    rincian_size = spbes.inject(0) do |sum, spbe|
      indikators = spbe.spbe_rincians.flat_map do |rin|
        rin.sasaran.present? ? rin.sasaran.indikator_sasarans.size : 0
      end.sum
      rincian = spbe.spbe_rincians.size
      sum + rincian + indikators
    end
    spbes.size + rincian_size + 1
  end

  def rowspan_left_spbes(spbes)
    spbes.inject(0) do |sum, spbe|
      sasarans = spbe.spbe_rincians.flat_map { |rincian| rowspan_sasaran_spbe(rincian.sasaran) }.sum
      sum + rowspan_left_spbe(spbe) + sasarans
    end
  end

  def rowspan_left_spbe(spbe)
    spbe.spbe_rincians.size + 1
  end

  def rowspan_rincian_spbe(spbe_rincians)
    rincians = spbe_rincians.map { |rin| rin.sasaran.present? ? rin.sasaran.indikator_sasarans.size : 0 }.flatten.sum
    rincians + spbe_rincians.size + 1
  end

  def rowspan_sasaran_spbe(sasaran)
    return 1 if sasaran.nil?

    sasaran.indikator_sasarans.length + 1
  end
end
