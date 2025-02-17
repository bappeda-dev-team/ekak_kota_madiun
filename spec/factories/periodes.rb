# == Schema Information
#
# Table name: periodes
#
#  id            :bigint           not null, primary key
#  jenis_periode :string           default("RPJMD")
#  tahun_akhir   :string
#  tahun_awal    :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
FactoryBot.define do
  factory :periode do
    tahun_awal { "2025" }
    tahun_akhir { "2026" }
  end

  factory :dua_lima_dua_enam, class: 'Periode' do
    tahun_awal { "2025" }
    tahun_akhir { "2026" }
  end
end
