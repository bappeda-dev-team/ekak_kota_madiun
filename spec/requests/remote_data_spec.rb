require 'rails_helper'

RSpec.describe "Remote Data Spec", type: :request do
  let(:user) { create(:user) }
  let(:program_kegiatans) { create_list(:program_kegiatan, 10) }
  describe "get /program_kegiatans.json" do
    it 'return all program_kegiatans by opd' do
      sign_in(user)
      program_kegiatans
      get '/program_kegiatans.json'
      parsed_json_body = JSON.parse(response.body)
      expect(parsed_json_body['results'].size).to eq 10
    end
  end

  describe "get /list_sasaran.json" do
    let(:program_kegiatan) { create :program_kegiatan }
    let(:sasaran) { create(:sasaran, user: user, program_kegiatan: program_kegiatan, sasaran_kinerja: 'contoh sasaran_kinerja') }
    let(:rincian) { create :rincian, sasaran: sasaran }
    context 'sasaran with rincian and active user' do
      it 'return all sasaran' do
        sign_in(user)
        # setup complex data :(
        user.add_role 'asn'
        user.remove_role 'non_aktif'
        sas = sasaran
        rincian

        get '/sasarans/list_sasaran.json'
        parsed_json_body = JSON.parse(response.body)
        expect(parsed_json_body['results']).to include(include('text' => "contoh sasaran_kinerja"))
      end

      it 'return sasaran with query' do
        sign_in(user)
        # setup complex data :(
        user.add_role 'asn'
        user.remove_role 'non_aktif'
        sas = sasaran
        rincian
        get "/sasarans/list_sasaran.json?q=contoh"
        parsed_json_body = JSON.parse(response.body)
        expect(parsed_json_body['results']).to include(include('text' => "contoh sasaran_kinerja"))
      end
    end
  end
end
