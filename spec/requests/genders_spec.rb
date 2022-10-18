require 'rails_helper'

RSpec.describe "gender", type: :request do
  before(:each) { sign_in(user) }
  let(:user) { create(:user) }

  describe "GET /genders/gap" do
    it "renders a successful response" do
      get gap_genders_path
      expect(response).to be_successful
    end
  end

  describe "GET /genders/gbs" do
    it "renders a successful response" do
      get gbs_genders_path
      expect(response).to be_successful
    end
  end
end
