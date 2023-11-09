# == Schema Information
#
# Table name: tujuans
#
#  id               :bigint           not null, primary key
#  id_tujuan        :string           not null
#  kode_unik_opd    :string
#  tahun_akhir      :string
#  tahun_awal       :string
#  tujuan           :string
#  type             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  bidang_urusan_id :bigint
#  urusan_id        :bigint
#
FactoryBot.define do
  factory :tujuan do
    tujuan { "MyString" }
    id_tujuan { "MyString" }
    kode_unik_opd { "" }
    tahun_awal { "" }
    tahun_akhir { "" }
    type { "" }
  end
end
