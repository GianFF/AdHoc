FactoryBot.define do
  factory :abogado do
    nombre 'Pablo'
    apellido 'Caceres'
    nombre_del_colegio_de_abogados 'C.A.Q'
    domicilio_procesal 'Mitre N° 262'
    genero Generos::Genero::MASCULINO
    matricula 'T° X F° 26'
    cuit '27-16965263-5'
    domicilio_electronico '27375970725@notificaciones.scba.gov.ar'
    email 'pablo@mail.com'
    password 'abogado16965263'
  end

  factory :abogada, class: Abogado do
    nombre 'Noelia'
    apellido 'Fioriello'
    nombre_del_colegio_de_abogados 'C.A.Q'
    domicilio_procesal 'Mitre N° 262'
    genero Generos::Genero::FEMENINO
    matricula 'T° X F° 27'
    cuit '20-30568123-7'
    domicilio_electronico '20305681237@notificaciones.scba.gov.ar'
    email 'noelia@mail.com'
    password 'abogado16965263'
  end
end