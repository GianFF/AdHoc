FactoryBot.define do
  factory :expediente do
    actor 'Juan Pepe'
    demandado 'Maria Perez'
    materia 'Daños y Perjuicios'
    cliente
  end

  factory :expediente_de_clienta, class: Expediente do
    actor 'Florencia Giuliani'
    demandado 'Pepe Gonzalez'
    materia 'Daños y Perjuicios'
    association :cliente, factory: :clienta
  end

  factory :expediente_numerado, class: Expediente do
    actor 'Juan Pepe'
    demandado 'Maria Perez'
    materia 'Daños y Perjuicios'
    numero 123
    juzgado 'Juzgado Civil y Comercial'
    numero_de_juzgado 7
    departamento 'Departamento Judicial de Quilmes'
    ubicacion_del_departamento 'Alvear 465 piso N°1 de Quilmes'
    cliente
  end
end