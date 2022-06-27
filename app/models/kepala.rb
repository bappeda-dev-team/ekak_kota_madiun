class Kepala < User
  # has_many :atasans, foreign_key: :atasan, primary_key: :nik
  has_many :users, foreign_key: :atasan, primary_key: :nik
end
