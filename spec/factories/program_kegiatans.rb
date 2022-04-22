# == Schema Information
#
# Table name: program_kegiatans
#
#  id                        :bigint           not null, primary key
#  bidang_urusan             :string
#  id_program                :string
#  id_program_sipd           :string
#  id_renstra                :string
#  id_sub_giat               :string
#  id_unit                   :string
#  identifier_belanja        :string
#  indikator_kinerja         :string
#  indikator_program         :string
#  indikator_subkegiatan     :string
#  kode_bidang_urusan        :string
#  kode_giat                 :string
#  kode_opd                  :string
#  kode_program              :string
#  kode_sub_giat             :string
#  kode_urusan               :string
#  nama_bidang_urusan        :string
#  nama_kegiatan             :string
#  nama_program              :string
#  nama_subkegiatan          :string
#  nama_urusan               :string
#  outcome                   :string
#  pagu                      :string
#  pagu_giat                 :string
#  pagu_subgiat              :string
#  satuan                    :string
#  satuan_target_program     :string
#  satuan_target_subkegiatan :string
#  target                    :string
#  target_program            :string
#  target_subkegiatan        :string
#  urusan                    :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  subkegiatan_tematik_id    :bigint
#
# Indexes
#
#  index_program_kegiatans_on_kode_sub_giat           (kode_sub_giat) UNIQUE
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
