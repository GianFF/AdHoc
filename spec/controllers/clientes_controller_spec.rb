require 'rails_helper'

describe ClientesController do
  include ::ControllersHelper
  include FactoryBot::Syntax::Methods

  let(:abogado){ abogado_logeado }
  let(:cliente) { create(:cliente, abogado: abogado) }
  let(:ad_hoc){ AdHocClientes.new }

  context 'Creacion de clientes' do
    before do
      abogado_logeado
    end

    subject { post :create, params: parametros }

    context 'En la correcta creacion de un cliente' do
      let(:hijo) { attributes_for(:hijo) }
      let(:hija) { attributes_for(:hija) }
      let(:parametros) do
        {cliente: attributes_for(:cliente)}
      end

      it 'con un nombre y un  apellido el cliente se crea satisfactoriamente' do
        subject

        cliente = Cliente.all.first

        expect(response).to have_http_status(:ok)
        expect(flash[:success]).to eq ad_hoc.mensaje_cliente_creado_correctamente
      end

      context 'Con un hijo' do
        let(:parametros) do
          {
              cliente: attributes_for(:cliente),
              hijos: [hijo]
          }
        end

        pending 'el cliente se crea satisfactoriamente' do
          subject

          cliente = Cliente.all.first

          expect(cliente.hijos).to contain_exactly hijo
          expect(response).to have_http_status(:ok)
          expect(flash[:success]).to eq ad_hoc.mensaje_cliente_creado_correctamente
        end
      end

      context 'Con mas de un hijo' do
        let(:parametros) do
          {
              cliente: attributes_for(:cliente),
              hijos: [hijo, hija]
          }
        end

        pending 'el cliente se crea satisfactoriamente' do
          subject

          cliente = Cliente.all.first

          expect(cliente.hijos).to contain_exactly(hijo, hija)
          expect(response).to have_http_status(:ok)
          expect(flash[:success]).to eq ad_hoc.mensaje_cliente_creado_correctamente
        end
      end
    end

    context 'En la incorrecta creacion de un cliente' do
      let (:parametros) do
        { cliente: attributes_for(:cliente, nombre: '', apellido: '') }
      end

      it 'sin nombre y apellido no puede ser creado' do
        subject

        expect(response).to have_http_status(:ok)
        expect(flash[:error]).to include "Apellido #{Cliente.mensaje_de_error_para_campo_vacio}"
        expect(flash[:error]).to include "Nombre #{Cliente.mensaje_de_error_para_campo_vacio}"
      end
    end
  end

  context 'Busqueda de clientes' do

    context 'Cuando el cliente buscado existe' do

      context 'Cuando se busca por nombre' do

        subject { get :index, params: { query: cliente.nombre }}

        it 'te redirecciona a la vista del cliente' do
          subject

          assert_template :show
          expect(response).to have_http_status(:ok)
        end
      end

      context 'Cuando se busca por apellido' do

        subject { get :index, params: { query: cliente.apellido }}

        it 'te redirecciona a la vista del cliente' do
          subject

          assert_template :show
          expect(response).to have_http_status(:ok)
        end
      end

      context 'Cuando se busca por una letra' do

        subject { get :index, params: { query: cliente.apellido.last} }

        it 'te redirecciona a la vista del cliente' do
          subject

          assert_template :show
          expect(response).to have_http_status(:ok)
        end
      end
    end

    context 'Cuando el cliente buscado no existe' do

      subject { get :index, params: { query: 'ñ' }}

      before do
        abogado_logeado
      end

      it 'devuelve un mensaje de error' do
        subject

        expect(flash[:error]).to include(ad_hoc.mensaje_de_error_para_busqueda_de_cliente_fallida('ñ'))
        assert_template :new
        expect(response).to have_http_status(:ok)
      end
    end
  end

  context 'Edicion de clientes' do

    context 'En la correcta edicion de un cliente' do

      subject do
        put :update,
            params: {
                id: cliente.id,
                cliente: {
                    nombre: 'Juan',
                    apellido: 'Perez'
                }
            }
      end

      it 'se le puede cambiar el nombre y el apellido' do
        subject

        cliente.reload

        expect(cliente.nombre).to eq 'Juan'
        expect(cliente.apellido).to eq 'Perez'
        assert_template :show
        expect(response).to have_http_status(:ok)
        expect(flash[:success]).to eq ad_hoc.mensaje_de_confirmacion_para_la_correcta_edicion_de_un_cliente
      end
    end

    context 'En la incorrecta edicion del cliente' do

      context 'Cuando el cliente a editar existe' do
        subject do
          put :update,
              params: {
                  id: cliente.id,
                  cliente: {
                      nombre: nil,
                      apellido: nil
                  }
              }
        end

        it 'no se puede poner un nombre o apellido vacio' do
          subject

          cliente.reload

          expect(cliente.nombre).to eq cliente.nombre
          expect(cliente.apellido).to eq cliente.apellido
          expect(flash[:error]).to include("Nombre #{Cliente.mensaje_de_error_para_campo_vacio}")
          expect(flash[:error]).to include("Apellido #{Cliente.mensaje_de_error_para_campo_vacio}")
          expect(response).to have_http_status(:ok)
        end
      end

      context 'Cuando el cliente a editar no existe' do
        subject do
          put :update,
              params: {
                  id: cliente.id+2,
                  cliente: {
                      nombre: cliente.nombre,
                      apellido: cliente.apellido
                  }
              }
        end

        it 'te redirije a la home' do
          subject

          cliente.reload

          expect(cliente.nombre).to eq cliente.nombre
          expect(cliente.apellido).to eq cliente.apellido
          expect(flash[:error]).to include(ad_hoc.mensaje_de_error_para_cliente_inexistente)
          expect(response).to have_http_status(:bad_request)
        end
      end
    end
  end

  context 'Borrado de clientes' do

    context 'Cuando el cliente a borrar existe'do
      subject { delete :destroy, params: { id: cliente.id }}

      it 'se puede eliminar un cliente' do
        subject

        expect(Cliente.all.count).to eq 0
        expect(flash[:success]).to eq ad_hoc.mensaje_de_confirmacion_para_correcta_eliminacion_de_un_cliente
        expect(response).to have_http_status(:ok)
      end
    end

    context 'Cuando el cliente a borrar no existe'do
      subject { delete :destroy, params: { id: cliente.id+1 }}

      it 'te redirije a la home' do
        subject

        expect(Cliente.all.count).to eq 1
        expect(flash[:error]).to include(ad_hoc.mensaje_de_error_para_cliente_inexistente)
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
