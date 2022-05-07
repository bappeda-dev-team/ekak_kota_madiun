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

  scope :asn_aktif, -> { includes(:roles).where(roles: { name: 'asn' }) }

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
    add_role(:asn) if roles.blank?
  end
end
