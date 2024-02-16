# == Schema Information
#
# Table name: jenis_jabatans
#
#  id         :bigint           not null, primary key
#  keterangan :string
#  nama_jenis :string           default("Jabatan Fungsional"), not null
#  nilai      :integer          default(3), not null
#  tahun      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class JenisJabatan < ApplicationRecord
  def to_s
    nama_jenis
  end
end
