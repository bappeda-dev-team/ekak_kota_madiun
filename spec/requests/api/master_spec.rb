require 'rails_helper'

RSpec.describe "Api::Masters", type: :request do
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
