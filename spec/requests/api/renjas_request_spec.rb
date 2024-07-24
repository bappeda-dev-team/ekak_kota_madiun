require 'rails_helper'

RSpec.describe "Renjas", type: :request do
  let(:opd) { FactoryBot.create(:opd) }
  let(:tahun) { '2025' }
  def valid_params
    kode_opd = opd.kode_unik_opd

    { tahun: tahun, kode_opd: kode_opd, format: :json }
  end

  def invalid_params
    { tahun: '', kode_opd: '', format: :json }
  end

  describe "GET /api/rankir.json" do
    context 'with valid params' do
      it "returns http success" do
        get '/api/renjas/rankir', params: valid_params
        expect(response).to have_http_status(:success)
      end
    end

    context 'with invalid params' do
      it 'returns http not_found' do
        get '/api/renjas/rankir', params: invalid_params
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "GET /api/rankir_program.json" do
    context 'with valid params' do
      it 'returns http success' do
        get '/api/renjas/rankir_program', params: valid_params
        expect(response).to have_http_status(:success)
      end

      it 'returns nama message, nama_opd, tahun, programs' do
        get '/api/renjas/rankir_program', params: valid_params

        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json).to eq({
                             message: 'Rankir Renja - Program - KAK',
                             nama_opd: opd.nama_opd,
                             tahun: tahun,
                             programs: []
                           })
      end
    end
  end
end
