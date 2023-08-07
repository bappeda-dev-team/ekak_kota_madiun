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
end
