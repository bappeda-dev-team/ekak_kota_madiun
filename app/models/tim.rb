# == Schema Information
#
# Table name: tims
#
#  id          :bigint           not null, primary key
#  jabatan     :string
#  jenis       :string
#  keterangan  :string
#  nama_tim    :string
#  nip         :string
#  tahun       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  opd_id      :bigint
#  team_ref_id :bigint
#
# Indexes
#
#  index_tims_on_opd_id  (opd_id)
#
class Tim < ApplicationRecord
  belongs_to :opd, optional: true
  validates_presence_of :tahun

  scope :tim_kota, -> { where(jenis: 'Kota') }

  def tim_kota?
    jenis == 'Kota'
  end
end
