# == Schema Information
#
# Table name: tims
#
#  id             :bigint           not null, primary key
#  jabatan        :string
#  jenis          :string
#  keterangan     :string
#  nama_tim       :string
#  nip            :string
#  tahun          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  inovasi_tim_id :bigint           not null
#  opd_id         :bigint
#
# Indexes
#
#  index_tims_on_inovasi_tim_id  (inovasi_tim_id)
#  index_tims_on_opd_id          (opd_id)
#
# Foreign Keys
#
#  fk_rails_...  (inovasi_tim_id => inovasi_tims.id)
#
FactoryBot.define do
  factory :tim do
    nama_tim { "MyString" }
    nip { "MyString" }
    jabatan { "MyString" }
    opd { nil }
    keterangan { "MyString" }
    tahun { "" }
    jenis { "MyString" }
    team_ref_id { "" }
  end
end
