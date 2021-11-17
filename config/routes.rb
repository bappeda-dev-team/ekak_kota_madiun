Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :lembagas
  get "/opds", to: "opds#index"
  get "/opd/:id", to: "opds#show"
end
