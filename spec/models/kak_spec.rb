require 'rails_helper'

RSpec.describe Kak, type: :model do
  it "bisa dibuat tanpa program kegiatan" do
    expect(Kak.new.program_kegiatan).to be_nil 
  end

  it { is_expected.to belong_to(:user) }
  
  
end
