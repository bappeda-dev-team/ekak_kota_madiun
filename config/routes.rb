Rails.application.routes.draw do
  resources :kaks
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :lembagas
  get "/opds", to: "opds#index"
  get "/opd/:id", to: "opds#show"
  get "/program_kegiatans", to: "program_kegiatans#index"
  get "/program_kegiatans/new", to: "program_kegiatans#new"
  get "/program_kegiatan/:id", to: "program_kegiatans#show"
  post "/program_kegiatans", to: "program_kegiatans#create"
end
