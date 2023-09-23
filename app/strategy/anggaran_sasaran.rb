# masukkan strategy yang berbeda ke sasaran
# strategy berupa StrategyEselon4, StrategyEselon3
# dengan masing masing class
class AnggaranSasaran
  attr_accessor :anggaran_strat

  def initialize(anggaran_strat)
    @anggaran_strat = anggaran_strat
  end

  def anggaran
    pagu_anggaran
  end

  private

  def pagu_anggaran
    @anggaran_strat.hitung_anggaran
  end
end
