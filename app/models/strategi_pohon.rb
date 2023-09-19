# == Schema Information
#
# Table name: strategis
#
#  id                    :bigint           not null, primary key
#  linked_with           :bigint
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
                           }, foreign_key: 'pohonable_id', primary_key: 'id', class_name: 'Pohon'

  has_many :takens, class_name: 'Strategi', primary_key: 'id',
                    foreign_key: 'linked_with'

  has_many :indikators, lambda {
                          where(jenis: 'StrategiPohon', sub_jenis: 'StrategiPohon')
                        }, class_name: 'Indikator', foreign_key: 'kode', primary_key: 'id'

  accepts_nested_attributes_for :indikators, reject_if: :all_blank, allow_destroy: true

  has_many :strategi_bawahans, class_name: 'StrategiPohon',
                               primary_key: :id, foreign_key: :strategi_ref_id

  belongs_to :strategi_atasan, class_name: "StrategiPohon",
                               foreign_key: "strategi_ref_id", optional: true

  belongs_to :strategi_asli, class_name: 'Strategi',
                             foreign_key: :strategi_cascade_link,
                             primary_key: :id,
                             optional: true

  has_many :komentars, primary_key: :strategi_cascade_link,
                       foreign_key: :item

  def pohon_ref_id
    strategi_ref_id
  end
end
