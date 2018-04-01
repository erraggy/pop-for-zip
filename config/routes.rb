Rails.application.routes.draw do
  post 'cbsa_to_msa/reload'

  post 'zip_to_cbsa/reload'

  get 'lookup/show'

  root 'home#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
