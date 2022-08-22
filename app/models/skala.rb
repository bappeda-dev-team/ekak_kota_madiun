# == Schema Information
#
# Table name: skalas
#
#  id         :bigint           not null, primary key
#  jenis      :string
#  jenis_skor :string
#  kode_skala :string
#  pilihan    :string
#  skor       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Skala < ApplicationRecord
  belongs_to :skalable, polymorphic: true
end
