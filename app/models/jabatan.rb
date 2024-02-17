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
  has_many :kepegawaians
  has_many :pendidikan_terakhirs, through: :kepegawaians
  accepts_nested_attributes_for :kepegawaians

  belongs_to :jenis_jabatan
  validates :nama_jabatan, presence: true, length: { minimum: 5 }
  after_validation { nama_jabatan.upcase! }

  STATUS_KEPEGAWAIAN = %w[PNS PPPK Kontrak Upah]

  def to_s
    nama_jabatan
  end

  def jumlah_status_kepegawaian(tahun)
    kepegawaians.where(tahun: tahun).to_h do |pegawai|
      [pegawai.status_kepegawaian, pegawai.jumlah]
    end
  end

  def update_jumlah_kepegawaian(tahun, status, jumlah)
    kepegawaians.where(tahun: tahun, status_kepegawaian: status)
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
