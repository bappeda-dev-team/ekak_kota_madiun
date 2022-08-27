# == Schema Information
#
# Table name: program_kegiatans
#
#  id                        :bigint           not null, primary key
#  id_giat                   :string
#  id_program_sipd           :string
#  id_sub_giat               :string
#  id_sub_unit               :string
#  id_unit                   :string
#  identifier_belanja        :string
#  indikator_kinerja         :string
#  indikator_program         :string
#  indikator_subkegiatan     :string
#  isu_strategis             :string
#  kode_bidang_urusan        :string
#  kode_giat                 :string
#  kode_opd                  :string
#  kode_program              :string
#  kode_skpd                 :string
#  kode_sub_giat             :string
#  kode_sub_skpd             :string
#  kode_urusan               :string
#  nama_bidang_urusan        :string
#  nama_kegiatan             :string
#  nama_program              :string
#  nama_subkegiatan          :string
#  nama_urusan               :string
#  pagu                      :string
#  satuan                    :string
#  satuan_target_program     :string
#  satuan_target_subkegiatan :string
#  tahun                     :string
#  target                    :string
#  target_program            :string
#  target_subkegiatan        :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  subkegiatan_tematik_id    :bigint
#
# Indexes
#
#  index_program_kegiatans_on_identifier_belanja      (identifier_belanja) UNIQUE
#  index_program_kegiatans_on_subkegiatan_tematik_id  (subkegiatan_tematik_id)
#
# Foreign Keys
#
#  fk_rails_...  (subkegiatan_tematik_id => subkegiatan_tematiks.id)
#
FactoryBot.define do
  factory :program_kegiatan do
    id_unit { 481 }
    kode_skpd { '5.01.5.05.0.00.02.0000' }
    kode_sub_skpd { '5.01.5.05.0.00.02.0000' }
    tahun { "2022" }
    # Program
    nama_program { "PROGRAM PERENCANAAN, PENGENDALIAN DAN EVALUASI PEMBANGUNAN DAERAH" }
    kode_program { "5.01.01" }
    indikator_program { "Nilai SAKIP" }
    target_program { "88" }
    satuan_target_program { "nilai" }
    # Kegiatan
    nama_kegiatan { "Penyusunan Perencanaan dan Pendanaan" }
    kode_giat { '5.01.01.2.08' }
    indikator_kinerja { "Indikator Kegiatan Program A" }
    target { 100 }
    satuan { "persen" }
    # Subkegiatan
    nama_subkegiatan { "Pelaksanaan Musrenbang Kabupaten/Kota" }
    kode_sub_giat { '5.01.01.2.08.03' }
    indikator_subkegiatan { "Persentase pemenuhan kebutuhan jasa peralatan dan perlengkapan kantor" }
    target_subkegiatan { '100' }
    satuan_target_subkegiatan { '%' }
    # opd
    association :opd
  end
end
