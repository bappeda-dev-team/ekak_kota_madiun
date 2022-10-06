# == Schema Information
#
# Table name: skalas
#
#  id         :bigint           not null, primary key
#  deskripsi  :string
#  keterangan :string
#  kode_skala :string
#  nilai      :string
#  tipe_nilai :string
#  type       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  rincian_id :bigint
#
class Skala < ApplicationRecord
  has_one :rincian
end
