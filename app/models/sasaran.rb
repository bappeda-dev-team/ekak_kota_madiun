class Sasaran < ApplicationRecord
  belongs_to :user
  has_one :rincian
  belongs_to :program_kegiatan, optional: true
end
