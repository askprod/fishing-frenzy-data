Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  get "/", to: "dashboard#index", as: :dashboard
  resources :fish, only: [ :index, :show ], param: :fish_slug
  resources :pets, only: [ :index, :show ], param: :pet_slug
  resources :rods, only: [ :index, :show ], param: :rod_slug
  resources :chests, only: [ :index, :show ], param: :chest_slug
  resources :flashes, only: [ :index ]
  resources :recipes, only: [ :index, :show ], param: :recipe_slug
  resources :sushis, only: [ :index, :show ], param: :sushi_slug
  resources :events, only: [ :index, :show ], param: :event_slug
  resources :players, only: [ :index, :show ], param: :player_slug do
    member do
      get "/stats-grid", to: "players#stats_grid"
      post "/refresh", to: "players#refresh"
    end

    collection do
      get "/search", to: "players#search"
      get "/random", to: "players#random"
      get "/request", to: "players#request_new"
      post "/request", to: "players#request_create"
    end
  end
end
