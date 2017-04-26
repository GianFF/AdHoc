require 'rails_helper'

describe Abogado, type: :model do

  context 'En la correcta registracion de un abogado' do
    let(:parametros) {
      { nombre: 'Foo', apellido: 'Bar', sexo: 'Masculino', email: 'ejemplo@mail.com', password: 'password'}
    }

    it 'un abogado tiene nombre, apellido, email, y sexo' do

    end

    it 'un abogado tiene una contraseña' do

    end

    it 'dos abogados no pueden tener el mismo email' do

    end
  end

  context 'En la incorrecta registracion de un abogado' do

    it 'un abogado no puede registrarse sin nombre' do
    end

    it 'un abogado no puede registrarse sin apellido' do
    end

    it 'un abogado no puede registrarse sin email' do
    end

    it 'un abogado no puede registrarse sin sexo' do
    end

    it 'un abogado no puede registrase si su contraseña es menor a 6 digitos' do

    end

  end

  it 'el sexo de un abogado solo puede ser Masculino o Femenino' do

  end
end
