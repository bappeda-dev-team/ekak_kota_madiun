# == Schema Information
#
# Table name: dasar_hukums
#
#  id         :bigint           not null, primary key
#  judul      :string
#  peraturan  :text
#  tahun      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  sasaran_id :string
#
# Foreign Keys
#
#  fk_rails_...  (sasaran_id => sasarans.id_rencana)
#
FactoryBot.define do
  factory :dasar_hukum do
    peraturan { "MyText" }
    judul { "MyString" }
    tahun { "MyString" }
  end
end
