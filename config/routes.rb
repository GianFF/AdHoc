Rails.application.routes.draw do
  devise_for :abogados, :controllers => {:registrations => 'abogados'}
  resources :clientes do
    resources :expedientes

    post 'numerar/:id/:numero/:anio/:juzgado/:numero_de_juzgado/:departamento/:ubicacion_del_departamento',
        to: 'expedientes#realizar_numeraracion', as: :expediente_realizar_numeracion


    get 'numerar/:id', to: 'expedientes#numerar', as: :expediente_numerar
  end

  root 'clientes#new'
end
