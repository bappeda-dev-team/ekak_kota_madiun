# == Schema Information
#
# Table name: rekenings
#
#  id             :bigint           not null, primary key
#  jenis_rekening :string
#  kode_rekening  :string
#  set_input      :integer          default(0)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Rekening < ApplicationRecord
  def grand_parent
    kode_rekening = self.kode_rekening
    Rekening.find_by(kode_rekening: kode_rekening[0..2])
  end

  def parent
    # TODO : tambah exception untuk NilClass kode_rekening
    kode_rekening = self.kode_rekening
    my_level = level
    case my_level
    when 4
      Rekening.find_by(kode_rekening: kode_rekening[0..-6])
    when 1..3
      Rekening.find_by(kode_rekening: kode_rekening[0..-4])
    else
      Rekening.find_by(kode_rekening: kode_rekening[0..2])
    end
  end

  def level
    panjang_kode_rek = kode_rekening.length
    if panjang_kode_rek <= 3
      0
    elsif panjang_kode_rek <= 6
      1
    elsif panjang_kode_rek <= 9
      2
    elsif panjang_kode_rek <= 12
      3
    else
      4
    end
  end
end
