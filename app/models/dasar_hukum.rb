# == Schema Information
#
# Table name: dasar_hukums
#
#  id         :bigint           not null, primary key
#  judul      :string
#  keterangan :string
#  peraturan  :text
#  tahun      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  sasaran_id :string
#
# Foreign Keys
#
#  fk_rails_...  (sasaran_id => sasarans.id_rencana)
#
class DasarHukum < ApplicationRecord
  belongs_to :sasaran, foreign_key: 'sasaran_id', primary_key: 'id_rencana', optional: true
  validates :peraturan, presence: true
  validates :judul, presence: true
end
