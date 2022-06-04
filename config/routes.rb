Rails.application.routes.draw do
  resources :tasks
  root to: 'page#home'
  devise_for :users
end
