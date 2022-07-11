# frozen_string_literal: true

Rails.application.routes.draw do
  scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/ do
    resources :tasks
    resources :projects
    root to: 'pages#home'
    devise_for :users
    get 'ul', to: 'pages#ul_page'
  end
end
