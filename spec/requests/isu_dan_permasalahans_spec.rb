require 'rails_helper'

RSpec.describe "IsuDanPermasalahans", type: :request do
  before(:each) { sign_in(user) }

  let(:user) { create(:user) }

  describe "GET /index" do
    it "returns http success" do
      get "/isu_dan_permasalahans"
      expect(response).to have_http_status(:success)
    end
  end
end
