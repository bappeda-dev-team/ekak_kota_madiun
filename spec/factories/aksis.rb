# == Schema Information
#
# Table name: aksis
#
#  id              :bigint           not null, primary key
#  bulan           :integer
#  id_aksi_bulan   :string
#  id_rencana_aksi :string
#  keterangan      :string
#  realisasi       :integer
#  target          :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  tahapan_id      :bigint
#
# Indexes
#
#  index_aksis_on_id_aksi_bulan  (id_aksi_bulan) UNIQUE
#
FactoryBot.define do
  factory :aksi do
    bulan { 2 }
    target { 10 }
    id_rencana_aksi { 'test_1' }
  end
end
