require 'rails_helper'

describe AdHocAbogados do
  include FactoryBot::Syntax::Methods

  let(:un_abogado){ create(:abogado) }

  let(:parametros){ {
      password: un_abogado.password,
      encrypted_password: un_abogado.password
  }}

  subject { AdHocAbogados.new.editar_abogado!(un_abogado, parametros) }

  context 'Un abogado puede editar' do

    it 'su nombre y apellido' do
      parametros[:nombre] = 'Otro nombre'
      parametros[:apellido] = 'Otro apellido'

      subject

      expect(un_abogado.nombre).to eq parametros[:nombre]
      expect(un_abogado.apellido).to eq parametros[:apellido]
    end

    it 'su matricula' do
      parametros[:matricula] = 'Otra matricula'

      subject

      expect(un_abogado.matricula).to eq parametros[:matricula]
      expect(Abogado.count).to be 1
    end

    it 'el nombre del colegio de abogados' do
      parametros[:nombre_del_colegio_de_abogados] = 'C.A.B'

      subject

      expect(un_abogado.nombre_del_colegio_de_abogados).to eq parametros[:nombre_del_colegio_de_abogados]
    end

    it 'su cuit' do
      parametros[:cuit] = '12345689'

      subject

      expect(un_abogado.cuit).to eq parametros[:cuit]
    end

    it 'su domicilio procesal' do
      parametros[:domicilio_procesal] = 'Otro domicilio procesal'

      subject

      expect(un_abogado.domicilio_procesal).to eq parametros[:domicilio_procesal]
    end

    it 'su domicilio electronico' do
      parametros[:domicilio_electronico] = 'otro domicilio electronico'

      subject

      expect(un_abogado.domicilio_electronico).to eq parametros[:domicilio_electronico]
    end

    it 'el email' do
      parametros[:email] = 'otro_mail@mail.com'

      subject

      expect(un_abogado.email).to eq parametros[:email]
    end
  end

  context 'No se puede editar un abogado cuando' do

    it 'su contraseña es incorrecta' do
      parametros[:password] = 'algoIncorrecto'
      parametros[:encrypted_password] = 'algoIncorrecto'

      expect{subject}.to raise_error Errores::AdHocDomainError
      expect(un_abogado.password).to_not be parametros[:password]
    end

    it 'no provee la contraseña' do
      parametros[:password] = ''
      parametros[:encrypted_password] = ''

      expect{subject}.to raise_error Errores::AdHocDomainError
      expect(un_abogado.password).to_not be parametros[:password]
    end

    it 'el nombre es vacío' do
      parametros[:nombre] = ''

      expect{subject}.to raise_error Errores::AdHocDomainError
      expect(un_abogado.nombre).to_not be parametros[:nombre]
    end

    it 'el apellido es vacío' do
      parametros[:apellido] = ''

      expect{subject}.to raise_error Errores::AdHocDomainError
      expect(un_abogado.apellido).to_not be parametros[:apellido]
    end

    it 'el email es vacío' do
      parametros[:email] = ''

      expect{subject}.to raise_error Errores::AdHocDomainError
      expect(un_abogado.email).to_not be parametros[:email]
    end

    it 'el colegio de abogados es vacío' do
      parametros[:nombre_del_colegio_de_abogados] = ''

      expect{subject}.to raise_error Errores::AdHocDomainError
      expect(un_abogado.nombre_del_colegio_de_abogados).to_not be parametros[:nombre_del_colegio_de_abogados]
    end

    it 'la matricula es vacía' do
      parametros[:matricula] = ''

      expect{subject}.to raise_error Errores::AdHocDomainError
      expect(un_abogado.matricula).to_not be parametros[:matricula]
    end

    it 'el cuit es vacío' do
      parametros[:cuit] = ''

      expect{subject}.to raise_error Errores::AdHocDomainError
      expect(un_abogado.cuit).to_not be parametros[:cuit]
    end

    it 'el domicilio procesal es vacío' do
      parametros[:domicilio_procesal] = ''

      expect{subject}.to raise_error Errores::AdHocDomainError
      expect(un_abogado.domicilio_procesal).to_not be parametros[:domicilio_procesal]
    end

    it 'el domicilio electronico es vacío' do
      parametros[:domicilio_electronico] = ''

      expect{subject}.to raise_error Errores::AdHocDomainError
      expect(un_abogado.domicilio_electronico).to_not be parametros[:domicilio_electronico]
    end
  end
end
