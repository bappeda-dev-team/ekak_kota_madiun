require 'rails_helper'

RSpec.describe "Spbes", type: :request do
  before(:each) do
    cookies[:opd] = 'test_opd'
  end
  describe "GET /new" do
    it "renders a new spbe page" do
      program = FactoryBot.create :program_kegiatan

      get new_spbe_path(program_id: program.id)
      expect(response).to be_successful
    end
  end
end
