require 'sidekiq/web'
Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  devise_for :users, controllers: { registrations: 'registrations' }
  devise_scope :user do  
     get '/users/sign_out' => 'devise/sessions#destroy'     
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  root to: "patients#index"
  resources :patients do
     resources :medicine_schedules do
      resources :medicines
    end
  end

  # Defines the root path route ("/")
  # root "posts#index"
end
