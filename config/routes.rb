Rails.application.routes.draw do

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  root to: 'home#dashboard'

  # resources :perhitungans
  # resources :rincians
  # resources :pagus
  # resources :pks
  resources :users do
    resources :sasarans
    resources :kaks
  end
  resources :sasarans, shallow: true do
    resources :rincians
  end

  resources :rincians do
    resources :tahapans do
      resources :aksis
      resources :anggarans
    end
  end

  resources :anggarans do
    resources :perhitungans
  end

  resources :perhitungans, shallow: true do
    resources :koefisiens
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :lembagas
  resources :opds
  resources :program_kegiatans
  resources :pajaks
  resources :kesenjangans

  # get "/program_kegiatans", to: "program_kegiatans#index"
  # get "/program_kegiatans/new", to: "program_kegiatans#new"
  # get "/program_kegiatan/:id", to: "program_kegiatans#show"
  # post "/program_kegiatans", to: "program_kegiatans#create"
end
