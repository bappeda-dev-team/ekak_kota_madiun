# == Schema Information
#
# Table name: visis
#
#  id          :bigint           not null, primary key
#  keterangan  :string
#  tahun_akhir :string
#  tahun_awal  :string
#  urutan      :integer          default(1)
#  visi        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Visi < ApplicationRecord
  has_many :misis

  def to_s
    visi
  end

  def periode
    "#{tahun_awal}-#{tahun_akhir}"
  end
end
