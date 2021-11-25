class Kak < ApplicationRecord
  belongs_to :program_kegiatan
  belongs_to :pk
  has_one :pagu
end
