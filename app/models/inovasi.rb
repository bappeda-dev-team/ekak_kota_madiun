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
#  tahun        :string
#  uraian       :string
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

  enum status: { draft: 'draft', pengajuan: 'pengajuan', disetujui: 'disetujui', aktif: 'aktif',
                 ditolak: 'ditolak', menunggu_persetujuan: 'menunggu_persetujuan' }

  belongs_to :sasaran, optional: true
  belongs_to :user, optional: true, foreign_key: 'nip_asn', primary_key: 'nik'
  belongs_to :opd_pemilik, class_name: 'Opd',
                           optional: true, foreign_key: 'opd', primary_key: 'kode_unik_opd'
  belongs_to :misi

  has_many :usulans, as: :usulanable, dependent: :destroy

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
end
