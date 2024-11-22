# == Schema Information
#
# Table name: dasar_hukums
#
#  id         :bigint           not null, primary key
#  judul      :string
#  keterangan :string
#  metadata   :jsonb
#  peraturan  :text
#  tahun      :string
#  urutan     :integer          default(1), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  sasaran_id :string
#  usulan_id  :bigint
#
# Foreign Keys
#
#  fk_rails_...  (sasaran_id => sasarans.id_rencana)
#
class DasarHukum < ApplicationRecord
  belongs_to :sasaran, foreign_key: 'sasaran_id', primary_key: 'id_rencana', optional: true
  validates :peraturan, presence: true
  validates :judul, presence: true

  store_accessor :metadata, :judul_dasar_hukum_tim_kerja, :status_dasar_hukum_tim_kerja

  def dasar_hukum
    judul
  end

  def split_dasar_hukum
    judul.split(/\d+\)/).compact_blank
         .flat_map { |jd| jd.strip.gsub(/[.,;]+$/, '') }
  end
end
