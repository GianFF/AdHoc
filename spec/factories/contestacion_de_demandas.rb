FactoryBot.define do
  factory :contestacion_de_demanda, class: Escritos::ContestacionDeDemanda do
    titulo 'un titulo'
    cuerpo 'un cuerpo'
    expediente
  end
end
