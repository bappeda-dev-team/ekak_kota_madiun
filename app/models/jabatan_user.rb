# == Schema Information
#
# Table name: jabatan_users
#
#  id         :bigint           not null, primary key
#  bulan      :string           not null
#  id_jabatan :bigint           not null
#  kode_opd   :string           not null
#  nip_asn    :string           not null
#  status     :string           default("aktif")
#  tahun      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class JabatanUser < ApplicationRecord
  belongs_to :jabatan, primary_key: 'id_jabatan', foreign_key: 'id_jabatan'
  belongs_to :opd, primary_key: 'kode_unik_opd', foreign_key: 'kode_opd'
  belongs_to :user, primary_key: 'nik', foreign_key: 'nip_asn'

  STATUS_JABATAN_USER = %w[aktif pensiun plt].freeze

  def details
    "#{jabatan.nama_jabatan} (#{bulan}/#{tahun})"
  end

  def nama_jabatan
    jabatan.nama_jabatan
  end

  def bulan_tahun
    "#{bulan}/#{tahun}"
  end

  def jabatan_status
    "#{nama_jabatan} - [#{status}]"
  end

  def aktif?
    status == 'aktif'
  end

  def plt?
    status == 'plt'
  end
end
