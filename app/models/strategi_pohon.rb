# == Schema Information
#
# Table name: strategis
#
#  id                    :bigint           not null, primary key
#  nip_asn               :string
#  nip_asn_sebelumnya    :string
#  role                  :string
#  strategi              :string
#  strategi_cascade_link :bigint
#  tahun                 :string
#  type                  :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  opd_id                :string
#  pohon_id              :bigint
#  sasaran_id            :string
#  strategi_ref_id       :string
#
# Indexes
#
#  index_strategis_on_pohon_id  (pohon_id)
#
class StrategiPohon < Strategi
  has_many :pohon_shareds, lambda {
                             where(pohonable_type: 'StrategiPohon')
                           }, foreign_key: 'strategi_id', primary_key: 'id', class_name: 'Pohon'
  belongs_to :strategi_eselon_dua, lambda {
    where(role: "eselon_2")
  }, class_name: "StrategiPohon",
     foreign_key: "strategi_ref_id", optional: true

  belongs_to :strategi_eselon_tiga, lambda {
    where(role: "eselon_3").or(where(role: "eselon_2b")).where.not(nip_asn: "")
  }, class_name: "StrategiPohon",
     foreign_key: "strategi_ref_id", dependent: :destroy, optional: true

  has_many :strategi_eselon_dua_bs, lambda {
    where(role: "eselon_2b").where.not(nip_asn: "")
  }, class_name: "StrategiPohon",
     foreign_key: "strategi_ref_id", dependent: :destroy

  has_many :strategi_eselon_tiga_setda, lambda {
    where(role: "eselon_3").where.not(nip_asn: "")
  }, class_name: "StrategiPohon",
     foreign_key: "strategi_ref_id", dependent: :destroy

  has_many :strategi_eselon_tiga_pohons, lambda {
    where(role: "eselon_3", type: "StrategiPohon").or(where(role: "eselon_2b")).where(nip_asn: "")
  }, class_name: "StrategiPohon",
     foreign_key: "strategi_ref_id",
     dependent: :destroy

  has_many :strategi_eselon_empats, lambda {
    where(role: "eselon_4").where(nip_asn: "")
  }, class_name: "StrategiPohon",
     foreign_key: "strategi_ref_id", dependent: :destroy

  has_many :strategi_staffs, lambda {
    where(role: "staff").where(nip_asn: "")
  }, class_name: "StrategiPohon",
     foreign_key: "strategi_ref_id", dependent: :destroy

  has_one :strategi_asli, class_name: "Strategi",
                          primary_key: "strategi_cascade_link",
                          foreign_key: "id"

  def komentars
    strategi_asli.komentars
  end
end
