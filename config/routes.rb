Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :lembagas
  get "/opds", to: "opds#index"
  get "/opd/:id", to: "opds#show"
  get "/programKegiatans", to: "program_kegiatans#index"
  get "/programKegiatan/new", to: "program_kegiatans#new"
  get "/programKegiatan/:id", to: "program_kegiatans#show"
  post "/programKegiatan", to: "program_kegiatans#create"
end
