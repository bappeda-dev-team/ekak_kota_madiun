require 'rails_helper'

RSpec.describe "/api/master/musrenbangs", type: :request do
  describe "GET /api/master/musrenbangs" do
    it "response with ok status" do
      musrenbang = create(:musrenbang, tahun: '2023')

      get '/api/master/musrenbangs'
      expect(response).to have_http_status :ok
    end

    it "response with musrenbangs by tahun" do
      musrenbang = create(:musrenbang, tahun: '2023')

      get '/api/master/musrenbangs', params: { tahun: '2023'}
      results = response_body["results"]
      expect(results.first["usulan"]).to eq musrenbang.usulan
    end
  end

  describe "POST /api/master/musrenbangs" do
    context "given valid params" do
      valid_params = { tahun: '2023',
                       usulan: 'Usulan A',
                       alamat: 'Jl. XXX',
                       uraian: 'Lampu rusak',
                       opd: 'test_opd' }
      it 'response with created status' do
        expect { post '/api/master/musrenbangs', params: { musrenbang: valid_params } }.to change { Musrenbang.count }.from(0).to(1)

        expect(response).to have_http_status :created
      end
    end
    context "given invalid params" do
      invalid_params = { tahun: '2023',
                         alamat: 'Jl. XXX',
                         uraian: 'Lampu rusak',
                         opd: 'test_opd' }

      it 'response with unprocessable_entity status' do
        post '/api/master/musrenbangs', params: { musrenbang: invalid_params }

        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end

  describe "DELETE /api/master/musrenbangs" do
    let(:musrenbang) {  create(:musrenbang, tahun: '2023') }
    before(:each) { musrenbang }
    it 'delete musrenbang' do
        expect { delete "/api/master/musrenbangs/#{musrenbang.id}" }.to change { Musrenbang.count }.from(1).to(0)
        expect(response).to have_http_status :no_content
    end
  end

  def response_body
    JSON.parse(response.body)
  end
end
