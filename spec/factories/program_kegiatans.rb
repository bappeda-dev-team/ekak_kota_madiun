FactoryBot.define do
  factory :program_kegiatan do
    indikator_kinerja { "Indikator Program A" }
    nama_program { "PROGRAM PERENCANAAN, PENGENDALIAN DAN EVALUASI PEMBANGUNAN DAERAH" }
    nama_kegiatan { "Penyusunan Perencanaan dan Pendanaan" }
    nama_subkegiatan { "Pelaksanaan Musrenbang Kabupaten/Kota" }
    target { 100 }
    satuan { "persen" }
    association :opd
  end
end
