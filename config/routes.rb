Rails.application.routes.draw do
  devise_for :abogados, :controllers => {:registrations => 'abogados'}
  resources :clientes do
    resources :expedientes
  end

  root 'clientes#new'
end
