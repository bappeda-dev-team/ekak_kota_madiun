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

  has_many :pendidikan_terakhirs

  validates :status_kepegawaian, presence: true
  validates :tahun, presence: true

  JENIS_PENDIDIKAN = ['SMP/SMA', 'D4/S1', 'S2/S3']

  def pendidikan_pegawai
    pendidikans = pendidikan_terakhirs.pluck(:pendidikan)

    JENIS_PENDIDIKAN.to_h do |jenis|
      [jenis, pendidikans.include?(jenis)]
    end
  end
end
