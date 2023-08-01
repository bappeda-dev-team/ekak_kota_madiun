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

  def to_s
    tema
  end
end
