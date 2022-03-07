# == Schema Information
#
# Table name: pokpirs
#
#  id         :bigint           not null, primary key
#  alamat     :string
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
#  index_pokpirs_on_sasaran_id  (sasaran_id)
#
class Pokpir < ApplicationRecord
  validates :usulan, presence: true

  belongs_to :sasaran, optional: true
end
