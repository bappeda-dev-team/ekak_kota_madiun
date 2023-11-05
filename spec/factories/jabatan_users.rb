# == Schema Information
#
# Table name: jabatan_users
#
#  id         :bigint           not null, primary key
#  bulan      :string           not null
#  id_jabatan :bigint           not null
#  kode_opd   :string           not null
#  nip_asn    :string           not null
#  tahun      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :jabatan_user do
    jabatan { nil }
    user { nil }
  end
end
