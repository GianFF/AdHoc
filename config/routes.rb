Rails.application.routes.draw do
  devise_for :abogados
  resources :clientes
  get '/clientes/buscar/:nombre', controller: 'clientes', action: 'buscar'

  root 'clientes#new'
end
