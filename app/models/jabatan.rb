# == Schema Information
#
# Table name: jabatans
#
#  id            :bigint           not null, primary key
#  id_jabatan    :bigint
#  index         :string
#  kelas_jabatan :string
#  kode_opd      :string
#  nama_jabatan  :string
#  nilai_jabatan :integer
#  tahun         :string
#  tipe          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Jabatan < ApplicationRecord
  has_many :kepegawaians

  STATUS_KEPEGAWAIAN = %w[PNS PPPK Kontrak Upah]

  def to_s
    nama_jabatan
  end

  def jumlah_status_kepegawaian
    kepegawaians.to_h do |pegawai|
      [pegawai.status_kepegawaian, pegawai.jumlah]
    end
  end

  def pendidikan_pegawai
    kepegawaians.flat_map(&:pendidikan_pegawai)
  end
end
