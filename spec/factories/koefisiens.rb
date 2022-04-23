FactoryBot.define do
  factory :koefisien do
    satuan_volume { 'Orang' }
    volume { 5 }
    association :perhitungan
  end
end
