class Kak < ApplicationRecord
  belongs_to :program_kegiatan
  belongs_to :user
  belongs_to :pk
end
