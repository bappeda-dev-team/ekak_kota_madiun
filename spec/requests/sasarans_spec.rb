require 'rails_helper'

RSpec.describe 'Sasarans', type: :request do
  let(:sasaran) { FactoryBot.create :sasaran }
  let(:subkegiatan_tematik) { FactoryBot.create :subkegiatan_tematik }
  let(:program_kegiatan) { FactoryBot.create :program_kegiatan }

  context 'sasaran can add the details after created' do
    it 'add rincian and display it' do
      sign_in sasaran.user
      get user_sasaran_path(sasaran.user, sasaran)
      expect(response).to have_http_status(200)
      post sasaran_rincians_path(sasaran), params: { rincian: { data_terpilah: 'Some data terpilah thing',
                                                                lokasi_pelaksanaan: 'Some lokasi pelaksanaan',
                                                                sasaran_id: sasaran.id } }
      expect(response).to redirect_to(user_sasaran_path(sasaran.user, sasaran))
      follow_redirect!
      expect(response).to render_template(:show)
      expect(response.body).to include 'Rincian berhasil ditambahkan.'
    end

    it 'add permasalahan and display it' do
      sign_in sasaran.user
      get user_sasaran_path(sasaran.user, sasaran)
      post sasaran_permasalahans_path(sasaran), params: { permasalahan: { permasalahan: 'Some permasalahan thing',
                                                                          jenis: 'Umum',
                                                                          penyebab_internal: 'Penyebab internal',
                                                                          penyebab_external: 'Penyebab external' } }
      expect(response).to redirect_to(user_sasaran_path(sasaran.user, sasaran))
      follow_redirect!
      expect(response).to render_template(:show)
      expect(response.body).to include 'Data Permasalahan berhasil ditambahkan'
    end

    it 'add dasar hukum and display it' do
      sign_in sasaran.user
      get user_sasaran_path(sasaran.user, sasaran)
      expect(response).to have_http_status(200)
      post sasaran_dasar_hukums_path(sasaran), params: { dasar_hukum: { peraturan: 'Contoh Peraturan',
                                                                        judul: 'Umum',
                                                                        tahun: '2024' } }
      expect(response).to redirect_to(user_sasaran_path(sasaran.user, sasaran))
      follow_redirect!
      expect(response).to render_template(:show)
      expect(response.body).to include 'Data Dasar Hukum berhasil ditambahkan'
    end

    it 'add latar belakang and display it' do
      sign_in sasaran.user
      get user_sasaran_path(sasaran.user, sasaran)
      expect(response).to have_http_status(200)
      post sasaran_latar_belakangs_path(sasaran), params: { latar_belakang: { gambaran_umum: 'Contoh Gambaran Umum' } }
      expect(response).to redirect_to(user_sasaran_path(sasaran.user, sasaran))
      follow_redirect!
      expect(response).to render_template(:show)
      expect(flash[:success]).to be_present
      expect(flash[:success]).to eq('Data Gambaran Umum berhasil ditambahkan')
      expect(response.body).to include 'Data Gambaran Umum berhasil ditambahkan'
    end
  end

  context 'add belongs_to relation like tematik and program kegiatan' do
    it 'add tematik to current sasaran' do
      sign_in sasaran.user
      get user_sasaran_path(sasaran.user, sasaran)
      expect(response).to have_http_status(200)
      patch sasaran_path(sasaran), params: { sasaran: { subkegiatan_tematik_id: subkegiatan_tematik.id } }
      sasaran.reload
      expect(response).to redirect_to(user_sasaran_path(sasaran.user, sasaran))
      follow_redirect!
      expect(response).to render_template(:show)
      expect(sasaran.subkegiatan_tematik).to eq(subkegiatan_tematik)
    end

    it 'add sumber dana to current sasaran' do
      sign_in sasaran.user
      patch user_sasaran_path(sasaran.user, sasaran), params: { sasaran: { sumber_dana: 'BDBHCT' } }
      sasaran.reload
      expect(response).to redirect_to(user_sasaran_path(sasaran.user, sasaran))
      follow_redirect!
      expect(response).to render_template(:show)
      expect(sasaran.sumber_dana).to eq('BDBHCT')
    end

    it 'add program_kegiatan to current sasaran' do
      sign_in sasaran.user
      get user_sasaran_path(sasaran.user, sasaran)
      expect(response).to have_http_status(200)
      patch sasaran_path(sasaran), params: { sasaran: { program_kegiatan_id: program_kegiatan.id } }
      sasaran.reload
      expect(response).to redirect_to(user_sasaran_path(sasaran.user, sasaran))
      follow_redirect!
      expect(response).to render_template(:show)
      expect(sasaran.program_kegiatan).to eq(program_kegiatan)
    end
  end
end
