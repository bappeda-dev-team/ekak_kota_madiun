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
#  metadata         :jsonb
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
  has_many :aksis, lambda {
                     where.not(id_rencana_aksi: [nil, ''])
                          .order('bulan ASC')
                   }, foreign_key: 'id_rencana_aksi', primary_key: 'id_rencana_aksi', dependent: :nullify,
                      inverse_of: :tahapan
  has_many :anggarans, dependent: :nullify
  has_many :comments, through: :anggarans

  has_many :reviews, -> { where(reviewable_type: 'Tahapan') }, foreign_key: :reviewable_id, primary_key: :id
  validates :tahapan_kerja, presence: true

  default_scope { order(Arel.sql("nullif(regexp_replace(urutan, '[^0-9]', '', 'g'),'')::int")) }

  store_accessor :metadata, :tagging, :tahun_tagging

  def to_s
    tahapan_kerja
  end

  def sync_total_renaksi
    aksi_bulan_fixer
    self.jumlah_target = 0 if id_rencana_aksi.nil?
    self.id_rencana_aksi = SecureRandom.base36(6) if id_rencana_aksi.nil?
    save
    aksis.each(&:sync_total)
  end

  def find_target_bulan(bulan)
    aksis.find_by_bulan(bulan).target
  rescue NoMethodError
    '-'
  end

  def ada_target_bulan?(bulan)
    find_target_bulan(bulan).present? && find_target_bulan(bulan) != '-'
  end

  def tahapan_valid?
    jumlah_target.positive?
  rescue NoMethodError
    false
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

  def rtp_mr?
    tagging == "RTP-MR" && tahapan_valid?
  end

  def tahapan_rtp
    tag_mr = rtp_mr? ? "- [#{tagging}]" : ''
    "#{tahapan_kerja} #{tag_mr}"
  end

  def bulan_aksi
    (1..12).flat_map { |bulan| [{ bulan => 0 }] }
  end

  def aksi_map_bulan
    target_aksi_bulans = aksis.flat_map do |aksi|
      [{ aksi.bulan => aksi.target }]
    end
    target_aksi_bulans ||= []
    # bulan_aksi.reduce(&:merge).merge(target_aksi_bulans.reduce(&:merge))
    bulan_aksi.reduce(&:merge).merge(target_aksi_bulans.reduce({}, :merge))
  end

  def tahapan_with_rtp_tag
    rtp_mr? ? "- [#{tagging}]" : ''
  end

  def default_urutan
    last_urutan = sasaran.default_urutan_tahapan

    if urutan.present?
      urutan
    else
      last_urutan
    end
  end

  def grand_parent_anggaran
    anggarans.includes(%i[rekening pagu_anggaran]).order(:created_at).group_by do |angg|
      angg&.rekening&.grand_parent&.kode_rekening
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

  def aksis_bulan(bulan: '')
    bulan = bulan.to_i
    if bulan.positive? && bulan <= 12
      aksis.where(bulan: bulan.to_i)
    else
      aksis
    end
  end

  private

  # def double_aksi_bulan?(bulan)
  #   aksis.where(bulan: bulan).size > 1
  # end

  def aksi_bulan_fixer
    aksis.group(:bulan).having('COUNT(*) > 1').pluck(:bulan).each do |bulan|
      redundant_aksis = aksis.where(bulan: bulan).order(:created_at).offset(1)
      redundant_aksis.destroy_all
    end
  end
end
