# == Schema Information
#
# Table name: pagu_anggarans
#
#  id                 :bigint           not null, primary key
#  anggaran           :decimal(, )
#  anggaran_realisasi :decimal(, )
#  id_anggaran        :integer
#  jenis              :string
#  keterangan         :string
#  kode               :string
#  kode_belanja       :string
#  kode_opd           :string
#  kode_sub_belanja   :string
#  sub_jenis          :string
#  tahun              :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
FactoryBot.define do
  factory :pagu_anggaran do
  end
end
