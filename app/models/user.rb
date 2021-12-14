class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # validates :nama, presence: true
  # validates :nik, presence: true
  # belongs_to :opd
  has_many :pks
  has_many :kaks
  has_many :sasarans, dependent: :destroy
end
