# == Schema Information
#
# Table name: permasalahans
#
#  id                :bigint           not null, primary key
#  jenis             :text
#  penyebab_external :string
#  penyebab_internal :string
#  permasalahan      :text
#  tahun             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  sasaran_id        :bigint
#  usulan_id         :bigint
#
# Foreign Keys
#
#  fk_rails_...  (sasaran_id => sasarans.id)
#
class Permasalahan < ApplicationRecord
  belongs_to :sasaran, optional: true

  # validates :permasalahan, presence: true
end
