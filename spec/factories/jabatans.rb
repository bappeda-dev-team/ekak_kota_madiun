# == Schema Information
#
# Table name: jabatans
#
#  id            :bigint           not null, primary key
#  index         :string
#  kelas_jabatan :string
#  kode_jabatan  :string
#  kode_opd      :string
#  nama_jabatan  :string
#  nilai_jabatan :integer
#  tahun         :string
#  tipe          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
FactoryBot.define do
  factory :jabatan do
    nama_jabatan { "MyString" }
    kelas_jabatan { "MyString" }
    nilai_jabatan { 1 }
    index { "MyString" }
    kode_opd { "MyString" }
    tipe { "MyString" }
    kode_jabatan { "MyString" }
    tahun { "MyString" }
  end
end
