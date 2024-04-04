# == Schema Information
#
# Table name: jabatan_users
#
#  id         :bigint           not null, primary key
#  bulan      :string           not null
#  id_jabatan :bigint           not null
#  kode_opd   :string           not null
#  nip_asn    :string           not null
#  tahun      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class JabatanUser < ApplicationRecord
  belongs_to :jabatan, primary_key: 'id_jabatan', foreign_key: 'id_jabatan'
  belongs_to :opd, primary_key: 'kode_unik_opd', foreign_key: 'kode_opd'
  belongs_to :user, primary_key: 'nik', foreign_key: 'nip_asn'

  def details
    "#{jabatan.nama_jabatan} (#{bulan}/#{tahun})"
  end

  def nama_jabatan
    jabatan.nama_jabatan
  end
end
