class Sasaran < ApplicationRecord
  belongs_to :user
  has_one :rincian
  
end
