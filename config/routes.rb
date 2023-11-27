# frozen_string_literal: true

# == Route Map
#

# require 'resque/server'
require "sidekiq/web"
require "sidekiq-status/web"
require "sidekiq_unique_jobs/web"

Rails.application.routes.draw do
  resources :pindah_pohon_kinerjas, only: %i[show edit update]
  resources :permasalahan_opds
  resources :strategi_arah_kebijakans do
    collection do
      get :opd
    end
  end
  resources :jabatans
  resources :status_tombols
  resources :external_urls
  resources :reviews
  resources :kriteria
  resources :sub_kriteria
  resources :pelaksana do
    member do
      get :teman
    end
  end
  resources :crosscuttings
  resources :pohon_kinerja_opds do
    member do
      get :new_child
    end
    collection do
      get :cascading
    end
  end
  resources :tims
  # TODO: Refactor controller to resources
  resources :pohon_tematik do
    member do
      get :new_sub
      get :edit_sub_tematik
      get :pindah_sub_tematik
      patch :update_sub_tematik
      get :new_opd_tematik
      get :edit_opd_tematik
      patch :update_opd_tematik
      get :pindah_opd_tematik
      get :new_strategi_tematik
      get :new_strategi
      get :edit_strategi
      patch :update_strategi
      get :new_tactical_tematik
      get :new_tactical
      get :edit_tactical
      patch :update_tactical
      get :new_operational_tematik
      get :new_operational
      get :edit_operational
      patch :update_operational
      patch :pindah_pohon
      patch :terima
      get :tolak_strategi
      patch :tolak
      get :new_sub_sub
      get :edit_sub_sub
    end
    collection do
      post :create_sub_tema
      post :create_opd_tematik
      post :create_strategi_tematik
      post :create_strategi_tematik_baru
      post :create_tactical_tematik
      post :create_tactical_tematik_baru
      post :create_operational_tematik
      post :create_operational_tematik_baru
      post :create_sub_sub_tema
      get :filter
      get :get_tematik_opd
    end
  end
  resources :tematiks do
    collection do
      get :sub_tematiks
      post :sub
      get :new_sub
    end

    member do
      get :edit_sub
      post :sub
      patch :update_sub
      delete :sub
    end
  end
  resources :sub_sub_tematiks, only: %i[create update]
  resources :subdomains
  resources :opd_bidangs
  resources :periodes
  resources :tahuns
  resources :domains
  resources :kebutuhans
  resources :komentars do
    collection do
      get :komentar_pokin
    end
  end
  resources :spbe_rincians
  resources :spbes do
    collection do
      get :index_opd
      get :excel_opd
    end
    member do
      get :edit_operational_opd
    end
  end
  resources :pagu_anggarans
  resources :indikator_sasarans do
    resources :manual_iks do
      member do
        get :overview
      end
    end
  end
  resources :sasaran_opds
  resources :tujuan_opds do
    collection do
      post :admin_filter
    end
  end
  resources :pohon_kinerja do
    member do
      get :transfer_pohon
      post :transfer
      get :panggil_teman
      post :simpan_teman
      get :daftar_temans
      get :daftar_strategi
      post :pasangkan
      get :daftar_linked_strategi
      post :set_clone
      get :pindah
      get :list_dibagikan
      get :new_tactical
      get :new_operational
    end
    collection do
      get :kota
      get :cascading
      get :opd
      get :asn
      post :admin_filter
      get :print
      get :excel_kota
      get :pdf_kota
      get :pdf_opd
      get :excel_opd
      get :rekap
      post :filter_rekap
      get :rekap_opd
      post :filter_rekap_opd
      get :clone_list_opd
      post :clone_pokin_opd
      post :clone_pokin_isu_strategis_opd
      post :clone_pokin_kota
      get :review_opd
      get :review_kota
      get :manual
      get :clone
      get :new_strategic
      get :list_pohon
    end
  end
  resources :strategi_opds
  resources :strategi_kota do
    member do
      get :bagikan_ke_opd
      post :pilih_opd
      get :list_strategi_opd
      post :hapus_bagikan_ke_opd
    end
  end
  resources :strategis do
    member do
      get :bagikan_pokin
      post :pilih_asn
      get :list_strategi_asn
      post :hapus_bagikan_ke_asn
      get :ganti_nip
      get :renaksi
    end
    collection do
      get :rekap_strategi
      get :pokin_list
    end
  end
  resources :isu_strategis_opds do
    collection do
      post :admin_filter
    end
  end
  resources :isu_strategis_kota do
    member do
      get :list_strategi_kota
    end
  end
  # get "/gender", to: "genders#gender"
  # get "/gap_gender", to: "genders#gap_gender"
  # get "/laporan_gender", to: "genders#laporan_gender"
  # get "/pdf_gender/:id/:tahun", to: "genders#pdf_gender"
  resources :genders do
    collection do
      get :gender
      get :gap
      get :gbs
      get :laporan_gender
      get :laporan_gap
      get :laporan_gbs
      # get "pdf_gender/:id/:tahun", to: "genders#pdf_gender"
      # get "pdf_gap_gender/:id/:tahun", to: "genders#pdf_gap_gender"
    end

    member do
      get :pdf_gbs
      get :pdf_gap
      get :admin_edit
    end
  end
  resources :tujuans
  # get 'isu_dan_permasalahans/index'
  resources :renstra do
    collection do
      get :admin_renstra
    end
    post :update_programs, on: :member
  end

  resources :isu_dan_permasalahans, param: :kode_program do
    collection do
      post :filter
    end
    member do
      get :add_new
      post :add_isu_strategis
    end
  end

  resources :kemungkinans
  resources :skalas
  resources :dampaks
  resources :anggaran_hspks
  resources :anggaran_sbus
  resources :anggaran_sshes
  resources :anggaran_bluds
  resources :anggaran_hspk_umums
  resources :subkegiatan_tematiks do
    member do
      get :cetak_pdf
    end
  end

  resources :rekenings
  resources :musrenbangs do
    member do
      post :toggle_is_active
      post :diambil_asn
      post :setujui_usulan_di_sasaran
    end
  end
  # user_specific_thing
  get "/usulan_musrenbang", to: "musrenbangs#usulan_musrenbang"
  get "/usulan_pokpir", to: "pokpirs#usulan_pokpir"
  get "/usulan_mandatori", to: "mandatoris#usulan_mandatori"
  get "/usulan_inisiatif", to: "inovasis#usulan_inisiatif"

  resources :pokpirs do
    member do
      post :toggle_is_active
      post :diambil_asn
      post :setujui_usulan_di_sasaran
    end
  end

  resources :inovasis do
    member do
      post :toggle_is_active
      post :diambil_asn
      post :setujui_usulan_di_sasaran
    end
  end

  resources :mandatoris do
    member do
      post :toggle_is_active
      post :diambil_asn
      post :setujui_usulan_di_sasaran
    end
    collection do
      get :spbe
    end
  end

  resources :asn_musrenbangs, path: "asn_usulan"
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }
  root to: "home#dashboard"
  resources :users do
    collection do
      get :struktur
      get :khusus
      get :dropdown_user
      get :list_all
      get :user_opd
      resources :reviewers
    end

    member do
      get :anggaran_sasaran
      get :edit_detail
      patch :update_detail
      get :set_role
      post :add_role
      get :set_role_khusus
      get :edit_nip
      post :update_nip
      get :mutasi_asn
      post :update_jabatan
      get :edit_profile
    end
  end

  resources :atasans
  resources :kepalas

  resources :sasarans, path: "rencana_kinerja" do
    collection do
      get :list_sasaran
      get :anggaran, path: "rincian_anggaran"
      get :sasaran_admin
      get :new_spbe
      get :rekap_sasaran
    end
    member do
      get :data_detail
      get :rencana_aksi
      get :subkegiatan
      get :anggaran_belanja
      post :clone_tahapan_sebelum
      get :edit_nip
      post :update_nip
      get :subkegiatan_spbe
      get :rincian
      get :edit_sasaran_spip
      get :edit_admin
      patch :hasil_output
      get :review
    end
    resources :rincians do
      get "subkegiatan", on: :new
    end

    resources :tahapans do
      member do
        post :otomatis
        get :review
        get :review_anggaran
      end
      resources :aksis, path: "rencana_aksi"
      resources :anggarans
    end

    resources :permasalahans
    resources :dasar_hukums
    resources :latar_belakangs, path: "gambaran_umum"
    member do
      post :ajukan_verifikasi
      post :setujui
      post :tolak
      post :revisi
      get :detail
      get :clone_form
      post :clone
      post :pilih_asn
    end
  end

  resources :rincian_belanja do
    collection do
      get :index_atasan
    end
    member do
      get :show_subkegiatan
      get :edit_rankir_gelondong
      get :edit_penetapan
    end
  end

  resources :kelompok_anggarans do
    collection do
      get :cloning
    end
  end

  # resources :rincians do
  #   resources :tahapans do
  #     resources :aksis, :path => "rencana_aksi"
  #     resources :anggarans
  #   end

  # end

  resources :anggarans do
    resources :perhitungans do
      collection do
        get :new_gaji
        get :new_lain_lain
      end

      member do
        get :edit_gaji
        get :edit_lain_lain
      end
    end
  end

  resources :perhitungans, shallow: true do
    resources :koefisiens
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :kaks, path: "acuan_kerja" do
    collection do
      get :laporan_kak
    end
  end
  # get "/acuan_kerja_new/:id/:tahun", to: "program_kegiatans#new_kak_format"

  resources :laporans, only: [:index] do
    collection do
      get :atasan
      get :laporan_kak
      get :laporan_rka
      post :laporan_kak_admin
      post :laporan_rka_admin
      get :spbe
      get :renstra
      get :ranwal
      get :rankir1
      get :rankir2
      get :penetapan
      get :hasil_cascading
      post :cascading_opd
      get :hasil_cascading_kota
      get :cascading_kota
    end

    member do
      get :pdf_kak
      get :pdf_rka
      get :show_kak
      get :buka_kak
    end
  end
  # laporan rka
  # get "/pdf_rka/:id/:tahun", to: "program_kegiatans#pdf_rka"
  # get "/pdf_kak/:id/:tahun", to: "program_kegiatans#pdf_kak"

  resources :lembagas
  resources :opds do
    collection do
      # get :tujuan
      # get :sasaran
      get :info
      get :kotak_usulan
      get :legit_opd
      get :sasaran_tactical
      get :sasaran_operational
      get :bidang
      get :opd_resmi
    end
    member do
      get :buat_strategi
      post :simpan_strategi
      get :edit_full
    end
  end
  resources :program_kegiatans do
    member do
      get :subgiat_edit
      patch :subgiat_update
      get :giat_edit
      patch :giat_update
      get :program_edit
      patch :program_update
      get :detail_sasarans
      get :rencana_aksi
    end
    collection do
      get :list_program_with_sasarans_rincian
      get :subkegiatans
      get :pks_opd
      post :content_pks_opd
      get :daftar_pagu
      get :daftar_renstra
    end
  end

  resources :pajaks
  resources :kesenjangans
  resources :strategi_keluarans, path: "strategi"
  resources :comments, except: %i[index show]
  resources :roles
  resources :sumber_danas, except: %i[show]
  resources :kamus_usulans
  resources :usulans
  resources :rekaps, param: :kode_unik_opd do
    get "jumlah", on: :collection
  end

  resources :spip, param: :kode_opd do
    collection do
      get :cetak_excel
    end
  end

  resources :sasaran_program_opds do
    collection do
      get :daftar_resiko
    end

    get :add_dampak_resiko
  end

  resources :clone do
    member do
      post :pohon_tematik
      get :clone_sasaran
      post :rencana_kinerja
      get :opd
      post :pohon_opd
    end
    collection do
      get :tahun_clone
      post :transfer_ke_pohon_kinerja
    end
  end

  namespace :filter do
    post :daftar_resiko
    post :isu_strategis_permasalahan
    post :laporan_renstra
    get :tahun_dan_opd
    post :renstra_master
    # post :tujuan_opd
    post :sasaran_opd
    post :crosscutting_kota
    post :ranwal_renja
    post :pohon_kinerja_opd
    post :kak_dashboard
  end

  namespace :api do
    namespace :programs do
      post :indikators
      post :permasalahans
      post :opd_program
      post :opd_kegiatan
      post :opd_subkegiatan
      post :opd_test_indikator_program
      post :opd_test_renstra_program
      post :opd_test_indikator_kegiatan
      post :opd_test_renstra_kegiatan
      post :opd_test_indikator_subkegiatan
      post :opd_test_renstra_subkegiatan
      post :kota_test_indikator_program
      post :kota_test_indikator_kegiatan
      post :kota_test_indikator_subkegiatan
    end
    namespace :pecel_tumpang do
      get :data_anggarans
    end
    namespace :renja do
      post :opd_subkegiatan
      post :kota_subkegiatan
    end
    namespace :sipd_client do
      get :sync_renstra
    end
    namespace :skp do
      post :sasaran_kinerja_pegawai
      post :indikator_sasaran_kinerja_pegawai
      post :rencana_aksi_pegawai
      post :manual_ik_pegawai
      post :sasaran_pegawai
      post :sasaran_pohon_kinerja
      post :sasaran_pohon_kinerja_pegawai
      post :tujuan_opd
      post :sasaran_opd
      post :faktor_penghambat_skp
    end
    namespace :skp_client do
      post :sync_jabatan
    end
    namespace :pagu do
      post :sync_penetapan
      post :sync_opd
      post :sync_pagu_kak
    end
    namespace :opd do
      post :daftar_opd
      post :find_opd
      post :urusan_opd
      post :tujuan_opd
      post :perbandingan_pagu
      post :pagu_all
    end
    namespace :pohon_kinerja do
      post :pohon_kinerja_kota
      post :pohon_kinerja_opd
    end
    namespace :tematik do
      get :list_tematik
      post :programs
      post :subkegiatans
    end
    namespace :master do
      resources :musrenbangs, defaults: { format: :json } do
        member do
          post :toggle_is_active
          post :diambil_asn
          post :setujui_usulan_di_sasaran
        end
      end

      resources :pokpirs, defaults: { format: :json } do
        member do
          post :toggle_is_active
          post :diambil_asn
          post :setujui_usulan_di_sasaran
        end
      end

      resources :mandatoris, defaults: { format: :json } do
        member do
          post :toggle_is_active
          post :diambil_asn
          post :setujui_usulan_di_sasaran
        end
        collection do
          get :spbe
        end
      end

      resources :inovasis, defaults: { format: :json } do
        member do
          post :toggle_is_active
          post :diambil_asn
          post :setujui_usulan_di_sasaran
        end
      end

      get :usulan_spbe
      get :usulan_lppd
      get :usulan_spm
    end
  end

  resources :sasaran_kota
  resources :tujuan_kota
  get :crosscutting_kota, to: "sasaran_kota#crosscutting_kota"

  # renja
  namespace :renja do
    get :ranwal
    get :ranwal_cetak
    get :rankir_1
    get :rankir
    get :edit_rankir
    post :update_rankir
    get :penetapan
    post :rankir_renja
    post :rankir_renja_1
    post :penetapan_renja
    get :perubahan
    post :perubahan_renja
  end

  # resque
  authenticate :user, ->(u) { u.super_admin? } do
    mount Sidekiq::Web, at: "/sidekiq"
    mount RailsPerformance::Engine, at: 'rails/performance'
  end

  # sasaran
  get "/verifikasi_sasarans", to: "sasarans#verifikasi_sasaran"
  get "/laporan_sasarans", to: "sasarans#laporan_sasaran"
  post "/hapus_program_from_sasaran", to: "sasarans#hapus_program_from_sasaran"
  post "/hapus_tematik_from_sasaran", to: "sasarans#hapus_tematik_from_sasaran"
  post "/add_sasaran_tematik", to: "sasarans#add_sasaran_tematik"
  post "/ajukan_semua_sasaran", to: "sasarans#ajukan_semua_sasaran"
  post "/setujui_semua_sasaran", to: "sasarans#setujui_semua_sasaran"
  post "/revisi_semua_sasaran", to: "sasarans#revisi_semua_sasaran"
  post "/tolak_semua_sasaran", to: "sasarans#tolak_semua_sasaran"
  # user control
  post "/aktifkan_user/:id", to: "users#aktifkan_user"
  post "/nonaktifkan_user/:id", to: "users#nonaktifkan_user"
  post "/hapus_asn/:id", to: "users#hapus_asn"
  post "/nonaktifkan_semua_user/:opd", to: "users#nonaktifkan_semua_user"
  get "/user_search", to: "users#user_search"
  # program program_kegiatan
  get "/program_kegiatans_to_kak/:id", to: "program_kegiatans#show_to_kak"
  get "/program_kegiatans_to_kak_detail/:id", to: "program_kegiatans#kak_detail"
  get "/program_kegiatans_to_kak_renaksi/:id", to: "program_kegiatans#kak_renaksi"
  get "/program_kegiatans_to_kak_waktu/:id", to: "program_kegiatans#kak_waktu"

  # musrenbang
  get "/asn_musrenbangs/:nip", to: "musrenbangs#asn_musrenbang"
  post "/update_opd", to: "musrenbangs#update_opd"
  post "/update_opd_pokpir", to: "pokpirs#update_opd"
  # search usulans
  get "/musrenbang_search", to: "musrenbangs#musrenbang_search"
  get "/mandatori_search", to: "mandatoris#mandatori_search"
  get "/pokpir_search", to: "pokpirs#pokpir_search"
  get "/inovasi_search", to: "inovasis#inovasi_search"
  # delete later
  patch "/aktifkan_usulan/:id", to: "musrenbangs#aktifkan_usulan"
  patch "/non_aktifkan_usulan/:id", to: "musrenbangs#non_aktifkan_usulan"
  # usulans
  post "/update_sasaran_asn", to: "usulans#update_sasaran_asn"
  post "/hapus_usulan_dari_sasaran", to: "usulans#hapus_usulan_dari_sasaran"
  # pokpir delete later
  patch "/aktifkan_pokpir/:id", to: "pokpirs#aktifkan_pokpir"
  patch "/non_aktifkan_pokpir/:id", to: "pokpirs#non_aktifkan_pokpir"
  # laporan kak
  get "/cetak_daftar_kak/:opd/:tahun", to: "program_kegiatans#cetak_daftar_kak"
  # daftar resiko
  get "/cetak_daftar_resiko/:opd/:tahun", to: "sasaran_program_opds#cetak_daftar_resiko"
  #  Sasaran
  get "/daftar_subkegiatan", to: "sasarans#daftar_subkegiatan"
  get "/pdf_daftar_subkegiatan", to: "sasarans#pdf_daftar_subkegiatan"
  post "/renaksi_update", to: "sasarans#renaksi_update"

  # Tahapan
  # Anggaran
  get "/anggaran_ssh_search", to: "anggaran_sshes#anggaran_ssh_search"
  get "/anggaran_jenis_search", to: "anggaran_sshes#anggaran_jenis_search"
  get "/anggaran_spesifikasi_search", to: "anggaran_sshes#anggaran_spesifikasi_search"
  get "/anggaran_hspk_search", to: "anggaran_hspks#anggaran_hspk_search"
  post "/perhitungan_update", to: "anggarans#perhitungan_update"

  # Reknening
  get "/rekening_search", to: "rekenings#rekening_search"
  get "/jenis_rekening_search", to: "rekenings#jenis_rekening_search"
  get "/khusus_rekening_search", to: "rekenings#khusus_rekening_search"

  # admin thing
  # get "/adminsasarans", to: "sasarans#sasaran_admin"
  get "/adminusers", to: "users#user_admin"
  get "/admin_program", to: "program_kegiatans#admin_program"
  get "/admin_kegiatan", to: "program_kegiatans#admin_kegiatan"
  get "/admin_sub_kegiatan", to: "program_kegiatans#admin_sub_kegiatan"
  get "/laporan_renja", to: "program_kegiatans#laporan_renja" # TODO: implement this
  get "/rasionalisasi", to: "rasionalisasi#rasionalisasi"
  get "/rasional_sasaran/:sasaran", to: "rasionalisasi#rasional_sasaran"
  get "/rasional_sasaran_anggaran/:sasaran", to: "rasionalisasi#rasional_sasaran_anggaran"

  get "/laporan_renja", to: "program_kegiatans#laporan_renja"
  get "/laporan_usulan/:jenis", to: "usulans#laporan_usulan"
  get "/pdf_usulan/:jenis/:opd/:tahun", to: "usulans#pdf_usulan"
  get "/excel_usulan/:jenis/:opd/:tahun", to: "usulans#excel_usulan"
  get "/laporan_tematik", to: "subkegiatan_tematiks#laporan_tematik"
  get "/laporan_tematik_apbd", to: "subkegiatan_tematiks#laporan_tematik_apbd"
  #
  # third party Api
  get "/sync_pegawai", to: "api/skp_client#sync_pegawai"
  get "/sync_subkegiatan", to: "api/sipd_client#sync_subkegiatan"
  get "/sync_subkegiatan_opd", to: "api/sipd_client#sync_subkegiatan_opd"
  get "/update_detail_kegiatan_lama", to: "api/sipd_client#update_detail_kegiatan_lama"
  get "/update_detail_kegiatan", to: "api/sipd_client#update_detail_kegiatan"
  get "/update_detail_subkegiatan", to: "api/sipd_client#update_detail_subkegiatan"
  get "/sync_musrenbang", to: "api/sipd_client#sync_musrenbang"
  get "/sync_pokpir", to: "api/sipd_client#sync_pokpir"
  get "/sync_kamus_usulan", to: "api/sipd_client#sync_kamus_usulan"
  get "/sync_data_opd", to: "api/sipd_client#sync_data_opd"
  post "/update_detail_program", to: "api/sipd_client#update_detail_program"
  post "/sync_indikator_program", to: "api/sipd_client#sync_indikator_program"
  post "/sync_indikator_kegiatan", to: "api/sipd_client#sync_indikator_kegiatan"
  post "/sync_master_program/:tahun", to: "master/program#sync_master_program"
  post "/sync_master_kegiatan/:tahun", to: "master/kegiatan#sync_master_kegiatan"
  post "/sync_master_subkegiatan/:tahun/:id_giat", to: "master/subkegiatan#sync_master_subkegiatan"
  post "/sync_master_subkegiatan_all", to: "master/subkegiatan#sync_master_subkegiatan_all"
  post "/sync_master_output_kegiatans/:tahun", to: "master/output_kegiatans#sync_master_output_kegiatans"
  post "/sync_master_urusan", to: "master/urusans#sync_master_urusan"
  post "/sync_master_bidang_urusan", to: "master/bidang_urusans#sync_master_bidang_urusan"
  # internal filter
  post "/filter_sasaran", to: "filter#filter_sasaran"
  post "/filter_user", to: "filter#filter_user"
  post "/filter_program", to: "filter#filter_program"
  # post "/indikator_program_opd_by_kode_program", to: "api/program_kak#indikator_program_opd_by_kode_program"
  post "/filter_kegiatan", to: "filter#filter_kegiatan"
  post "/filter_subkegiatan", to: "filter#filter_subkegiatan"
  post "/filter_kak", to: "filter#filter_kak"
  # post "/filter_kak_dashboard", to: "filter#filter_kak_dashboard"
  post "/filter_rab", to: "filter#filter_rab"
  post "/filter_rasionalisasi", to: "filter#filter_rasionalisasi"
  post "/filter_gender", to: "filter#filter_gender"
  post "/filter_opd", to: "filter#filter_opd"
  post "/filter_usulan", to: "filter#filter_usulan"
  post "/filter_user_sasarans", to: "filter#filter_user_sasarans"
  post "/filter_tematiks", to: "filter#filter_tematiks"
  post "/filter_tematiks_apbd", to: "filter#filter_tematiks_apbd"
  post "/filter_struktur", to: "filter#filter_struktur"
  post "/filter_rekap_jumlah", to: "filter#filter_rekap_jumlah"

  get "/all_opd", to: "opds#all_opd"
  get "/destroy_all", to: "program_kegiatans#destroy_all"
  get "/master_programs", to: "master/program#index"
  get "/master_kegiatans", to: "master/kegiatan#index"
  get "/master_subkegiatans", to: "master/subkegiatan#index"
  get "/master_output", to: "master/output_kegiatans#index"
  get "/master_urusan", to: "master/urusans#index"
  get "/list_urusan", to: "master/urusans#list_urusan"
  get "/master_bidang_urusan", to: "master/bidang_urusans#index"
  get "/list_bidang_urusan", to: "master/bidang_urusans#list_bidang_urusan"
  # get "/program_kegiatans", to: "program_kegiatans#index"
  # get "/program_kegiatans/new", to: "program_kegiatans#new"
  # get "/program_kegiatan/:id", to: "program_kegiatans#show"
  get "/callback", to: "callback#index"
end
