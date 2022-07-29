# == Schema Information
#
# Table name: lembagas
#
#  id           :bigint           not null, primary key
#  kode_lembaga :string
#  nama_lembaga :string
#  tahun        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Lembaga < ApplicationRecord
  has_many :opds
  validates :nama_lembaga, presence: true
end
