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
    hasil = Rekening.find_by(kode_rekening: kode_rekening[0..2])
  end

  def parent
    # TODO : tambah exception untuk NilClass kode_rekening
    kode_rekening = self.kode_rekening
    if self.level == 4
      hasil = Rekening.find_by(kode_rekening: kode_rekening[0..-6])
    elsif self.level == 3
      hasil = Rekening.find_by(kode_rekening: kode_rekening[0..-4])
    elsif self.level == 2
      hasil = Rekening.find_by(kode_rekening: kode_rekening[0..-4])
    elsif self.level == 1
      hasil = Rekening.find_by(kode_rekening: kode_rekening[0..-4])
    else
      hasil = self.grand_parent
    end
    return hasil
  end

  def level
    panjang_kode_rek = self.kode_rekening.length
    if panjang_kode_rek <= 3
      return 0
    elsif panjang_kode_rek <= 6
      return 1
    elsif panjang_kode_rek <= 9
      return 2
    elsif panjang_kode_rek <= 12
      return 3
    else
      return 4
    end
  end
end
