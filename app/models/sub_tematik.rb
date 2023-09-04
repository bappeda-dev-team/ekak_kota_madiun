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
class SubTematik < Tematik
  belongs_to :tematik, primary_key: :id, foreign_key: :tematik_ref_id

  has_many :indikators, lambda {
                          where(jenis: 'Tematik', sub_jenis: 'SubTematik')
                        }, class_name: 'Indikator', foreign_key: 'kode', primary_key: 'id'

  accepts_nested_attributes_for :indikators, reject_if: :all_blank, allow_destroy: true

  def pohon_list
    Pohon.where(pohonable_id: id,
                pohonable_type: 'SubTematik',
                role: 'sub_pohon_kota')
         .pluck(:id, :tahun)
  end
end
