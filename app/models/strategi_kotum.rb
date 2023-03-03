# == Schema Information
#
# Table name: strategi_kota
#
#  id                    :bigint           not null, primary key
#  strategi              :string
#  tahun                 :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  isu_strategis_kota_id :string
#  sasaran_kota_id       :string
#
class StrategiKotum < ApplicationRecord
  default_scope { order(:id) }
  belongs_to :isu_strategis_kotum, foreign_key: 'isu_strategis_kota_id', primary_key: 'id'
  belongs_to :sasaran_kotum, foreign_key: 'sasaran_kota_id', primary_key: 'kode_sasaran', optional: true
  has_many :usulans, as: :usulanable, dependent: :destroy
  has_many :pohons, as: :pohonable, dependent: :destroy

  has_many :strategis, through: :pohons

  def nama_pemilik
    "Kota Madiun"
  end

  def isu_strategis
    isu_strategis_kotum.isu_strategis
  end
end
