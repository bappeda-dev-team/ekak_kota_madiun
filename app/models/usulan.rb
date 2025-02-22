# == Schema Information
#
# Table name: usulans
#
#  id              :bigint           not null, primary key
#  keterangan      :string
#  tahun           :string
#  usulanable_type :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  opd_id          :bigint
#  sasaran_id      :bigint
#  usulanable_id   :bigint
#
# Indexes
#
#  index_usulans_on_opd_id      (opd_id)
#  index_usulans_on_sasaran_id  (sasaran_id)
#  index_usulans_on_usulanable  (usulanable_type,usulanable_id)
#
class Usulan < ApplicationRecord
  belongs_to :sasaran, optional: true
  belongs_to :usulanable, polymorphic: true
  belongs_to :opd, optional: true
  # has_many :pohons, lambda {
  #                     where(usulanable_type: %w[StrategiKotum Musrenbang Pokpir])
  #                   }, as: :pohonable
  scope :inovasi, -> { where(usulanable_type: 'Inovasi') }

  def usulan
    usulanable.usulan
  end

  def deskripsi
    usulanable.deskripsi
  end

  def with_sasaran?
    sasaran_id.present?
  end

  def uraian
    usulanable.uraian
  end

  def pokin_inovasi
    sasaran.strategi
  rescue NoMethodError
    'Kosong'
  end

  def rekin_inovasi
    sasaran.sasaran_kinerja
  rescue NoMethodError
    'Kosong'
  end

  def pemilik_rekin
    sasaran.nama_pemilik
  rescue NoMethodError
    'Kosong'
  end

  def program_kegiatan_rekin
    sasaran.program_kegiatan
  end

  def subkegiatan_rekin
    program_kegiatan_rekin.nama_subkegiatan
  rescue NoMethodError
    'Kosong'
  end

  def program_rekin
    program_kegiatan_rekin.nama_program
  rescue NoMethodError
    'Kosong'
  end

  def pagu_rekin
    sasaran.total_anggaran
  rescue NoMethodError
    0
  end

  def opd_rekin
    sasaran.opd
  rescue NoMethodError
    'Kosong'
  end

  def inovasi_rekin
    sasaran.inovasi_sasaran
  rescue NoMethodError
    'Kosong'
  end
end
