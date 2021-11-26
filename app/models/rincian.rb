class Rincian < ApplicationRecord
  belongs_to :sasaran
  has_many :kesenjangan
  has_many :tahapan
end
