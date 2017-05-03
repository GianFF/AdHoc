Rails.application.routes.draw do
  devise_for :abogados, :controllers => {:registrations => 'abogados'}
  resources :clientes

  root 'clientes#new'
end
