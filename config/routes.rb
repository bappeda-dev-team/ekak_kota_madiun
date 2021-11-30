Rails.application.routes.draw do
  resources :kesenjangans
  # resources :rincians
  resources :pagus
  resources :pks
  resources :kaks
  resources :users , shallow: true do
    resources :sasarans
  end
  resources :sasarans, shallow: true do 
    resources :rincians
    resources :pagus, shallow: false
  end


  resources :rincians do
    resources :tahapans do
      resources :aksis
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :lembagas
  resources :opds
  resources :program_kegiatans

  root to: 'opds#index'
  # get "/program_kegiatans", to: "program_kegiatans#index"
  # get "/program_kegiatans/new", to: "program_kegiatans#new"
  # get "/program_kegiatan/:id", to: "program_kegiatans#show"
  # post "/program_kegiatans", to: "program_kegiatans#create"
end
