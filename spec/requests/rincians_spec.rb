require 'rails_helper'

RSpec.describe "Rincians", type: :request do
  let(:sasaran) { FactoryBot.create :sasaran }
  let(:user) { sasaran.user }
  context 'create rincian form existsing sasaran' do
    it 'add rincian from created sasaran' do
      sign_in user
      get user_sasaran_path(user, sasaran)
      expect(response).to have_http_status(200)
      post sasaran_rincians_path(sasaran), params: { rincian: { data_terpilah: 'Some data terpilah thing',
                                                                lokasi_pelaksanaan: 'Some lokasi pelaksanaan',
                                                                sasaran_id: sasaran.id } }
      expect(response).to redirect_to(user_sasaran_path(user, sasaran))
      follow_redirect!
      expect(response.body).to include 'Rincian berhasil ditambahkan.'
    end
  end
end
