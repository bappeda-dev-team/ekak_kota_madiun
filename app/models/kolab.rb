# == Schema Information
#
# Table name: kolabs
#
#  id             :bigint           not null, primary key
#  jenis          :string
#  keterangan     :string
#  kode_unik_opd  :string
#  kolabable_type :string
#  status         :string
#  tahun          :string
#  urutan         :integer          default(0)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  kolabable_id   :bigint
#
class Kolab < ApplicationRecord
  validates :kolabable_id, presence: true
  validates :kolabable_type, presence: true

  STATUS_KOLAB = %w[Lead Anggota].freeze

  belongs_to :kolabable, polymorphic: true
  belongs_to :opd, foreign_key: "kode_unik_opd", primary_key: "kode_unik_opd", optional: true

  # khusus inovasi walkot
  def jumlah_rekin_opd
    kolabable.all_usulans.count { |usulan| usulan.opd_rekin&.id == opd&.id }
  rescue NoMethodError
    0
  end

  # khusus inovasi walkot
  def kolaborator_mengisi_rekin?
    jumlah_rekin_opd.positive?
  end

  def sebagai
    "(#{status})"
  end

  def lead_kolab
    status == 'Lead'
  end

  def ada_kolab_opd?(kode_opd)
    kode_unik_opd.in?(kode_opd)
  end
end
