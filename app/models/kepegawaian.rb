# == Schema Information
#
# Table name: kepegawaians
#
#  id                 :bigint           not null, primary key
#  jumlah             :integer
#  status_kepegawaian :string
#  tahun              :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  jabatan_id         :bigint           not null
#  opd_id             :bigint
#
# Indexes
#
#  index_kepegawaians_on_jabatan_id  (jabatan_id)
#  index_kepegawaians_on_opd_id      (opd_id)
#
# Foreign Keys
#
#  fk_rails_...  (jabatan_id => jabatans.id)
#
class Kepegawaian < ApplicationRecord
  belongs_to :jabatan
  belongs_to :opd

  has_many :pendidikan_terakhirs, dependent: :destroy
  accepts_nested_attributes_for :pendidikan_terakhirs, reject_if: :reject_pendidikan

  def reject_pendidikan(attributes)
    attributes['pendidikan'].blank?
  end

  validates :status_kepegawaian, presence: true
  validates :tahun, presence: true
  validates :jumlah, numericality: { greater_than_or_equal: 0 }

  JENIS_PENDIDIKAN = %w[SD/SMP SMA D1/D3 D4/S1 S2/S3]

  def pendidikan_pegawai
    pendidikan_terakhirs.pluck(:pendidikan)
  end
end
