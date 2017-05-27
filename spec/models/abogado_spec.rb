require 'rails_helper'

describe Abogado, type: :model do

  let(:fabrica_de_objetos){ FabricaDeObjetos.new }

  context 'En la correcta registracion de un abogado' do

    # mail, contrasenia, nombre, apellido, sexo, una_matricula, un_colegio, un_cuit, un_domicilio_procesal, un_domicilio_electronico

    let(:parametros) {
      fabrica_de_objetos.parametros_para_un_abogado(fabrica_de_objetos.un_mail_para_un_abogado,
                                                    fabrica_de_objetos.una_contrasenia,
                                                    fabrica_de_objetos.un_nombre_para_un_abogado,
                                                    fabrica_de_objetos.un_apellido_para_un_abogado,
                                                    Sexo::MASCULINO,
                                                    fabrica_de_objetos.una_matricula,
                                                    fabrica_de_objetos.un_colegio,
                                                    fabrica_de_objetos.un_cuit,
                                                    fabrica_de_objetos.un_domicilio_procesal,
                                                    fabrica_de_objetos.un_domicilio_electronico)
    }

    subject { Abogado.create!(parametros) }

    context 'Se compone de' do

      it 'nombre' do
        abogado = subject

        expect(abogado.nombre).to eq fabrica_de_objetos.un_nombre_para_un_abogado
      end

      it 'apellido' do
        abogado = subject

        expect(abogado.apellido).to eq fabrica_de_objetos.un_apellido_para_un_abogado
      end

      it 'email' do
        abogado = subject

        expect(abogado.email).to eq fabrica_de_objetos.un_mail_para_un_abogado
      end

      it 'sexo' do
        abogado = subject

        expect(abogado.sexo).to eq Sexo::MASCULINO
      end

      it 'matricula' do
        abogado = subject

        expect(abogado.matricula).to eq fabrica_de_objetos.una_matricula
      end

      it 'nombre del colegio de abogados' do
        abogado = subject

        expect(abogado.nombre_del_colegio_de_abogados).to eq fabrica_de_objetos.un_colegio
      end

      it 'cuit' do
        abogado = subject

        expect(abogado.cuit).to eq fabrica_de_objetos.un_cuit
      end

      it 'domicilio procesal' do
        abogado = subject

        expect(abogado.domicilio_procesal).to eq fabrica_de_objetos.un_domicilio_procesal
      end

      it 'domicilio electronico' do
        abogado = subject

        expect(abogado.domicilio_electronico).to eq fabrica_de_objetos.un_domicilio_electronico
      end
    end

    it 'dos abogados no pueden tener el mismo email' do
      subject
      abogado = Abogado.create(parametros)

      expect{Abogado.create!(parametros)}.to raise_error ActiveRecord::RecordInvalid
      expect(abogado.errors.full_messages).to include("Email #{Abogado.mensaje_de_error_para_campo_tomado}")
      expect(Abogado.count).to be 1
    end
  end

  context 'En la incorrecta registracion de un abogado' do

    it 'un abogado no puede registrarse sin nombre' do
      parametros = { apellido: 'Bar', sexo: 'Masculino', email: 'ejemplo@mail.com', password: 'password'}
      abogado = Abogado.create(parametros)

      expect{Abogado.create!(parametros)}.to raise_error ActiveRecord::RecordInvalid
      expect(abogado.errors.full_messages).to include("Nombre #{Abogado.mensaje_de_error_para_campo_vacio}")
    end

    it 'un abogado no puede registrarse sin apellido' do
      parametros = { nombre: 'Foo', sexo: 'Masculino', email: 'ejemplo@mail.com', password: 'password'}
      abogado = Abogado.create(parametros)

      expect{Abogado.create!(parametros)}.to raise_error ActiveRecord::RecordInvalid
      expect(abogado.errors.full_messages).to include("Apellido #{Abogado.mensaje_de_error_para_campo_vacio}")
    end

    it 'un abogado no puede registrarse sin email' do
      parametros = { nombre: 'Foo', apellido: 'Bar', sexo: 'Masculino', password: 'password'}
      abogado = Abogado.create(parametros)

      expect{Abogado.create!(parametros)}.to raise_error ActiveRecord::RecordInvalid
      expect(abogado.errors.full_messages).to include("Email #{Abogado.mensaje_de_error_para_campo_vacio}")
    end

    it 'un abogado no puede registrarse sin sexo' do
      parametros = { nombre: 'Foo', apellido: 'Bar', email: 'ejemplo@mail.com', password: 'password'}
      abogado = Abogado.create(parametros)

      expect{Abogado.create!(parametros)}.to raise_error ActiveRecord::RecordInvalid
      expect(abogado.errors.full_messages).to include("Sexo #{Abogado.mensaje_de_error_para_campo_vacio}")
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
