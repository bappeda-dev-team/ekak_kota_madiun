class Sasaran < ApplicationRecord
  belongs_to :user
  has_one :rincian, dependent: :destroy
  belongs_to :program_kegiatan, optional: true
  accepts_nested_attributes_for :rincian, update_only: true
end
