class User < ApplicationRecord
  validates :nama, presence: true
  validates :nik, presence: true
  validates :password, presence: true
  belongs_to :opd
  has_many :pks
  has_many :kaks
end
