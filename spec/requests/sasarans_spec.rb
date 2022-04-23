require 'rails_helper'

RSpec.describe "Sasarans", type: :request do
  let(:sasaran) { FactoryBot.create :sasaran}

  context 'sasaran can add the details after created' do
    it 'add rincian' do
      sign_in sasaran.user
      get user_sasaran_path(sasaran.user, sasaran)
      expect(response).to have_http_status(200)
      post sasaran_rincians_path(sasaran), params: { rincian: { data_terpilah: 'Some data terpilah thing',
                                                               lokasi_pelaksanaan: 'Some lokasi pelaksanaan',
                                                               sasaran_id: sasaran.id } }
      expect(response).to redirect_to(user_sasaran_path(sasaran.user, sasaran))
      follow_redirect!
      expect(response.body).to include 'Rincian berhasil ditambahkan.'
    end

    it 'add permasalahan' do
      sign_in sasaran.user
      get user_sasaran_path(sasaran.user, sasaran)
      post sasaran_permasalahans_path(sasaran), params: { permasalahan: { permasalahan: 'Some permasalahan thing',
                                                                          jenis: 'Umum',
                                                                          penyebab_internal: 'Penyebab internal',
                                                                          penyebab_external: 'Penyebab external' } }
    end
  end
end
