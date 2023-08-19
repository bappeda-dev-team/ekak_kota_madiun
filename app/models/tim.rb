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
  belongs_to :parent, class_name: 'Tim',
                      primary_key: :id,
                      foreign_key: :team_ref_id,
                      optional: true
  validates_presence_of :nama_tim
  validates :tahun, presence: true, format: { with: /(20)\d{2}\z/i, message: 'harus diatas tahun 2000' }

  scope :tim_kota, -> { where(jenis: 'Kota') }

  def tim_kota?
    jenis == 'Kota'
  end

  def parent_tim
    parent
  end

  def sub_tims
    Tim.where(team_ref_id: id)
  end
end
