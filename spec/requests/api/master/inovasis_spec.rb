require 'rails_helper'

RSpec.describe "/api/master/inovasis", type: :request do
  describe "GET /api/master/inovasis" do
    it "response with ok status" do
      user = create(:user)
      inisiatif = create(:inovasi, tahun: '2023', nip_asn: user.nik)

      get "/api/master/inovasis", params: { kode_opd: user.opd.kode_unik_opd }
      expect(response).to have_http_status :ok
    end

    it "response with musrenbangs by tahun" do
      user = create(:user)
      inisiatif = create(:inovasi, tahun: '2023', nip_asn: user.nik)

      get "/api/master/inovasis", params: { kode_opd: user.opd.kode_unik_opd, tahun: '2023' }
      results = response_body["results"]
      expect(results.first["usulan"]).to eq inisiatif.usulan
    end
  end

  def response_body
    JSON.parse(response.body)
  end
end
