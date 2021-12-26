require 'rails_helper'

RSpec.describe Hukum, type: :model do
  it "harus punya kak" do
    expect(Hukum.new.kak).to be_falsey
  end
end
