# == Schema Information
#
# Table name: inovasis
#
#  id         :bigint           not null, primary key
#  manfaat    :string
#  nip_asn    :string
#  opd        :string
#  tahun      :string
#  usulan     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  sasaran_id :bigint
#
# Indexes
#
#  index_inovasis_on_sasaran_id  (sasaran_id)
#
FactoryBot.define do
  factory :inovasi do
    usulan { "MyString" }
    manfaat { "MyString" }
  end
end
