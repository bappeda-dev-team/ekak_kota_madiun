# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  eselon                 :string
#  jabatan                :string
#  kode_opd               :string
#  nama                   :string
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
# Foreign Keys
#
#  fk_rails_...  (kode_opd => opds.kode_opd)
#
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:nama) }
    it { should validate_presence_of(:nik) }
    it { should validate_presence_of(:password) }
  end
end
