# == Schema Information
#
# Table name: strategis
#
#  id              :bigint           not null, primary key
#  nip_asn         :string
#  role            :string
#  strategi        :string
#  tahun           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  pohon_id        :bigint
#  sasaran_id      :string
#  strategi_ref_id :string
#
# Indexes
#
#  index_strategis_on_pohon_id  (pohon_id)
#
class Strategi < ApplicationRecord
  belongs_to :pohon, dependent: :destroy
  has_one :sasaran
  accepts_nested_attributes_for :sasaran, reject_if: :all_blank, allow_destroy: true

  # has_many :indikator_sasarans, foreign_key: 'sasaran_id', primary_key: 'sasaran_id', dependent: :destroy
  # accepts_nested_attributes_for :indikator_sasarans, reject_if: :all_blank, allow_destroy: true

  belongs_to :strategi_atasan, class_name: "Strategi",
                               foreign_key: "strategi_ref_id", optional: true

  belongs_to :strategi_eselon_dua, lambda {
    where(role: "eselon_2")
  }, class_name: "Strategi",
     foreign_key: "strategi_ref_id", optional: true

  has_many :strategi_eselon_tigas, lambda {
    where(role: "eselon_3")
  }, class_name: "Strategi",
     foreign_key: "strategi_ref_id"

  has_many :strategi_eselon_empats, lambda {
    where(role: "eselon_4")
  }, class_name: "Strategi",
     foreign_key: "strategi_ref_id"

  has_many :strategi_staffs, lambda {
    where(role: "staff")
  }, class_name: "Strategi",
     foreign_key: "strategi_ref_id"
end
