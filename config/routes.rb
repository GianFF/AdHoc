Rails.application.routes.draw do
  devise_for :abogados, :controllers => {:registrations => 'abogados'}
  resources :clientes
  resources :expedientes

  root 'clientes#new'
end
