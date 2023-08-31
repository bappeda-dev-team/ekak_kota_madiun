# == Schema Information
#
# Table name: tematiks
#
#  id             :bigint           not null, primary key
#  keterangan     :string
#  tema           :string
#  type           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  tematik_ref_id :bigint
#
class SubSubTematik < Tematik
  belongs_to :sub_tematik, class_name: 'SubTematik',
                           primary_key: :id, foreign_key: :tematik_ref_id, optional: true

  has_many :indikators, lambda {
                          where(jenis: 'Tematik', sub_jenis: 'SubSubTematik')
                        }, class_name: 'Indikator', foreign_key: 'kode', primary_key: 'id'

  accepts_nested_attributes_for :indikators, reject_if: :all_blank, allow_destroy: true
end
