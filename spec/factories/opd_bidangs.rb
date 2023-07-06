# == Schema Information
#
# Table name: opd_bidangs
#
#  id               :bigint           not null, primary key
#  id_daerah        :string
#  kode_unik_bidang :string
#  kode_unik_opd    :string
#  nama_bidang      :string
#  nip_kepala       :string
#  pangkat_kepala   :string
#  tahun            :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  lembaga_id       :bigint
#  opd_id           :bigint
#
FactoryBot.define do
  factory :opd_bidang do
    nama_bidang { "MyString" }
    opd_id { "" }
    kode_unik_opd { "MyString" }
    kode_unik_bidang { "MyString" }
    tahun { "MyString" }
    nip_kepala { "MyString" }
    pangkat_kepala { "MyString" }
    id_daerah { "MyString" }
    lembaga_id { "" }
  end
end
