# == Schema Information
#
# Table name: genders
#
#  id                  :bigint           not null, primary key
#  akses               :string
#  data_terpilah       :string
#  indikator           :string
#  kontrol             :string
#  manfaat             :string
#  partisipasi         :string
#  penyebab_external   :string
#  penyebab_internal   :string
#  reformulasi_tujuan  :string satuan              :string
#  target              :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  program_kegiatan_id :bigint
#  sasaran_id          :bigint
#
# Indexes
#
#  index_genders_on_program_kegiatan_id  (program_kegiatan_id)
#  index_genders_on_sasaran_id           (sasaran_id)
#
class Gender < ApplicationRecord
  belongs_to :program_kegiatan, optional: true
  belongs_to :sasaran, optional: true

  validates :sasaran_id, presence: true
  validates :program_kegiatan_id, presence: true
  validates :reformulasi_tujuan, presence: true
  validates :akses, presence: true
  validates :partisipasi, presence: true
  validates :kontrol, presence: true
  validates :manfaat, presence: true
  validates :penyebab_internal, presence: true
  validates :penyebab_external, presence: true

  def faktor_kesenjangan
    "AKSES: #{akses}
     PARTISIPASI: #{partisipasi}
     KONTROL: #{kontrol}
     MANFAAT: #{manfaat}
    "
  end
end
