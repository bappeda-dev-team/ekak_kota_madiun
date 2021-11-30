class Tahapan < ApplicationRecord
  belongs_to :rincian
  has_many :aksis
  has_many :anggarans
end
