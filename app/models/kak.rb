class Kak < ApplicationRecord
  belongs_to :program_kegiatan
  belongs_to :user
  has_many :hukums, dependent: :destroy
end
