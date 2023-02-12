require "rails_helper"

RSpec.describe "IsuStrategisKota", type: :request do
  describe "GET /index" do
    it "show isu strategis kota entries" do
      get "/index"
      expect(response).to have_http_status(:success)
    end
  end
end
