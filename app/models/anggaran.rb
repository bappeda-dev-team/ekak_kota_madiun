class Anggaran < ApplicationRecord
  belongs_to :tahapan
  has_many :perhitungans
end
