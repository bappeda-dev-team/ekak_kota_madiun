# == Schema Information
#
# Table name: tims
#
#  id             :bigint           not null, primary key
#  jabatan        :string
#  jenis          :string
#  keterangan     :string
#  nama_tim       :string
#  nip            :string
#  tahun          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  inovasi_tim_id :bigint           not null
#  opd_id         :bigint
#
# Indexes
#
#  index_tims_on_inovasi_tim_id  (inovasi_tim_id)
#  index_tims_on_opd_id          (opd_id)
#
# Foreign Keys
#
#  fk_rails_...  (inovasi_tim_id => inovasi_tims.id)
#
class Tim < ApplicationRecord
  validates_presence_of :nama_tim
  # validates :tahun, presence: true, format: { with: /(20)\d{2}\z/i, message: 'harus diatas tahun 2000' }

  belongs_to :opd, optional: true
  belongs_to :inovasi_tim

  has_many :anggota_tims
  accepts_nested_attributes_for :anggota_tims, reject_if: :all_blank, allow_destroy: true

  scope :tim_kota, -> { where(jenis: 'Kota') }

  def to_s
    nama_tim
  end

  def tim_kota?
    jenis == 'Kota'
  end

  def all_anggota
    anggota_tims.map(&:nama)
  end
end
