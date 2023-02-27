# == Schema Information
#
# Table name: sasaran_opds
#
#  id            :bigint           not null, primary key
#  id_sasaran    :string
#  id_tujuan     :string
#  kode_unik_opd :string           not null
#  sasaran       :string           not null
#  tahun_akhir   :string
#  tahun_awal    :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_sasaran_opds_on_id_sasaran  (id_sasaran) UNIQUE
#
class SasaranOpd < ApplicationRecord
  belongs_to :opd, foreign_key: 'kode_unik_opd', primary_key: 'kode_unik_opd'
  has_many :indikators, lambda { |object|
                          where(jenis: 'Sasaran', sub_jenis: 'Opd', kode_opd: object.kode_unik_opd)
                        }, class_name: 'Indikator', foreign_key: 'kode', primary_key: 'id_sasaran'
  accepts_nested_attributes_for :indikators, reject_if: :all_blank, allow_destroy: true

  def indikator_sasarans_new
    sasaran = indikators.group_by(&:indikator).transform_values do |indikator|
      indikator.group_by(&:tahun)
    end
    {
      indikator_sasaran: sasaran.to_h
    }
  end
end
