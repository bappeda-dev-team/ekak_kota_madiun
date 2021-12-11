class Tahapan < ApplicationRecord
  belongs_to :rincian
  has_many :aksis , :dependent => :destroy
  has_many :anggarans, :dependent => :destroy
end
