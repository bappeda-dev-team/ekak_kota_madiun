# == Schema Information
#
# Table name: tahapans
#
#  id               :bigint           not null, primary key
#  bulan            :string
#  id_rencana       :string
#  id_rencana_aksi  :string
#  jumlah_realisasi :integer
#  jumlah_target    :integer
#  keterangan       :string
#  progress         :integer
#  realisasi        :integer
#  tahapan_kerja    :string
#  target           :integer
#  waktu            :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  sasaran_id       :bigint
#
# Indexes
#
#  index_tahapans_on_id_rencana_aksi  (id_rencana_aksi) UNIQUE
#
FactoryBot.define do
  factory :tahapan do
    tahapan_kerja { 'Tahapan Testing' }
    keterangan { 'Keterangan buatan' }
    association :sasaran
  end
end
