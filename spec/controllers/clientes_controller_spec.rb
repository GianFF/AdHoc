require_relative '../rails_helper'

# TODO: llevar a un helper
def login_abogado
  abogado = Abogado.create!(email: 'ejemplo@mail.com', password: 'password',
                            nombre: 'Foo', apellido: 'Bar', sexo: 'Masculino')
  #abogado.confirm
  sign_in abogado
  abogado
end

def crear_cuenta_para_abogado
  abogado = Abogado.create!(email: 'otro_ejemplo@mail.com', password: 'password',
                            nombre: 'Bar', apellido: 'Zaz', sexo: 'Femenino')
  #abogado.confirm
  abogado
end

describe ClientesController do

  before(:each) do
    @abogado = login_abogado
  end


  context 'Creacion de clientes' do
    subject { post :create, params: parametros }

    context 'En la correcta creacion de un cliente' do
      let(:parametros) { {cliente: {nombre: 'Foo', apellido: 'Bar', abogado_id: @abogado.id}} }

      it 'con un nombre y un  apellido el cliente se crea satisfactoriamente' do
        subject

        cliente = Cliente.all.first

        expect(cliente.nombre).to eq 'Foo'
        expect(cliente.apellido).to eq 'Bar'

        expect(response).to have_http_status(:ok)
        expect(flash[:success]).to eq 'Cliente creado satisfactoriamente'
      end

      it 'pertenece a un abogado' do
        otro_abogado = crear_cuenta_para_abogado
        subject

        cliente = Cliente.all.first

        expect(cliente.pertenece_a? @abogado).to be true
        expect(cliente.pertenece_a? otro_abogado).to be false
      end

      context 'Con campos opcionales' do
        let(:parametros) { {cliente: {
            abogado_id: @abogado.id,
            nombre: 'Foo',
            apellido: 'Bar',
            telefono: 42545254,
            correo_electronico: 'foo@bar.com',
            estado_civil: 'soltero',
            empresa: 'Edymberg',
            esta_en_blanco: true
        }}
        }

        it 'con nombre, apellido, telefono, email, estado civil, empresa y si esta en blanco se crea satisfactoriamente' do
          subject

          cliente = Cliente.all.first

          expect(cliente.telefono).to eq 42545254
          expect(cliente.correo_electronico).to eq 'foo@bar.com'
          expect(cliente.estado_civil).to eq 'soltero'
          expect(cliente.empresa).to eq 'Edymberg'
          expect(cliente.esta_en_blanco).to eq true

          expect(response).to have_http_status(:ok)
          expect(flash[:success]).to eq 'Cliente creado satisfactoriamente'
        end
      end

      context 'Con una direccion' do
        let(:parametros) { {
            cliente: {
              abogado_id: @abogado.id,
              nombre: 'Foo',
              apellido: 'Bar'
            },
            direccion: {
                calle: 'Andres Baranda',
                localidad: 'Quilmes',
                provincia: 'Buenos Aires',
                pais: 'Argentina'
            }
          }
        }

        pending 'con un nombre, apellido y una direccion el cliente se crea satisfactoriamente' do
          subject

          cliente = Cliente.all.first

          expect(cliente.calle).to eq 'Andres Baranda'
          expect(cliente.localidad).to eq 'Quilmes'
          expect(cliente.provincia).to eq 'Buenos Aires'
          expect(cliente.pais).to eq 'Argentina'

          expect(cliente.esta_en_blanco).to eq true
          expect(response).to have_http_status(:ok)
          expect(flash[:success]).to eq 'Cliente creado satisfactoriamente'
        end
      end

      context 'Con hijos' do
        let(:parametros) { {
            cliente: {
                abogado_id: @abogado.id,
                nombre: 'Foo',
                apellido: 'Bar'
            },
            hijo: {
                nombre: 'Baz',
                apellido: 'Bar'
            }
          }
        }

        context 'Con un hijo' do

          pending 'con un nombre, apellido y un hijo el cliente se crea satisfactoriamente' do
            subject

            cliente = Cliente.all.first

            expect(cliente.hijos.first.nombre).to eq 'Baz'
            expect(cliente.hijos.first.apellido).to eq 'Bar'

            expect(cliente.esta_en_blanco).to eq true
            expect(response).to have_http_status(:ok)
            expect(flash[:success]).to eq 'Cliente creado satisfactoriamente'
          end
        end

        context 'Con mas de un hijo' do

          pending 'con un nombre, apellido y mas de un hijo el cliente se crea satisfactoriamente' do
            subject

            cliente = Cliente.all.first

            expect(cliente.hijos.first.nombre).to eq 'Baz'
            expect(cliente.hijos.first.apellido).to eq 'Bar'

            expect(cliente.esta_en_blanco).to eq true
            expect(response).to have_http_status(:ok)
            expect(flash[:success]).to eq 'Cliente creado satisfactoriamente'
          end
        end
      end
    end

    context 'En la incorrecta creacion de un cliente' do
      let (:parametros){ {cliente: {abogado_id: @abogado.id, nombre: nil, apellido: nil}} }

      it 'sin nombre y apellido no puede ser creado' do
        subject

        expect(flash[:error]).to eq 'El nombre y el apellido no pueden ser vacios'
        expect(response).to have_http_status(:ok)
      end
    end
  end

  context 'Busqueda de clientes' do

    before(:each) do
      Cliente.create!(nombre: 'Foo', apellido: 'Bar', abogado_id: @abogado.id)
    end

    context 'Cuando el cliente buscado existe' do

      context 'Cuando se busca por nombre' do

        subject { get :index, params: { query: 'Foo'} }

        it 'te redirecciona a la vista del cliente' do
          subject

          assert_template :show
          expect(response).to have_http_status(:ok)
        end
      end

      context 'Cuando se busca por apellido' do

        subject { get :index, params: { query: 'Bar'} }

        it 'te redirecciona a la vista del cliente' do
          subject

          assert_template :show
          expect(response).to have_http_status(:ok)
        end
      end

      context 'Cuando se busca por una letra' do

        subject { get :index, params: { query: 'o'} }

        it 'te redirecciona a la vista del cliente' do
          subject

          assert_template :show
          expect(response).to have_http_status(:ok)
        end
      end
    end

    context 'Cuando el cliente buscado no existe' do

      subject { get :index, query: 'Zaz' }

      it 'devuelve un mensaje de error' do
        subject

        expect(flash[:error]).to eq 'No se encontraron clientes con nombre: Zaz'
        assert_template :new
        expect(response).to have_http_status(:ok)
      end
    end
  end

  context 'Edicion de clientes' do
    let(:cliente){ Cliente.create!(abogado_id: @abogado.id, nombre: 'Foo', apellido: 'Bar') }

    context 'En la correcta creacion de un cliente' do

      subject { put :update, id: cliente.id, cliente: {nombre: 'Foo1', apellido: 'Bar1'}}

      it 'se le puede cambiar el nombre y el apellido' do
        subject

        cliente.reload

        expect(cliente.nombre).to eq 'Foo1'
        expect(cliente.apellido).to eq 'Bar1'
        expect(flash[:success]).to eq 'Cliente editado satisfactoriamente'
        expect(response).to have_http_status(:ok)
      end
    end

    context 'En la incorrecta edicion del cliente' do
      subject { put :update, id: cliente.id, cliente: {nombre: nil, apellido: nil}}

      it 'no se puede poner un nombre o apellido vacio' do
        subject

        cliente.reload

        expect(cliente.nombre).to eq 'Foo'
        expect(cliente.apellido).to eq 'Bar'
        expect(flash[:error]).to eq 'El nombre y el apellido no pueden ser vacios'
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  context 'Borrado de clientes' do
    let(:cliente){ Cliente.create!(abogado_id: @abogado.id, nombre: 'Foo', apellido: 'Bar') }

    subject { delete :destroy, id: cliente.id }

    it 'se puede eliminar un cliente' do
      subject

      expect(flash[:success]).to eq 'Cliente eliminado satisfactoriamente'
      expect(response).to have_http_status(:ok)
    end
  end
end