# == Schema Information
#
# Table name: sasarans
#
#  id                  :bigint           not null, primary key
#  anggaran            :integer
#  indikator_kinerja   :string
#  kualitas            :integer
#  nip_asn             :string
#  penerima_manfaat    :string
#  sasaran_kinerja     :string
#  satuan              :string
#  target              :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  program_kegiatan_id :bigint
#  user_id             :bigint
#
# Indexes
#
#  index_sasarans_on_program_kegiatan_id  (program_kegiatan_id)
#  index_sasarans_on_user_id              (user_id)
#
FactoryBot.define do
  factory :sasaran do
    sasaran_kinerja { " Terlaksananya monitoring dan evaluasi pelaksanaan kegiatan program smart city kota madiun " }
    indikator_kinerja { " persentase tahapan pelaksanaan pengendalian dan evaluasi yang terlaporkan " }
    target { 100 }
    satuan { "%" }
    association :user
  end
end
