Rails.application.routes.draw do
  resources :clientes
  get '/clientes/buscar/:nombre', controller: 'clientes', action: 'buscar'

  root 'clientes#new'
end
