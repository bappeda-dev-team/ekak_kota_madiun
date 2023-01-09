require 'rails_helper'

RSpec.describe 'Api Skp Controller', type: :request do
  it 'get the params and return ok' do
    # TODO: include user factory here
    post api_skp_sasaran_kinerja_pegawai_path(format: :json, params: { kode_opd: "123.456.789", nip: "198509212011011005" })
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("198509212011011005")
  end
end
