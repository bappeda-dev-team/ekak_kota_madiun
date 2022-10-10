require "rails_helper"

RSpec.describe GenderAnalysis, type: :model do
  it { should validate_presence_of(:opd) }
  it { should validate_presence_of(:tahun) }
end
