class User < ApplicationRecord
  validates :nama, presence: true
  validates :nik, presence: true
  validates :password, presence: true
end
