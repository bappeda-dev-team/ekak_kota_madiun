require 'rails_helper'

RSpec.describe "Renjas", type: :request do
  describe "GET /rankir.json" do
    context 'with valid params' do
      def valid_params
        kode_opd = FactoryBot.create(:opd).kode_unik_opd
        tahun = '2025'

        { tahun: tahun, kode_opd: kode_opd, format: :json }
      end

      it "returns http success" do
        get "/api/renjas/rankir.json", params: valid_params
        expect(response).to have_http_status(:success)
      end
    end
  end
end
