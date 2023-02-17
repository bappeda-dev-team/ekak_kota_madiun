require 'rails_helper'

RSpec.describe "PohonKinerjas", type: :request do
  describe "GET /kota" do
    it "returns http success" do
      get "/pohon_kinerja/kota"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /opd" do
    it "returns http success" do
      get "/pohon_kinerja/opd"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /asn" do
    it "returns http success" do
      get "/pohon_kinerja/asn"
      expect(response).to have_http_status(:success)
    end
  end

end
