# == Schema Information
#
# Table name: jenis_jabatans
#
#  id         :bigint           not null, primary key
#  keterangan :string
#  nama_jenis :string           default("Jabatan Fungsional"), not null
#  nilai      :integer          default(3), not null
#  tahun      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :jenis_jabatan do
    nama_jenis { "Jabatan Pimpinan Tinggi" }
    nilai { 1 }
    keterangan { "test" }
    tahun { "2025" }
  end
end
