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
  has_many :aksis, foreign_key: 'id_rencana_aksi', primary_key: 'id_rencana_aksi', dependent: :destroy,
                   inverse_of: :tahapan
  has_many :anggarans, dependent: :destroy
  has_many :comments, through: :anggarans

  validates :tahapan_kerja, presence: true

  default_scope { order(Arel.sql("nullif(regexp_replace(urutan, '[^0-9]', '', 'g'),'')::int")) }

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

  def anggaran_tahapan_penetapan
    anggarans.compact.sum(&:anggaran_penetapan)
  rescue NoMethodError
    '0'
  end

  def anggaran_tahapan_rankir_1
    anggarans.compact.sum(&:anggaran_rankir_1)
  rescue NoMethodError
    '0'
  end

  def total_anggaran_tahapan_setelah_komentar
    anggarans.where.missing(:comments).compact.sum(&:jumlah)
  rescue NoMethodError
    '0'
  end

  def anggaran_tahapan_dengan_komentar
    anggarans.select { |a| a.comments.any? }.map(&:jumlah)
  rescue NoMethodError
    '0'
  end

  def ada_komentar?
    anggarans.map(&:comments).any?(&:present?)
  end

  def grand_parent_anggaran
    anggarans.includes(%i[rekening pagu_anggaran]).order(:created_at).group_by do |angg|
      angg.rekening.grand_parent.kode_rekening
    end
  end

  def jumlah_anggaran_grand_parent
    grand_parent_anggaran.transform_values do |val|
      val.map { |ss| ss.jumlah.to_i }
    end
  end

  def total_anggaran_grand_parent
    jumlah_anggaran_grand_parent.transform_values do |val|
      val.inject(:+)
    end
  end

  def jumlah_grand_parent(kode_rekening)
    grand_parent_anggaran[kode_rekening].sum(&:jumlah)
  end

  def jumlah_grand_parent_penetapan(kode_rekening)
    grand_parent_anggaran[kode_rekening].sum(&:anggaran_penetapan)
  end

  def rekening_anggaran
    anggarans.includes(:rekening)
  end
end
