# == Schema Information
#
# Table name: sasarans
#
#  id                  :bigint           not null, primary key
#  sasaran_kinerja     :string
#  indikator_kinerja   :string
#  target              :integer
#  kualitas            :integer
#  satuan              :string
#  penerima_manfaat    :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  user_id             :bigint
#  program_kegiatan_id :bigint
#  anggaran            :integer
#
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
