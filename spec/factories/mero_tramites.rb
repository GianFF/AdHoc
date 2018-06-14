FactoryBot.define do
  factory :mero_tramite, class: Escritos::MeroTramite do
    titulo 'un titulo'
    cuerpo 'un cuerpo'
    expediente
  end
end
