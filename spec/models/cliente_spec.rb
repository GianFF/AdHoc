require_relative '../rails_helper'

describe 'Cliente', type: :model do

  context 'En la correcta creacion de un cliente' do

    let(:cliente) { Cliente.new(nombre: 'Foo', apellido: 'Bar') }

    it 'el cliente debe ser creado con un nombre completo' do

      expect(cliente.nombre).to eq "Foo"
      expect(cliente.apellido).to eq "Bar"
    end

    it 'el cliente tiene un correo_electronico valido' do
      cliente.correo_electronico = "foo_bar@zaz.com"

      expect(cliente.correo_electronico).to eq "foo_bar@zaz.com"
    end

    it 'el cliente tiene una direccion' do
      calle = "Alem 123"
      localidad = "CABA"
      provincia = "Buenos Aires"
      pais = "Argentina"
      direccion = Direccion.new(calle: calle, localidad: localidad, provincia: provincia, pais: pais)

      cliente.direccion = direccion

      expect(cliente.calle).to eq calle
      expect(cliente.localidad).to eq localidad
      expect(cliente.provincia).to eq provincia
      expect(cliente.pais).to eq pais
    end

    it 'el cliente tiene un telefono' do
      cliente.telefono = 12341234

      expect(cliente.telefono).to eq 12341234
    end

    it 'el cliente tiene un estado civil' do
      cliente.estado_civil = "Soltero"

      expect(cliente.estado_civil).to eq "Soltero"
    end

    it 'se debe especificar el nombre de la empresa para la que trabaja' do
      cliente.empresa = "Edymberg"

      expect(cliente.empresa).to eq "Edymberg"
    end

    it 'se debe especificar si trabaja en blanco' do
      cliente.esta_en_blanco = true

      expect(cliente.esta_en_blanco).to eq true
    end

    context 'En La carga opcional de los datos del conyuge' do

      it 'se debe especificar el nombre completo del conyuge' do
        conyuge = Conyuge.new(nombre: "Bar", apellido: "Foo")

        cliente.conyuge = conyuge

        expect(cliente.nombre_conyuge).to eq "Bar"
        expect(cliente.apellido_conyuge).to eq "Foo"
      end
    end

    context 'En La carga opcional de los datos de los hijos' do
      let(:hijo){ Hijo.new(nombre: "Zaz", apellido: "Bar") }

      it 'se puede cargar mas de un hijo' do
        otro_hijo = Hijo.new(nombre: "Zaz", apellido: "Bar")
        hijos = [hijo, otro_hijo]

        cliente.agregar_hijo hijo
        cliente.agregar_hijo otro_hijo

        expect(cliente.hijos).to eq hijos
      end
    end
  end
end