require 'rails_helper'

RSpec.describe "Laporans", type: :request do
  describe "GET /atasan" do
    it "returns http success" do
      get "/laporans/atasan"
      expect(response).to have_http_status(:success)
    end
  end

end
