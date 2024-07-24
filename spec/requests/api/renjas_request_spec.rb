require 'rails_helper'

RSpec.describe "Renjas", type: :request do
  let(:opd) { FactoryBot.create(:opd) }
  let(:tahun) { '2024' }
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

        program = FactoryBot.create(:program_kegiatan, tahun: tahun, opd: opd)
        indikator_program = FactoryBot.create(:indikator,
                                              kode: program.kode_program,
                                              indikator: 'indikator-x',
                                              target: '100',
                                              satuan: 'satuan-x',
                                              jenis: 'Renstra',
                                              sub_jenis: 'Program',
                                              kode_indikator: "#{program.kode_program}_Renstra_Program"
                                             )

        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json).to eq({
                             message: 'Rankir Renja - Program - KAK',
                             nama_opd: opd.nama_opd,
                             tahun: tahun,
                             programs: [
                               {
                                 jenis: 'Program',
                                 nama: program.nama_program,
                                 kode: program.kode_program
                               }
                             ]
                           })
      end
    end
  end
end
