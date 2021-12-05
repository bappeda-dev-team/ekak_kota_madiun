class Rincian < ApplicationRecord
  belongs_to :sasaran
  has_many :kesenjangan
  has_many :tahapans
  accepts_nested_attributes_for :tahapans
end
