# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  eselon                 :string
#  id_bidang              :bigint
#  jabatan                :string
#  kode_opd               :string
#  nama                   :string
#  nama_bidang            :string
#  nama_pangkat           :string
#  nik                    :string
#  pangkat                :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_nik                   (nik) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable
  # validates :nama, presence: true
  # validates :nik, presence: true
  belongs_to :opd, foreign_key: 'kode_opd', primary_key: 'kode_opd'
  has_many :kaks
  has_many :sasarans, dependent: :destroy, foreign_key: 'nip_asn', primary_key: 'nik'
  # has_many :program_kegiatans, through: :sasarans

  scope :asn_aktif, -> { includes(:roles).where(roles: { name: 'asn' }) }
  scope :sasaran_diajukan, -> { asn_aktif.includes(:sasarans, :program_kegiatans).merge(Sasaran.sudah_lengkap) }

  after_create :assign_default_role

  validates :nama, presence: true
  validates :nik, presence: true

  attr_writer :login

  def login
    @login || nik || email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions.to_h).where(['lower(nik) = :value OR lower(email) = :value',
                                    { value: login.downcase }]).first
    elsif conditions.key?(:nik) || conditions.key?(:email)
      where(conditions.to_h).first
    end
  end

  def assign_default_role
    add_role(:non_aktif) if roles.blank?
  end

  def sasaran_aktif
    program = program_kegiatan_sasarans.count
    usulan = sasarans.map(&:usulans).flatten.count
    {
      program_aktif: program,
      usulan_aktif: usulan
    }
  end

  def program_kegiatan_sasarans
    @program_kegiatan_sasarans ||= sasarans.map(&:program_kegiatan).compact.uniq
  end

  def jumlah_sasaran
    @program_kegiatan_sasarans.map { |j| j.sasarans.count }.flatten.reduce(:+)
  end

  def jumlah_anggaran
    @program_kegiatan_sasarans.map { |j| j&.my_pagu }.flatten.reduce(:+)
  end

  def petunjuk_sasaran
    {
      merah: total_hangus,
      kuning: kurang_lengkap,
      biru: biru,
      hijau: hijau
    }
  end

  def pegawai_kelurahan?
    jabatan.upcase.include?('KELURAHAN')
  end

  def petunjuk_kelurahan
    jabatan.split(/KELURAHAN/, 2).last.strip if pegawai_kelurahan?
  end

  def pegawai_rsud?
    nama_bidang.upcase.include?('RUMAH SAKIT') unless nama_bidang.nil?
  end

  def pegawai_bagian?
    nama_bidang.upcase.include?('BAGIAN') unless nama_bidang.nil?
  end

  def petunjuk_bagian
    nama_bidang.upcase.split(/BAGIAN/, 2).last.strip if pegawai_bagian?
  end

  def petunjuk_status
    @petunjuk_status ||= sasarans.map(&:petunjuk_status)
  end

  def biru
    @biru ||= petunjuk_status.select { |s| s[:usulan_dan_sub] }.select { |j| j.except(:usulan_dan_sub).values.any?(false) }.count
  end

  def hijau
    @hijau ||= petunjuk_status.map(&:values).select { |s| s.all?(true) }.count
  end

  def total_hangus
    @total_hangus ||= sasarans.total_hangus
  end

  def kurang_lengkap
    @kurang_lengkap ||= sasarans.select { |s| s.usulans.exists? && s.belum_ada_sub? }.count
  end
end
