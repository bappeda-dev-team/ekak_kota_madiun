class Sasaran < ApplicationRecord
  belongs_to :user
  has_one :rincian
  has_many :pagus
  belongs_to :program_kegiatan, optional: true
end
