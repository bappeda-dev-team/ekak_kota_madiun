require 'rails_helper'

RSpec.describe "Renjas", type: :request do
  describe "GET /api/rankir.json" do
    def valid_params
      kode_opd = FactoryBot.create(:opd).kode_unik_opd
      tahun = '2025'

      { tahun: tahun, kode_opd: kode_opd, format: :json }
    end

    def invalid_params
      { tahun: '', kode_opd: '', format: :json }
    end

    context 'with valid params' do
      it "returns http success" do
        get "/api/renjas/rankir.json", params: valid_params
        expect(response).to have_http_status(:success)
      end
    end

    context 'with invalid params' do
      it 'returns http not_found' do
        get '/api/renjas/rankir.json', params: invalid_params
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
