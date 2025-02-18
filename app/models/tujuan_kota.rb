# == Schema Information
#
# Table name: tujuan_kota
#
#  id          :bigint           not null, primary key
#  id_misi     :string
#  id_tujuan   :string
#  kode_tujuan :string
#  misi        :string
#  tahun_akhir :string
#  tahun_awal  :string
#  tujuan      :string
#  type        :string
#  visi        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  misi_id     :bigint
#  pohon_id    :bigint
#  visi_id     :bigint
#
# Indexes
#
#  index_tujuan_kota_on_id_tujuan  (id_tujuan) UNIQUE
#  index_tujuan_kota_on_misi_id    (misi_id)
#  index_tujuan_kota_on_pohon_id   (pohon_id)
#  index_tujuan_kota_on_visi_id    (visi_id)
#
# Foreign Keys
#
#  fk_rails_...  (misi_id => misis.id)
#  fk_rails_...  (pohon_id => pohons.id)
#  fk_rails_...  (visi_id => visis.id)
#
class TujuanKota < ApplicationRecord
  has_many :indikator_tujuans, -> { order(:tahun) },
           class_name: 'Indikator', foreign_key: 'kode', primary_key: 'id_tujuan'
  has_many :targets, through: :indikators

  accepts_nested_attributes_for :indikator_tujuans, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :targets, reject_if: :all_blank, allow_destroy: true

  has_many :sasaran_kota, foreign_key: 'id_tujuan', primary_key: 'kode_tujuan'
  has_many :strategi_kota, through: :sasaran_kota
  has_one :risiko
  belongs_to :pohon
  accepts_nested_attributes_for :risiko

  # because of the stupid fill visi misi
  belongs_to :visi_kota, primary_key: 'id', foreign_key: 'visi_id', class_name: 'Visi'
  belongs_to :misi_kota, primary_key: 'id', foreign_key: 'misi_id', class_name: 'Misi'
  scope :visis, -> { joins(%i[indikator_tujuans sasaran_kota]).where.not(visi: nil) }
  scope :misis, -> { joins(%i[indikator_tujuans sasaran_kota]).where.not(misi: nil) }
  scope :sasarans, -> { joins(:sasaran_kota) }
  scope :by_periode, lambda { |tahun|
                       where("tahun_awal::integer <= ?::integer", tahun)
                         .where("tahun_akhir::integer >= ?::integer", tahun)
                     }

  scope :by_tahun_awal_akhir, lambda { |tahun_awal, tahun_akhir|
                                where("tahun_awal::integer >= ?::integer", tahun_awal)
                                  .where("tahun_akhir::integer <= ?::integer", tahun_akhir)
                              }
  def to_s
    tujuan
  end

  def tahun_awal_akhir
    "#{tahun_awal} - #{tahun_akhir}"
  end

  # need fixing, indikator doubled in indikator_tujuans
  def indikators
    indikators = indikator_tujuans.group_by(&:version)
    indikators[indikators.keys.max]
  end
end
