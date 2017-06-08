Rails.application.routes.draw do
  devise_for :abogados, :controllers => {:registrations => 'abogados'}

  resources :clientes do
    resources :expedientes
    patch 'numerar/:id', to: 'expedientes#realizar_numeraracion', as: :expediente_realizar_numeracion
    get 'numerar/:id', to: 'expedientes#numerar', as: :expediente_numerar
  end

  resources :expedientes do
    resources :demandas
    resources :contestacion_de_demandas
    resources :mero_tramites
  end

  root 'clientes#new'
end
