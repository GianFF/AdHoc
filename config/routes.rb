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
    get 'escritos_para_clonar/:id', to: 'escritos#escritos_para_clonar', as: :escritos_para_clonar
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

    get 'clonar/:id/:en_id', to: 'demandas#clonar', as: :clonar_demanda
    get 'clonar/:id/:en_id', to: 'contestacion_de_demandas#clonar', as: :clonar_contestacion_de_demanda
    get 'clonar/:id/:en_id', to: 'mero_tramites#clonar', as: :clonar_mero_tramite
    get 'clonar/:id/:en_id', to: 'notificacions#clonar', as: :clonar_notificacion
  end

  get 'buscar', to: 'query#buscar', as: :buscar

  root 'clientes#new'
end
