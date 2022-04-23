FactoryBot.define do
  factory :anggaran do
    kode_rek { "5.1.01.03.07.0001" }
    uraian { "Belanja Honorarium Penanggungjawaban Pengelola Keuangan" }
    level { 4 }
    association :tahapan
    association :pajak
  end
end
