# == Schema Information
#
# Table name: tahapans
#
#  id               :bigint           not null, primary key
#  bulan            :string
#  id_rencana       :string
#  id_rencana_aksi  :string
#  jumlah_realisasi :integer
#  jumlah_target    :integer
#  keterangan       :string
#  progress         :integer
#  realisasi        :integer
#  tahapan_kerja    :string
#  target           :integer
#  urutan           :string
#  waktu            :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  sasaran_id       :bigint
#
# Indexes
#
#  index_tahapans_on_id_rencana_aksi  (id_rencana_aksi) UNIQUE
#
class Tahapan < ApplicationRecord
  belongs_to :sasaran, foreign_key: 'id_rencana', primary_key: 'id_rencana', optional: true, inverse_of: :tahapans
  has_many :aksis, foreign_key: 'id_rencana_aksi', primary_key: 'id_rencana_aksi', dependent: :destroy, inverse_of: :tahapan
  has_many :anggarans, dependent: :destroy
  has_many :comments, through: :anggarans

  validates :tahapan_kerja, presence: true

  default_scope { order('urutan::integer ASC') }

  amoeba do
    append id_rencana: '_2022_p'
    append id_rencana_aksi: '_2022_p'
    exclude_association %i[comments aksis]
  end

  def sync_total_renaksi
    aksis.each(&:sync_total)
  end

  def find_target_bulan(bulan)
    aksis.find_by_bulan(bulan).target
  rescue NoMethodError
    '-'
  end

  def target_total
    jumlah_target.nil? ? '-' : jumlah_target
  end

  def anggaran_tahapan
    anggarans.compact.sum(&:jumlah)
  rescue NoMethodError
    '0'
  end

  def total_anggaran_tahapan_setelah_komentar
    anggarans.where.missing(:comments).compact.sum(&:jumlah)
  rescue NoMethodError
    '0'
  end

  def anggaran_tahapan_dengan_komentar
    anggarans.select { |a| a.comments.any? }.map { |an| an.jumlah}
  rescue NoMethodError
    '0'
  end

  def ada_komentar?
    anggarans.map(&:comments).any?(&:present?)
  end
end
