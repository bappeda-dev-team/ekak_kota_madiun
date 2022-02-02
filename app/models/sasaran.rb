class Sasaran < ApplicationRecord
  belongs_to :user
  has_one :rincian, dependent: :destroy
  accepts_nested_attributes_for :rincian, update_only: true
  belongs_to :program_kegiatan, optional: true
# TODO ganti kualitas dengan aspek ( multiple choice )
  #validation
  validates :sasaran_kinerja, presence: true
  validates :indikator_kinerja, presence: true
  validates :target, presence: true
  validates :satuan, presence: true
end
