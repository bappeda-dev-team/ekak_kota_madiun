require 'rails_helper'

RSpec.describe '/api/renstra', type: :request do
  let(:opd) { create(:opd) }
  describe 'GET /api/renstra' do
    it 'should return http success' do
      create(:opd)
      get '/api/renstras.json?periode=2019-2024&kode_opd=test_opd&tahun=2024'
      expect(response).to have_http_status(:success)
    end
  end
end
