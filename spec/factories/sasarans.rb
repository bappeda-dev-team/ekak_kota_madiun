FactoryBot.define do
  factory :sasaran do
    sasaran_kinerja { " Terlaksananya monitoring dan evaluasi pelaksanaan kegiatan program smart city kota madiun " }
    indikator_kinerja { " persentase tahapan pelaksanaan pengendalian dan evaluasi yang terlaporkan " }
    target { 100 }
    satuan { "%" }
    association :user
  end
end
