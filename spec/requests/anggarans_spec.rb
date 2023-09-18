require 'rails_helper'

RSpec.describe "Anggarans", type: :request do
  describe "POST /create" do
    let(:tahapan) { create(:tahapan) }
    let(:sasaran) { tahapan.sasaran }
    let(:user) { sasaran.user }
    let(:rekening) { create(:rekening, kode_rekening: '5.1.02.01.04.001', jenis_rekening: 'unpermitted rek', set_input: 1) }

    before(:each) do
      sign_in user
    end

    it 'should not create anggaran in blacklisted rekening in 2024' do
      sasaran.tahun = '2024'
      sasaran.save
      post "/rencana_kinerja/#{sasaran.id}/tahapans/#{tahapan.id}/anggarans",
           xhr: true,
           params: {
             anggaran: {
               level: 0,
               parent_id: '',
               jenis_rekening: '5.1',
               kode_rek: rekening.id
             }
           }
      expect(response.body).to include('kode rekening tidak dapat digunakan')
      expect(response.status).to eq(412)
    end
    it 'should create anggaran in blacklisted rekening in 2023' do
      sasaran.tahun = '2023'
      sasaran.save
      post "/rencana_kinerja/#{sasaran.id}/tahapans/#{tahapan.id}/anggarans",
           xhr: true,
           params: {
             anggaran: {
               level: 0,
               parent_id: '',
               jenis_rekening: '5.1',
               kode_rek: rekening.id
             }
           }
      expect(response.body).to include('Rekening Ditambahkan')
      expect(response.status).to eq(200)
    end
  end
end
