# == Schema Information
#
# Table name: inovasis
#
#  id           :bigint           not null, primary key
#  is_active    :boolean          default(FALSE)
#  is_from_kota :boolean          default(FALSE)
#  manfaat      :string
#  nip_asn      :string
#  opd          :string
#  status       :enum             default("draft")
#  tag          :string
#  tag_active   :boolean          default(FALSE)
#  tahun        :string
#  uraian       :string
#  uraian_tag   :string
#  usulan       :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  misi_id      :bigint
#  sasaran_id   :bigint
#
# Indexes
#
#  index_inovasis_on_misi_id     (misi_id)
#  index_inovasis_on_sasaran_id  (sasaran_id)
#  index_inovasis_on_status      (status)
#
# Foreign Keys
#
#  fk_rails_...  (misi_id => misis.id)
#
class Inovasi < ApplicationRecord
  validates :usulan, presence: true
  validates :manfaat, presence: true
  validates :uraian, presence: true
  validates :opd, presence: true
  validates :misi_id, presence: true

  enum status: { draft: 'draft', pengajuan: 'pengajuan', disetujui: 'disetujui', aktif: 'aktif',
                 ditolak: 'ditolak', menunggu_persetujuan: 'menunggu_persetujuan' }

  TAG_INOVASI = ['100 Hari Kerja', '-'].freeze

  belongs_to :sasaran, optional: true
  belongs_to :user, optional: true, foreign_key: 'nip_asn', primary_key: 'nik'
  belongs_to :opd_pemilik, class_name: 'Opd',
                           optional: true, foreign_key: 'opd', primary_key: 'kode_unik_opd'
  belongs_to :misi

  has_many :usulans, as: :usulanable, dependent: :destroy
  has_many :reviews, as: :reviewable, dependent: :destroy
  has_many :kolabs, as: :kolabable, dependent: :destroy

  default_scope { order(created_at: :desc) }

  scope :by_periode, lambda { |tahun_awal, tahun_akhir|
                       where("tahun::integer BETWEEN ?::integer AND ?::integer", tahun_awal, tahun_akhir)
                     }

  def to_s
    uraian
  end

  def asn_pengusul
    if nip_asn.present?
      User.find_by(nik: nip_asn).nama
    else
      'Kota'
    end
  rescue NoMethodError
    '-'
  end

  def opd_asn
    User.find_by(nik: nip_asn).opd.nama_opd
  rescue NoMethodError
    '-'
  end

  def opd_inovasi
    if opd.first.match?(/\p{Alpha}/)
      opd
    else
      Opd.unscoped.find_by(kode_unik_opd: opd).to_s
    end
  rescue NoMethodError
    '-'
  end

  def opd_lead
    opd_inovasi
  end

  def kode_opd_lead
    kolabs.find_by(status: 'Lead').opd.kode_unik_opd
  rescue NoMethodError
    '0.00.0.00.0.00.00.0000'
  end

  def self.type
    'Inisiatif'
  end

  def sasaran_aktif?
    sasaran_id.present?
  end

  def asn_aktif?
    nip_asn.present?
  end

  def usulan_tahun
    "#{usulan} (#{tahun})"
  end

  def deskripsi
    manfaat
  end

  def dari_kota?
    is_from_kota
  end

  def misi_with_urutan
    misi.misi_with_urutan
  rescue NoMethodError
    'Belum dipilih'
  end

  # gunakan jika diusulkan oleh user

  def pokin_inovasi_user
    sasaran.strategi
  rescue NoMethodError
    'Kosong'
  end

  def rekin_inovasi_user
    sasaran.sasaran_kinerja
  rescue NoMethodError
    'Kosong'
  end

  def pemilik_rekin_user
    sasaran.nama_pemilik
  rescue NoMethodError
    'Kosong'
  end

  def program_kegiatan_rekin_user
    sasaran.program_kegiatan
  end

  def subkegiatan_rekin_user
    program_kegiatan_rekin.nama_subkegiatan
  rescue NoMethodError
    'Kosong'
  end

  def program_rekin_user
    program_kegiatan_rekin.nama_program
  rescue NoMethodError
    'Kosong'
  end

  def pagu_rekin_user
    sasaran.total_anggaran
  rescue NoMethodError
    0
  end

  def opd_rekin_user
    sasaran.opd
  rescue NoMethodError
    'Kosong'
  end

  def inovasi_rekin_user
    sasaran.inovasi_sasaran
  rescue NoMethodError
    'Kosong'
  end
  # end gunakan jika diusulkan oleh user

  def all_usulans
    usulans.includes(sasaran: %i[user opd strategi program_kegiatan])
           .select(&:with_sasaran?)
           .sort_by do |us|
      sebagai = us.usulanable.kolabs.map(&:status)
      sebagai == 'Lead' ? 0 : 1
    end
  end

  def rowspan_usulans
    all_usulans.size + 1
  rescue NoMethodError
    1
  end

  def total_pagu_usulans
    all_usulans.sum(&:pagu_rekin)
  end

  def pengambil_pertama
    all_usulans.first
  end

  def tag_dan_status
    uraian_status = tag_active && 'Aktif'
    tag_active ? "#{tag}  [ #{uraian_status} ]" : ''
  end

  private

  # for NoMethodError string
  def default_blank_fallback
    'Kosong'
  end
end
