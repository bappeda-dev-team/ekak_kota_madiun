module AkarMasalahsHelper
  def form_id(akar_masalah)
    dom_id(akar_masalah, 'form')
  end

  def rowspan_masalah_pokok(tacticals)
    masalahs = tacticals
    akar_masalahs = masalahs.flat_map { |tact| tact.strategi_bawahans.size }.reduce(:+)
    masalahs.size + akar_masalahs + 1
  end

  def rowspan_masalah(operationals)
    operationals.size + 1
  end
end
