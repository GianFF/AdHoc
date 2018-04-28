require 'rails_helper'

describe Abogado, type: :model do
  include FactoryBot::Syntax::Methods

  let(:abogado){ create(:abogado) }

  context 'Un abogado no puede crearse sin' do

    it 'nombre' do
      expect{create(:abogado, nombre: '')}.to raise_error ActiveRecord::RecordInvalid
      expect{create(:abogado, nombre: nil)}.to raise_error ActiveRecord::RecordInvalid
    end

    it 'apellido' do
      expect{create(:abogado, apellido: '')}.to raise_error ActiveRecord::RecordInvalid
      expect{create(:abogado, apellido: nil)}.to raise_error ActiveRecord::RecordInvalid
    end

    it 'email' do
      expect{create(:abogado, email: '')}.to raise_error ActiveRecord::RecordInvalid
      expect{create(:abogado, email: nil)}.to raise_error ActiveRecord::RecordInvalid
    end

    it 'sexo' do
      expect{create(:abogado, genero: '')}.to raise_error ActiveRecord::RecordInvalid
      expect{create(:abogado, genero: nil)}.to raise_error ActiveRecord::RecordInvalid
    end

    it 'cuit' do
      expect{create(:abogado, cuit: '')}.to raise_error ActiveRecord::RecordInvalid
      expect{create(:abogado, cuit: nil)}.to raise_error ActiveRecord::RecordInvalid
    end

    it 'matricula' do
      expect{create(:abogado, matricula: '')}.to raise_error ActiveRecord::RecordInvalid
      expect{create(:abogado, matricula: nil)}.to raise_error ActiveRecord::RecordInvalid
    end

    it 'domicilio procesal' do
      expect{create(:abogado, domicilio_procesal: '')}.to raise_error ActiveRecord::RecordInvalid
      expect{create(:abogado, domicilio_procesal: nil)}.to raise_error ActiveRecord::RecordInvalid
    end

    it 'domicilio electronico' do
      expect{create(:abogado, domicilio_electronico: '')}.to raise_error ActiveRecord::RecordInvalid
      expect{create(:abogado, domicilio_electronico: nil)}.to raise_error ActiveRecord::RecordInvalid
    end
  end

  context 'Dos abogados no pueden tener el mismo' do

    it 'email' do
      expect{create(:abogada, email: abogado.email)}.to raise_error ActiveRecord::RecordInvalid
    end

    it 'matricula' do
      expect{create(:abogada, matricula: abogado.matricula)}.to raise_error ActiveRecord::RecordInvalid
    end

    it 'domicilio electronico' do
      expect{create(:abogada, domicilio_electronico: abogado.domicilio_electronico)}.to raise_error ActiveRecord::RecordInvalid
    end

    it 'cuit' do
      expect{create(:abogada, cuit: abogado.cuit)}.to raise_error ActiveRecord::RecordInvalid
    end
  end

  it 'el sexo de un abogado solo puede ser Masculino o Femenino' do #TODO: esto no es inclusivo
    expect{create(:abogada, genero: "Ni masculino ni femenino")}.to raise_error ActiveRecord::RecordInvalid
  end

  it 'no puede crearse si su contraseña es menor a 6 digitos' do
    expect{create(:abogada, password: 'abc')}.to raise_error ActiveRecord::RecordInvalid
  end

  it '#nombre_completo' do
    expect(abogado.nombre_completo).to eq 'Caceres Pablo'
  end

  it '#presentacion' do
    expect(abogado.presentacion).to eq 'Dr. Caceres Pablo'
  end

  it '#tu_email_es?' do
    expect(abogado.tu_email_es? abogado.email).to be true
    expect(abogado.tu_email_es? 'otromail@mail.com').to be false
  end

  it '#doctor_o_doctora' do
    expect(abogado.doctor_o_doctora).to eq 'Dr.'
  end

  it '#inscripta_inscripto' do
    expect(abogado.inscripta_inscripto).to eq 'inscripto'
  end

  it '#abogada_abogado' do
    expect(abogado.abogada_abogado).to eq  'abogado'
  end

  it '#la_el' do
    expect(abogado.la_el).to eq 'el'
  end

  it '#letrada_letrado' do
    expect(abogado.letrada_letrado).to eq 'letrado'
  end
end
