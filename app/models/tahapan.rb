class Tahapan < ApplicationRecord
  belongs_to :rincian
  has_many :aksis
end
