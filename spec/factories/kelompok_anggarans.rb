# == Schema Information
#
# Table name: kelompok_anggarans
#
#  id            :bigint           not null, primary key
#  kelompok      :string
#  kode_kelompok :string
#  tahun         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
FactoryBot.define do
  factory :kelompok_anggaran do
    kode_kelompok { "MyString" }
    tahun { "MyString" }
    kelompok { "MyString" }
  end

  factory :base_periode, class: 'KelompokAnggaran' do
    kode_kelompok { "murni" }
    tahun { "2025" }
    kelompok { "Murni" }
  end
end
