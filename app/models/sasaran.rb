# == Schema Information
#
# Table name: sasarans
#
#  id                  :bigint           not null, primary key
#  anggaran            :integer
#  indikator_kinerja   :string
#  kualitas            :integer
#  penerima_manfaat    :string
#  sasaran_kinerja     :string
#  satuan              :string
#  target              :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  program_kegiatan_id :bigint
#  user_id             :bigint
#
# Indexes
#
#  index_sasarans_on_program_kegiatan_id  (program_kegiatan_id)
#  index_sasarans_on_user_id              (user_id)
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
