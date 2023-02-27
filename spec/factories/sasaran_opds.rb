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
FactoryBot.define do
  factory :sasaran_opd do
    
  end
end
