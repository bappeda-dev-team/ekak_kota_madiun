# == Schema Information
#
# Table name: tahapans
#
#  id               :bigint           not null, primary key
#  rincian_id       :bigint           not null
#  tahapan_kerja    :string
#  target           :integer
#  realisasi        :integer
#  bulan            :string
#  jumlah_target    :integer
#  jumlah_realisasi :integer
#  keterangan       :string
#  waktu            :integer
#  progress         :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Tahapan < ApplicationRecord
  belongs_to :rincian
  has_many :aksis , :dependent => :destroy
  has_many :anggarans, :dependent => :destroy
end
