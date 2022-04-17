# frozen_string_literal: true

# == Schema Information
#
# Table name: mandatoris
#
#  id                :bigint           not null, primary key
#  is_active         :boolean          default(FALSE)
#  nip_asn           :string
#  opd               :string
#  peraturan_terkait :string
#  status            :enum             default("draft")
#  tahun             :string
#  uraian            :string
#  usulan            :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  sasaran_id        :bigint
#
# Indexes
#
#  index_mandatoris_on_sasaran_id  (sasaran_id)
#  index_mandatoris_on_status      (status)
#
class Mandatori < ApplicationRecord
  validates :usulan, presence: true
  validates :peraturan_terkait, presence: true

  enum status: { draft: 'draft', pengajuan: 'pengajuan', disetujui: 'disetujui', ditolak: 'ditolak' }

  belongs_to :sasaran, optional: true
  has_many :usulans, as: :usulanable

  default_scope { order(created_at: :desc) }

  def asn_pengusul
    User.find_by(nik: nip_asn).nama
  rescue NoMethodError
    '-'
  end

  def sasaran_aktif?
    sasaran_id.present?
  end

  def asn_aktif?
    nip_asn.present?
  end
end
