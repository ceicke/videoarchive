Rails.application.routes.draw do
  resources :movies do
    resources :chapters
  end

  root 'movies#index'
end
