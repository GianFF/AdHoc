require 'rails_helper'

describe Abogado, type: :model do

  context 'En la correcta registracion de un abogado' do
    let(:parametros) {
      { nombre: 'Foo', apellido: 'Bar', sexo: 'Masculino', email: 'ejemplo@mail.com', password: 'password'}
    }

    subject { Abogado.create!(parametros) }

    it 'un abogado tiene nombre, apellido, email, y sexo' do
      abogado = subject

      expect(abogado.nombre).to eq 'Foo'
      expect(abogado.apellido).to eq 'Bar'
      expect(abogado.email).to eq 'ejemplo@mail.com'
    end

    it 'dos abogados no pueden tener el mismo email' do
      subject
      abogado = Abogado.create(parametros)

      expect{Abogado.create!(parametros)}.to raise_error ActiveRecord::RecordInvalid
      expect(abogado.errors.full_messages).to include("Email #{Abogado.mensaje_de_error_para_email_tomado}")
      expect(Abogado.count).to be 1
    end
  end

  context 'En la incorrecta registracion de un abogado' do

    it 'un abogado no puede registrarse sin nombre' do
      parametros = { apellido: 'Bar', sexo: 'Masculino', email: 'ejemplo@mail.com', password: 'password'}
      abogado = Abogado.create(parametros)

      expect{Abogado.create!(parametros)}.to raise_error ActiveRecord::RecordInvalid
      expect(abogado.errors.full_messages).to include("Nombre #{Abogado.mensaje_de_error_para_nombre_en_blanco}")
    end

    it 'un abogado no puede registrarse sin apellido' do
      parametros = { nombre: 'Foo', sexo: 'Masculino', email: 'ejemplo@mail.com', password: 'password'}
      abogado = Abogado.create(parametros)

      expect{Abogado.create!(parametros)}.to raise_error ActiveRecord::RecordInvalid
      expect(abogado.errors.full_messages).to include("Apellido #{Abogado.mensaje_de_error_para_apellido_en_blanco}")
    end

    it 'un abogado no puede registrarse sin email' do
      parametros = { nombre: 'Foo', apellido: 'Bar', sexo: 'Masculino', password: 'password'}
      abogado = Abogado.create(parametros)

      expect{Abogado.create!(parametros)}.to raise_error ActiveRecord::RecordInvalid
      expect(abogado.errors.full_messages).to include("Email #{Abogado.mensaje_de_error_para_email_en_blanco}")
    end

    it 'un abogado no puede registrarse sin sexo' do
      parametros = { nombre: 'Foo', apellido: 'Bar', email: 'ejemplo@mail.com', password: 'password'}
      abogado = Abogado.create(parametros)

      expect{Abogado.create!(parametros)}.to raise_error ActiveRecord::RecordInvalid
      expect(abogado.errors.full_messages).to include("Sexo #{Abogado.mensaje_de_error_para_sexo_en_blanco}")
    end

    it 'un abogado no puede registrase si su contraseña es menor a 6 digitos' do
      parametros = { nombre: 'Foo', apellido: 'Bar', email: 'ejemplo@mail.com', sexo: 'Masculino', password: 'abc'}

      expect{Abogado.create!(parametros)}.to raise_error ActiveRecord::RecordInvalid
    end

  end

  it 'el sexo de un abogado solo puede ser Masculino o Femenino' do
    parametros = { nombre: 'Foo', apellido: 'Bar', email: 'ejemplo@mail.com', sexo: 'Otro sexo', password: 'password'}
    abogado = Abogado.create(parametros)

    expect{Abogado.create!(parametros)}.to raise_error ActiveRecord::RecordInvalid
    expect(abogado.errors.full_messages).to include("Sexo #{Abogado.mensaje_de_error_para_sexo_en_invalido}")
  end
end
