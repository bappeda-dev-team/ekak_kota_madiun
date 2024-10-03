# == Schema Information
#
# Table name: jabatans
#
#  id               :bigint           not null, primary key
#  id_jabatan       :bigint
#  index            :string
#  kelas_jabatan    :string
#  kode_opd         :string
#  nama_jabatan     :string
#  nilai_jabatan    :integer
#  tahun            :string
#  tipe             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  jenis_jabatan_id :bigint
#
# Indexes
#
#  index_jabatans_on_jenis_jabatan_id  (jenis_jabatan_id)
#
class Jabatan < ApplicationRecord
  has_many :kepegawaians, inverse_of: :jabatan, dependent: :destroy
  has_many :pendidikans, dependent: :destroy
  has_many :jabatan_users, foreign_key: 'id_jabatan', primary_key: 'id_jabatan', dependent: :destroy

  accepts_nested_attributes_for :kepegawaians
  accepts_nested_attributes_for :pendidikans

  belongs_to :jenis_jabatan
  belongs_to :opd, foreign_key: 'kode_opd', primary_key: 'kode_unik_opd'
  validates :nama_jabatan, presence: true, length: { minimum: 5 }
  after_validation { nama_jabatan.upcase! }

  STATUS_KEPEGAWAIAN = %w[PNS PPPK Kontrak Upah].freeze
  PENDIDIKAN_PEGAWAI = %w[SD/SMP SMA D1/D3 D4/S1 S2/S3].freeze

  def to_s
    nama_jabatan
  end

  def jumlah_status_kepegawaian(tahun)
    status_pegawai = kepegawaians.where(tahun: tahun).sort_by do |pegawai|
      STATUS_KEPEGAWAIAN.index(pegawai.status_kepegawaian)
    end

    status_pegawai.to_h do |pegawai|
      [pegawai.status_kepegawaian, pegawai.jumlah.to_i]
    end
  end

  def jumlah_pendidikan(tahun)
    pendidikan_pegawai = pendidikans.where(tahun: tahun).sort_by do |pendidikan|
      PENDIDIKAN_PEGAWAI.index(pendidikan.pendidikan)
    end

    pendidikan_pegawai.to_h do |pendidikan|
      [pendidikan.pendidikan, pendidikan.jumlah.to_i]
    end
  end

  def update_jumlah_kepegawaian(tahun, status, jumlah)
    kepegawaians.where(tahun: tahun, status_kepegawaian: status)
                .update_all(jumlah: jumlah)
  end

  def update_jumlah_pendidikan(tahun, pendidikan, jumlah)
    pendidikans.where(tahun: tahun, pendidikan: pendidikan)
               .update_all(jumlah: jumlah)
  end

  def pendidikan_pegawai(tahun)
    kepegawaians.where(tahun: tahun).flat_map(&:pendidikan_pegawai)
  end

  def tambah_pendidikan_kepegawaian(tambah_pendidikan)
    kepegawaians.map do |kp|
      tambah_pendidikan.each do |pt|
        kp.pendidikan_terakhirs.create({
                                         pendidikan: pt,
                                         keterangan: '-'
                                       })
      end
    end
  end

  def hapus_pendidikan_kepegawaian(hapus_pendidikan)
    pendidikan_terakhirs
      .where(pendidikan: hapus_pendidikan)
      .destroy_all
  end

  def nama_jenis_jabatan
    jenis_jabatan.to_s
  end
end
