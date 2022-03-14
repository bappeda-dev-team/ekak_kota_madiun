Rails.application.routes.draw do
  resources :anggaran_hspks
  resources :anggaran_sbus
  resources :anggaran_sshes
  resources :subkegiatan_tematiks, path: 'tematiks'
  resources :rekenings
  resources :pokpirs
  resources :inovasis
  resources :mandatoris
  resources :asn_musrenbangs, path: 'asn_usulan'
  resources :dasar_hukums
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  root to: 'home#dashboard'
  resources :users do
    resources :sasarans, path: 'sasaran_kerja'
  end
  resources :sasarans do
    resources :rincians
    resources :tahapans do
      resources :aksis, path: 'rencana_aksi'
      resources :anggarans
    end
  end

  # resources :rincians do
  #   resources :tahapans do
  #     resources :aksis, :path => "rencana_aksi"
  #     resources :anggarans
  #   end
  # end

  resources :anggarans do
    resources :perhitungans
  end

  resources :perhitungans, shallow: true do
    resources :koefisiens
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :kaks, path: 'acuan_kerja'
  resources :musrenbangs
  resources :lembagas
  resources :opds
  resources :program_kegiatans
  resources :pajaks
  resources :kesenjangans
  resources :strategi_keluarans, path: 'strategi'
  resources :latar_belakangs, path: 'dasar_aksi'

  # program program_kegiatan
  get '/program_kegiatans_to_kak/:id', to: 'program_kegiatans#show_to_kak'
  get '/program_kegiatans_to_kak_detail/:id', to: 'program_kegiatans#kak_detail'
  get '/program_kegiatans_to_kak_renaksi/:id', to: 'program_kegiatans#kak_renaksi'
  get '/program_kegiatans_to_kak_waktu/:id', to: 'program_kegiatans#kak_waktu'

  # musrenbang
  get '/asn_musrenbangs/:nip', to: 'musrenbangs#asn_musrenbang'
  get '/musrenbang_search', to: 'musrenbangs#musrenbang_search'
  patch '/aktifkan_usulan/:id', to: 'musrenbangs#aktifkan_usulan'
  patch '/non_aktifkan_usulan/:id', to: 'musrenbangs#non_aktifkan_usulan'
  post '/update_sasaran_asn', to: 'musrenbangs#update_sasaran_asn'
  # pokpir
  patch '/aktifkan_pokpir/:id', to: 'pokpirs#aktifkan_pokpir'
  patch '/non_aktifkan_pokpir/:id', to: 'pokpirs#non_aktifkan_pokpir'
  # laporan kak
  get '/laporan_kak', to: 'kaks#laporan_kak'
  get '/pdf_kak/:id', to: 'kaks#pdf_kak'
  # laporan rka
  get '/laporan_rka', to: 'program_kegiatans#laporan_rka'
  #  Sasaran
  get '/daftar_subkegiatan', to: 'sasarans#daftar_subkegiatan'
  get '/pdf_daftar_subkegiatan', to: 'sasarans#pdf_daftar_subkegiatan'

  # Anggaran
  get '/anggaran_ssh_search', to: 'anggaran_sshes#anggaran_ssh_search'
  get '/anggaran_spesifikasi_search', to: 'anggaran_sshes#anggaran_spesifikasi_search'

  # Reknening
  get '/rekening_search', to: 'rekenings#rekening_search'

  # admin thing
  get '/adminsasarans', to: 'sasarans#sasaran_admin'
  get '/adminusers', to: 'users#user_admin'
  #
  # get "/program_kegiatans", to: "program_kegiatans#index"
  # get "/program_kegiatans/new", to: "program_kegiatans#new"
  # get "/program_kegiatan/:id", to: "program_kegiatans#show"
  # post "/program_kegiatans", to: "program_kegiatans#create"
end
