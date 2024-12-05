# == Schema Information
#
# Table name: inovasi_tims
#
#  id                    :bigint           not null, primary key
#  jenis_inovasi         :string
#  nama_inovasi          :string
#  nilai_kebaruan        :string
#  tahun                 :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  crosscutting_id       :bigint           not null
#  inovasi_masyarakat_id :bigint
#
# Indexes
#
#  index_inovasi_tims_on_crosscutting_id  (crosscutting_id)
#
# Foreign Keys
#
#  fk_rails_...  (crosscutting_id => crosscuttings.id)
#
class InovasiTim < ApplicationRecord
  belongs_to :crosscutting
  has_many :tims
  accepts_nested_attributes_for :tims, reject_if: :all_blank, allow_destroy: true

  # has_many :anggota_tims, through: :tims
  # accepts_nested_attributes_for :anggota_tims, reject_if: :all_blank, allow_destroy: true

  def inovasi_masyarakat?
    inovasi_masyarakat_id.present?
  end

  def inovasi_masyarakat
    inovasi_masyarakat? ? 'USULAN MASYARKAAT' : 'INTERNAL'
  end
end
