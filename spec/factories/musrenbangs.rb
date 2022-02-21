# == Schema Information
#
# Table name: musrenbangs
#
#  id         :bigint           not null, primary key
#  alamat     :text
#  nip_asn    :string
#  opd        :string
#  tahun      :string
#  usulan     :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  sasaran_id :bigint
#
# Indexes
#
#  index_musrenbangs_on_sasaran_id  (sasaran_id)
#
FactoryBot.define do
  factory :musrenbang do
    usulan { "Usulan Musrenbang Kelurahan Kartoharjo" }
    tahun { "2022" }
  end
end
