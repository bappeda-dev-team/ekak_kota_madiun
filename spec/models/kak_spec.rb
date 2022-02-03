# == Schema Information
#
# Table name: kaks
#
#  id                  :bigint           not null, primary key
#  dasar_hukum         :text             default([]), is an Array
#  tujuan              :text             default([]), is an Array
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  user_id             :bigint           not null
#  program_kegiatan_id :bigint
#
require 'rails_helper'

RSpec.describe Kak, type: :model do
  it "bisa dibuat tanpa program kegiatan" do
    expect(Kak.new.program_kegiatan).to be_nil 
  end

  it { is_expected.to belong_to(:user) }
  
  
end
