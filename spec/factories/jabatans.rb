# == Schema Information
#
# Table name: jabatans
#
#  id               :bigint           not null, primary key
#  id_jabatan       :bigint
#  index            :string
#  kelas_jabatan    :string
#  kode_opd         :string
#  nama_jabatan     :string
#  nilai_jabatan    :integer
#  tahun            :string
#  tipe             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  jenis_jabatan_id :bigint
#
# Indexes
#
#  index_jabatans_on_jenis_jabatan_id  (jenis_jabatan_id)
#
FactoryBot.define do
  factory :jabatan do
    nama_jabatan { "MyString" }
    kelas_jabatan { "MyString" }
    nilai_jabatan { nil }
    index { "MyString" }
    kode_opd { "MyString" }
    tipe { "MyString" }
    tahun { "MyString" }
    jenis_jabatan {}
  end
end
