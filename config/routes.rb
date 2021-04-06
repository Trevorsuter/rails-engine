Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :items, only: [:index, :show, :create, :update]

      delete '/items/:id', to: 'items#destroy'
      get '/items/:id/merchant', to: 'items/merchant#index'

      resources :merchants, only: [:index, :show] do
        scope module: :merchants do
          resources :items, only: [:index, :show]
        end
      end
    end
  end
end
