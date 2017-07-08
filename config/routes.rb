Rails.application.routes.draw do
  devise_for :abogados, controllers: {registrations: 'abogados'}

  resources :clientes do
    resources :expedientes
    patch 'numerar/:id', to: 'expedientes#realizar_numeraracion', as: :expediente_realizar_numeracion
    get 'numerar/:id', to: 'expedientes#numerar', as: :expediente_numerar
    put 'archivar/:id', to: 'expedientes#archivar', as: :expediente_archivar
  end

  get 'expedientes_archivados', to: 'expedientes#expedientes_archivados', as: :expedientes_archivados

  resources :expedientes do
    resources :demandas
    resources :contestacion_de_demandas
    resources :mero_tramites
    resources :notificacions
    resources :adjuntos
    #TODO: mejorar esto:
    put 'presentar/:id', to: 'demandas#presentar', as: :presentar_demanda
    put 'presentar/:id', to: 'contestacion_de_demandas#presentar', as: :presentar_contestacion_de_demanda
    put 'presentar/:id', to: 'mero_tramites#presentar', as: :presentar_mero_tramite
    put 'presentar/:id', to: 'notificacions#presentar', as: :presentar_notificacion
  end

  resources :escritos

  get 'buscar', to: 'query#buscar', as: :buscar

  root 'clientes#new'
end
