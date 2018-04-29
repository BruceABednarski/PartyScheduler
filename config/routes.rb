Rails.application.routes.draw do
  get 'parties/index'

  get 'parties_controller/index'
  
  resources :parties

  root 'parties#index'
  post 'parties/index', to: 'parties#index'
  get 'parties/new', to: 'parties#new'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
