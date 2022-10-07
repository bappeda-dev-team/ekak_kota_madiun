require 'rails_helper'

RSpec.describe "gender", type: :request do
  before(:each) { sign_in(user) }
  let(:user) { create(:user) }

  describe "GET /gender" do
    it "renders a successful response" do
      get gender_path
      expect(response).to be_successful
    end
  end

  describe "GET /gap_gender" do
    it "renders a successful response" do
      get gap_gender_path
      expect(response).to be_successful
    end
  end
end
