FactoryBot.define do
  factory :hijo do
    nombre 'Gorgio Franco'
    apellido 'Fioriello'
    edad 10
    cliente
  end

  factory :hija, class: Hijo do
    nombre 'Giovana Florencia'
    apellido 'Fioriello'
    edad 12
    cliente
  end
end
