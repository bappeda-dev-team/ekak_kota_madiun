# == Schema Information
#
# Table name: program_kegiatans
#
#  id                        :bigint           not null, primary key
#  indikator_kinerja         :string
#  indikator_subkegiatan     :string
#  kode_opd                  :string
#  nama_kegiatan             :string
#  nama_program              :string
#  nama_subkegiatan          :string
#  satuan                    :string
#  satuan_target_subkegiatan :string
#  target                    :string
#  target_subkegiatan        :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  subkegiatan_tematik_id    :bigint
#
# Indexes
#
#  index_program_kegiatans_on_subkegiatan_tematik_id  (subkegiatan_tematik_id)
#
# Foreign Keys
#
#  fk_rails_...  (kode_opd => opds.kode_opd)
#  fk_rails_...  (subkegiatan_tematik_id => subkegiatan_tematiks.id)
#
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
