# == Schema Information
#
# Table name: inovasis
#
#  id         :bigint           not null, primary key
#  is_active  :boolean          default(FALSE)
#  manfaat    :string
#  nip_asn    :string
#  opd        :string
#  status     :enum             default("draft")
#  tahun      :string
#  usulan     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  sasaran_id :bigint
#
# Indexes
#
#  index_inovasis_on_sasaran_id  (sasaran_id)
#  index_inovasis_on_status      (status)
#
class Inovasi < ApplicationRecord
  validates :usulan, presence: true

  enum status: { draft: 'draft', pengajuan: 'pengajuan', disetujui: 'disetujui', ditolak: 'ditolak' }

  belongs_to :sasaran, optional: true
  has_many :usulans, as: :usulanable

  default_scope { order(created_at: :desc) }

  def asn_pengusul
    User.find_by(nik: nip_asn).nama
  rescue NoMethodError
    '-'
  end

  def self.type
    'Inisiatif'
  end
end
