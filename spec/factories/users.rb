# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  atasan                 :string
#  atasan_nama            :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  eselon                 :string
#  id_bidang              :bigint
#  jabatan                :string
#  kode_opd               :string
#  nama                   :string
#  nama_bidang            :string
#  nama_pangkat           :string
#  nik                    :string
#  nip_sebelum            :string
#  pangkat                :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  type                   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_nik                   (nik) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
FactoryBot.define do
  factory :user do
    nama { "NOOR AFLAH" }
    nik { "197609072003121007" }
    email { "197609072003121007@madiunkota.go.id" }
    password { "123456" }
    association :opd

    factory :admin_opd do
      after(:create) do |user|
        user.add_role :admin
        user.remove_role :non_aktif
      end
    end

    factory :asn do
      after(:create) do |user|
        user.add_role :asn
        user.remove_role :non_aktif
      end
    end
    factory :atasan, class: Atasan do
      after(:create) do |user|
        user.add_role :asn
        user.remove_role :non_aktif
      end
      type { 'Atasan' }
    end
    factory :kepala, class: Kepala do
      after(:create) do |user|
        user.add_role :asn
        user.remove_role :non_aktif
      end
      type { 'Kepala' }
    end
  end
end
