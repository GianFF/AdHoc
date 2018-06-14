FactoryBot.define do
  factory :demanda, class: Escritos::Demanda do
    titulo 'un titulo'
    cuerpo 'un cuerpo'
    expediente
  end
end
