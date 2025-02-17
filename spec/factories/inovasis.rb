# == Schema Information
#
# Table name: inovasis
#
#  id           :bigint           not null, primary key
#  is_active    :boolean          default(FALSE)
#  is_from_kota :boolean          default(FALSE)
#  manfaat      :string
#  nip_asn      :string
#  opd          :string
#  status       :enum             default("draft")
#  tahun        :string
#  uraian       :string
#  usulan       :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  sasaran_id   :bigint
#
# Indexes
#
#  index_inovasis_on_sasaran_id  (sasaran_id)
#  index_inovasis_on_status      (status)
#
FactoryBot.define do
  factory :inovasi do
    usulan { "Inovasi walikota a" }
    manfaat { "Pemulusan jalan" }
  end
end
