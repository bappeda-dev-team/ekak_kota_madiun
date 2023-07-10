# == Schema Information
#
# Table name: spbe_rincians
#
#  id                     :bigint           not null, primary key
#  aspek_spbe             :string
#  detail_kebutuhan       :string
#  detail_sasaran_kinerja :string
#  domain_spbe            :string
#  id_rencana             :string
#  internal_external      :string
#  kebutuhan_spbe         :string
#  keterangan             :string
#  kode_opd               :string
#  kode_program           :string
#  subdomain_spbe         :string
#  tahun_akhir            :string
#  tahun_awal             :string
#  tahun_pelaksanaan      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  spbe_id                :bigint
#  strategi_ref_id        :string
#
FactoryBot.define do
  factory :spbe_rincian do
    association :spbe
    association :opd
    domain_spbe { "Test Domain" }
    aspek_spbe { "Test aspek" }
    subdomain_spbe { "Test subDomain" }
    kebutuhan_spbe { "Test kebutuhan" }
    detail_kebutuhan { "Test Detail kebutuhan" }
    tahun_awal { "2020" }
    tahun_akhir { "2024" }
  end
end
