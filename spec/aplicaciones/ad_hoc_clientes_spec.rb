require 'rails_helper'

describe AdHocClientes do

  include FactoryBot::Syntax::Methods

  let(:abogado){ create(:abogado) }
  let(:ad_hoc){ AdHocClientes.new }

  context 'Creacion de clientes' do
    subject { ad_hoc.crear_cliente_nuevo!(parametros, abogado) }

    context 'En la correcta creacion de un cliente' do
      let(:parametros) { attributes_for(:cliente) }

      it 'con un nombre y un  apellido el cliente se crea satisfactoriamente' do
        subject

        cliente = Cliente.all.first

        expect(cliente.nombre).to eq 'Gian Franco'
        expect(cliente.apellido).to eq 'Fioriello'
      end

      it 'pertenece a un abogado' do
        abogada = create(:abogada)

        subject

        cliente = Cliente.all.first
        expect(cliente.pertenece_a? abogado).to be true
        expect(cliente.pertenece_a? abogada).to be false
      end
    end

    context 'En la incorrecta creacion de un cliente' do
      it 'sin nombre no puede ser creado' do
        expect{ad_hoc.crear_cliente_nuevo!(attributes_for(:cliente, apellido: ''), abogado)}.to raise_error Errores::AdHocDomainError
      end

      it 'sin apellido no puede ser creado' do
        expect{ad_hoc.crear_cliente_nuevo!(attributes_for(:cliente, nombre: ''), abogado)}.to raise_error Errores::AdHocDomainError
      end
    end
  end

  context 'Busqueda de clientes' do

    subject { ad_hoc.buscar_cliente_por_nombre_o_apellido!(query, abogado.id)}

    let(:cliente){ create(:cliente, abogado: abogado) }

    context 'Cuando el cliente buscado existe' do


      context 'Cuando se busca por nombre' do
        let(:query){ cliente.nombre }

        it 'encuentra el primer cliente que matchea' do
          expect(subject).to eq cliente
        end
      end

      context 'Cuando se busca por apellido' do
        let(:query){ cliente.apellido }

        it 'encuentra el primer cliente que matchea' do
          expect(subject).to eq cliente
        end
      end

      context 'Cuando se busca por una letra' do

        let(:query){ cliente.nombre[0] }

        it 'encuentra el primer cliente que matchea' do
          expect(subject).to eq cliente
        end
      end
    end

    context 'Cuando el cliente buscado no existe' do
      let(:query) { 'Jorge' }

      it 'devuelve un mensaje de error' do
        expect{subject}.to raise_error(Errores::AdHocDomainError)
      end
    end
  end

  context 'Edicion de clientes' do
    let(:cliente){ create(:cliente, abogado: abogado) }

    subject { ad_hoc.editar_cliente!(cliente.id, {nombre:'', apellido:''}, abogado) }

    it 'no se puede poner un nombre o apellido vacio' do
      expect{subject}.to raise_error Errores::AdHocDomainError
      expect(cliente.nombre).to eq 'Gian Franco'
      expect(cliente.apellido).to eq 'Fioriello'
    end
  end

  context 'Borrado de clientes' do
    let(:cliente){ create(:cliente, abogado: abogado) }

    subject { ad_hoc.eliminar_cliente!(cliente.id, abogado.id)}

    it 'se puede eliminar un cliente' do
      subject

      expect(Cliente.all.count).to eq 0
    end
  end
end
