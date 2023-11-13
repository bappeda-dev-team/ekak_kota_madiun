require 'rails_helper'

RSpec.describe "/api/master/pokpirs", type: :request do
  describe "GET /api/master/pokpirs" do
    before(:each) { create(:pokpir, tahun: '2023') }
    it "response with ok status" do
      get '/api/master/pokpirs'
      expect(response).to have_http_status :ok
    end

    it "response with musrenbangs by tahun" do
      get '/api/master/pokpirs', params: { tahun: '2023' }
      expect(response_body.size).to eq 1
    end
  end

  describe "POST /api/master/pokpirs" do
    context "given valid params" do
      valid_params = { tahun: '2023',
                       usulan: 'Usulan A',
                       alamat: 'Jl. XXX',
                       uraian: 'Lampu rusak',
                       opd: 'test_opd' }
      it 'response with created status' do
        expect { post '/api/master/pokpirs', params: { pokpir: valid_params } }.to change { Pokpir.count }.from(0).to(1)

        expect(response).to have_http_status :created
      end
    end
    context "given invalid params" do
      invalid_params = { tahun: '2023',
                         alamat: 'Jl. XXX',
                         uraian: 'Lampu rusak',
                         opd: 'test_opd' }

      it 'response with unprocessable_entity status' do
        post '/api/master/pokpirs',
             params: { pokpir: invalid_params }

        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end

  def response_body
    JSON.parse(response.body)
  end
end
