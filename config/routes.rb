Rails.application.routes.draw do
  resources :movies do
    member do
      get 'edit_meta'
    end
    resources :chapters, only: [:create, :update, :destroy]
  end

  root 'movies#index'
end
