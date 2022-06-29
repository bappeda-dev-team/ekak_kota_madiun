module Master::BidangUrusansHelper
  def dropdown_bidang_urusan
    options_for_select(Master::BidangUrusan.pluck(:tahun).uniq)
  end
end
