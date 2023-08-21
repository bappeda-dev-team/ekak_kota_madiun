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
class Tematik < ApplicationRecord
  validates_presence_of :tema
  validates_length_of :tema, minimum: 5

  has_many :indikators, lambda {
                          where(jenis: 'Tematik', sub_jenis: 'Tematik')
                        }, class_name: 'Indikator', foreign_key: 'kode', primary_key: 'id'
  accepts_nested_attributes_for :indikators, reject_if: :all_blank, allow_destroy: true

  has_many :sub_tematiks, primary_key: :id, foreign_key: :tematik_ref_id

  def to_s
    tema
  end
end
