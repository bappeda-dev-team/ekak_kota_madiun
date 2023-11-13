require 'rails_helper'

RSpec.describe "Api::Masters", type: :request do

  describe "GET /usulan_musrenbang" do
    it "response with ok status" do
      musrenbang = create(:musrenbang, tahun: '2023')

      get api_master_usulan_musrenbang_path(format: :json)
      expect(response).to have_http_status :ok
    end

    it "response with musrenbangs by tahun" do
      musrenbang = create(:musrenbang, tahun: '2023')

      get api_master_usulan_musrenbang_path(tahun: '2023',format: :json)
      results = response_body["results"]
      expect(results.first["usulan"]).to eq musrenbang.usulan
    end
  end

  def response_body
    JSON.parse(response.body)
  end
end
