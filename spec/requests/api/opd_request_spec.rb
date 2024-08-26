require 'rails_helper'

RSpec.describe '/api/opd', type: :request do
  let(:opd) { create(:opd, kode_unik_opd: '2.16.2.20.2.21.04.0000') }

  describe 'POST /daftar_opd' do
    before(:each) do |example|
      opd unless example.metadata[:empty]
      post '/api/opd/daftar_opd.json'
    end

    it 'should return http success' do
      expect(response).to have_http_status(:success)
    end

    it 'should have results key' do
      parsed_body = JSON.parse(response.body).deep_symbolize_keys
      expect(parsed_body).to have_key(:results)
    end

    it 'should list opd available' do
      parsed_body = JSON.parse(response.body).deep_symbolize_keys
      results = parsed_body[:results]

      expect(results).to include({ kode_opd: opd.kode_unik_opd, nama_opd: opd.nama_opd })
    end

    it 'should show empty list if no opd', :empty do
      parsed_body = JSON.parse(response.body).deep_symbolize_keys
      results = parsed_body[:results]

      expect(results).to eq([])
    end
  end

  describe 'POST /sasaran_opd' do
    before(:each) do |example|
      opd unless example.metadata[:empty]
    end

    it 'should return http success' do
      eselon2 = create(:eselon_2, opd: opd)
      strategi = create(:strategi, role: 'eselon_2', nip_asn: eselon2.nik)
      sasaran_eselon2 = create(:sasaran, user: eselon2)
      indikator_sasaran = create(:indikator_sasaran, sasaran: sasaran_eselon2)
      manual_ik = create(:manual_ik, indikator_sasaran: indikator_sasaran)
      tahapan = create(:tahapan, sasaran: sasaran_eselon2, jumlah_target: 100)


      post '/api/opd/sasaran_opd.json', params: {
        kode_opd: '2.16.2.20.2.21.04.0000',
        tahun: '2024'
      }, as: :json
      expect(response).to have_http_status(:success)
    end

    it 'should return empty if no sasaran found' do
      pending('setup belum selesai')

      post '/api/opd/sasaran_opd.json', params: {
        kode_opd: '2.16.2.20.2.21.04.0000',
        tahun: '2024'
      }, as: :json

      parsed_body = JSON.parse(response.body).deep_symbolize_keys
      results = parsed_body[:results]

      expect(results.size).to be_empty
    end
  end
end
