# == Schema Information
#
# Table name: sasarans
#
#  id                     :bigint           not null, primary key
#  anggaran               :integer
#  id_rencana             :string
#  indikator_kinerja      :string
#  is_perintah_walikota   :boolean          default(FALSE)
#  jenis_layanan          :string
#  keterangan             :string
#  kualitas               :integer
#  metadata               :jsonb
#  nip_asn                :string
#  nip_asn_sebelumnya     :string
#  penerima_manfaat       :string
#  sasaran_atasan         :string
#  sasaran_kinerja        :string
#  sasaran_kota           :string
#  sasaran_milik          :string
#  sasaran_opd            :string
#  satuan                 :string
#  status                 :enum             default("draft")
#  sumber_dana            :string
#  tahun                  :string
#  target                 :integer
#  type                   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  bpmn_spbe_id           :bigint
#  opd_id                 :bigint
#  program_kegiatan_id    :bigint
#  sasaran_atasan_id      :string
#  strategi_id            :string
#  subkegiatan_tematik_id :bigint
#
# Indexes
#
#  index_sasarans_on_bpmn_spbe_id  (bpmn_spbe_id)
#  index_sasarans_on_id_rencana    (id_rencana) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (bpmn_spbe_id => bpmn_spbes.id)
#  fk_rails_...  (nip_asn => users.nik)
#  fk_rails_...  (subkegiatan_tematik_id => subkegiatan_tematiks.id)
#
FactoryBot.define do
  factory :sasaran do
    sasaran_kinerja { "Terlaksananya monitoring dan evaluasi pelaksanaan kegiatan program smart city kota madiun" }
    status { "draft" }
    tahun { "" }
    strategi_id { "" }
    association :user

    factory :sasaran_subkegiatan do
      association :program_kegiatan
    end

    factory :complete_sasaran do
      association :strategi
      association :program_kegiatan
      after(:create) do |sasaran|
        sasaran.indikator_sasarans << FactoryBot.build(:indikator_sasaran)
      end
    end
  end
end
