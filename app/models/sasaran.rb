class Sasaran < ApplicationRecord
  belongs_to :user
  has_one :rincian, dependent: :destroy
  accepts_nested_attributes_for :rincian, update_only: true
  belongs_to :kak
  belongs_to :program_kegiatan, optional: true
end
