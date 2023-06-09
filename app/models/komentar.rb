# == Schema Information
#
# Table name: komentars
#
#  id         :bigint           not null, primary key
#  item       :bigint
#  judul      :string
#  kode_opd   :string
#  komentar   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_komentars_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Komentar < ApplicationRecord
  belongs_to :user
  has_one :opd, foreign_key: :kode_unik_opd, primary_key: :kode_opd

  def strategi
    Strategi.find(item)
  end

  def komentator
    user.nama
  end
end
