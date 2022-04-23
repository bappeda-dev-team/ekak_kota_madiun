FactoryBot.define do
  factory :perhitungan do
    deskripsi { '1.1.7.01.01.01.002' }
    satuan { 'Orang' }
    harga { 1_000_000 }
    association :anggaran
    factory :perhitungan_with_koefisiens do
      transient do
        koefisiens_count { 1 }
      end
      after(:create) do |perhitungan, evaluator|
        create_list(:koefisien, evaluator.koefisiens_count, perhitungan: perhitungan)
      end
    end
  end
end
