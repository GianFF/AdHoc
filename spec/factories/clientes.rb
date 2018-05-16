FactoryBot.define do
  factory :cliente do
    nombre 'Gian Franco'
    apellido 'Fioriello'
    empresa 'Edymberg S.A'
    estado_civil 'Soltero'
    telefono 42545254
    correo_electronico 'gf.fioriello@gmail.com'
    trabaja_en_blanco true
    abogado
  end

  factory :clienta, class: Cliente do
    nombre 'Florencia Lucia'
    apellido 'Giuliani'
    empresa 'Edymberg S.A'
    estado_civil 'Soltera'
    telefono 42545254
    correo_electronico 'fl.giuliani@gmail.com'
    trabaja_en_blanco true
    association :abogado, factory: :abogada
  end
end
