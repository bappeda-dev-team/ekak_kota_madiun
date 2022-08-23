require 'rails_helper'

RSpec.describe "IsuDanPermasalahans", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/isu_dan_permasalahans/index"
      expect(response).to have_http_status(:success)
    end
  end

end
