Rails.application.routes.draw do
  resources :brands
  resources :equipment
  resources :clients
  devise_for :users
  get 'welcome/index'
  resources :employes

  root "welcome#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
