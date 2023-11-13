require 'rails_helper'

RSpec.describe "Api::Masters", type: :request do
  describe "GET /usulan_musrenbang" do
    it "response with ok status" do
      musrenbang = create(:musrenbang, tahun: '2023')

      get api_master_usulan_musrenbang_path(format: :json)
      expect(response).to have_http_status :ok
    end

    it "response with musrenbangs by tahun" do
      musrenbang = create(:musrenbang, tahun: '2023')

      get api_master_usulan_musrenbang_path(tahun: '2023', format: :json)
      results = response_body["results"]
      expect(results.first["usulan"]).to eq musrenbang.usulan
    end
  end

  describe "POST /create_usulan_musrenbang" do
    context "given valid params" do
      valid_params = { tahun: '2023',
                       usulan: 'Usulan A',
                       alamat: 'Jl. XXX',
                       uraian: 'Lampu rusak',
                       opd: 'test_opd' }
      it 'response with created status' do
        expect { post '/api/master/create_usulan_musrenbang', params: { musrenbang: valid_params } }.to change { Musrenbang.count }.from(0).to(1)

        expect(response).to have_http_status :created
      end
    end
    context "given invalid params" do
      invalid_params = { tahun: '2023',
                         alamat: 'Jl. XXX',
                         uraian: 'Lampu rusak',
                         opd: 'test_opd' }

      it 'response with unprocessable_entity status' do
        post '/api/master/create_usulan_musrenbang',
             params: { musrenbang: invalid_params }

        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end

  describe "DELETE /usulan_musrenbang" do
    context "given valid params" do
      let(:musrenbang) {  create(:musrenbang, tahun: '2023') }
      it 'delete musrenbang' do
        valid_params = { id: musrenbang.id }
        expect { post '/api/master/delete_usulan_musrenbang', params: { musrenbang: valid_params } }.to change { Musrenbang.count }.from(1).to(0)
        expect(response).to have_http_status :no_content
      end
    end
  end

  describe "GET /usulan_pokir" do
    it "response with ok status" do
      pokpir = create(:pokpir, tahun: '2023')

      get api_master_usulan_pokir_path(format: :json)
      expect(response).to have_http_status :ok
    end

    it "response with musrenbangs by tahun" do
      pokpir = create(:pokpir, tahun: '2023')

      get api_master_usulan_pokir_path(tahun: '2023', format: :json)
      results = response_body["results"]
      expect(results.first["usulan"]).to eq pokpir.usulan
    end
  end

  describe "GET /usulan_mandatori" do
    it "response with ok status" do
      user = create(:user)
      mandatori = create(:mandatori, tahun: '2023', nip_asn: user.nik)

      get api_master_usulan_mandatori_path(kode_opd: user.opd.kode_unik_opd, format: :json)
      expect(response).to have_http_status :ok
    end

    it "response with musrenbangs by tahun" do
      user = create(:user)
      mandatori = create(:mandatori, tahun: '2023', nip_asn: user.nik)

      get api_master_usulan_mandatori_path(tahun: '2023', kode_opd: user.opd.kode_unik_opd, format: :json)
      results = response_body["results"]
      expect(results.first["usulan"]).to eq mandatori.usulan
    end
  end

  describe "GET /usulan_inisiatif" do
    it "response with ok status" do
      user = create(:user)
      inisiatif = create(:inovasi, tahun: '2023', nip_asn: user.nik)

      get api_master_usulan_inisiatif_path(kode_opd: user.opd.kode_unik_opd, format: :json)
      expect(response).to have_http_status :ok
    end

    it "response with musrenbangs by tahun" do
      user = create(:user)
      inisiatif = create(:inovasi, tahun: '2023', nip_asn: user.nik)

      get api_master_usulan_inisiatif_path(tahun: '2023', kode_opd: user.opd.kode_unik_opd, format: :json)
      results = response_body["results"]
      expect(results.first["usulan"]).to eq inisiatif.usulan
    end
  end

  describe "GET /usulan_spbe" do
    pending "data belum tersedia"
    it "response with ok status" do
      # user = create(:user)
      # inisiatif = create(:inovasi, tahun: '2023', nip_asn: user.nik)

      # get api_master_usulan_spbe_path(kode_opd: user.opd.kode_unik_opd, format: :json)
      # expect(response).to have_http_status :ok
    end

    it "response with musrenbangs by tahun" do
      # user = create(:user)
      # inisiatif = create(:inovasi, tahun: '2023', nip_asn: user.nik)

      # get api_master_usulan_spbe_path(tahun: '2023', kode_opd: user.opd.kode_unik_opd, format: :json)
      # results = response_body["results"]
      # expect(results.first["usulan"]).to eq inisiatif.usulan
    end
  end

  describe "GET /usulan_lppd" do
    pending "data belum tersedia"
    it "response with ok status" do
      # user = create(:user)
      # inisiatif = create(:inovasi, tahun: '2023', nip_asn: user.nik)

      # get api_master_usulan_lppd_path(kode_opd: user.opd.kode_unik_opd, format: :json)
      # expect(response).to have_http_status :ok
    end

    it "response with musrenbangs by tahun" do
      # user = create(:user)
      # inisiatif = create(:inovasi, tahun: '2023', nip_asn: user.nik)

      # get api_master_usulan_lppd_path(tahun: '2023', kode_opd: user.opd.kode_unik_opd, format: :json)
      # results = response_body["results"]
      # expect(results.first["usulan"]).to eq inisiatif.usulan
    end
  end

  describe "GET /usulan_spm" do
    pending "data belum tersedia"
    it "response with ok status" do
      # user = create(:user)
      # inisiatif = create(:inovasi, tahun: '2023', nip_asn: user.nik)

      # get api_master_usulan_spm_path(kode_opd: user.opd.kode_unik_opd, format: :json)
      # expect(response).to have_http_status :ok
    end

    it "response with musrenbangs by tahun" do
      # user = create(:user)
      # inisiatif = create(:inovasi, tahun: '2023', nip_asn: user.nik)

      # get api_master_usulan_spm_path(tahun: '2023', kode_opd: user.opd.kode_unik_opd, format: :json)
      # results = response_body["results"]
      # expect(results.first["usulan"]).to eq inisiatif.usulan
    end
  end

  def response_body
    JSON.parse(response.body)
  end
end
