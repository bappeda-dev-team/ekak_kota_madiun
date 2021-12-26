class Kak < ApplicationRecord
  validates :dasar_hukum, presence: true
  belongs_to :program_kegiatan, optional: true
  belongs_to :user
  has_many :sasarans
end
