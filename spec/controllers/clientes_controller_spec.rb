require_relative '../rails_helper'

describe ClientesController do
  include ::ControllersHelper

  let(:fabrica_de_objetos){ FabricaDeObjetos.new }

  let(:parametros_del_abogado) {
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

  let(:abogado){ login_abogado(parametros_del_abogado) }

  let(:ad_hoc){ AdHocAplicacion.new }

  let(:asertar){ Asertar.new }

  context 'Creacion de clientes' do
    subject { post :create, params: parametros }

    context 'En la correcta creacion de un cliente' do
      let(:parametros) {
        {cliente: fabrica_de_objetos.parametros_para_cliente(abogado.id,
                                                             fabrica_de_objetos.un_nombre_para_un_cliente,
                                                             fabrica_de_objetos.un_apellido_para_un_cliente)} }

      it 'con un nombre y un  apellido el cliente se crea satisfactoriamente' do
        subject

        cliente = Cliente.all.first

        asertar_que_la_respuesta_tiene_estado(response, :ok)
        asertar_que_se_muestra_un_mensaje_de_confirmacion(ad_hoc.mensaje_de_confirmacion_para_la_correcta_creacion_de_un_cliente)
        asertar_que_los_datos_del_cliente_son_correctos(cliente)
      end

      it 'pertenece a un abogado' do
        otros_parametros = fabrica_de_objetos.parametros_para_un_abogado(fabrica_de_objetos.otro_mail_para_un_abogado,
                                                                         fabrica_de_objetos.una_contrasenia,
                                                                         fabrica_de_objetos.otro_nombre_para_un_abogado,
                                                                         fabrica_de_objetos.otro_apellido_para_un_abogado,
                                                                         Sexo::FEMENINO,
                                                                         fabrica_de_objetos.otra_matricula,
                                                                         fabrica_de_objetos.un_colegio,
                                                                         fabrica_de_objetos.otro_cuit,
                                                                         fabrica_de_objetos.un_domicilio_procesal,
                                                                         fabrica_de_objetos.otro_domicilio_electronico)
        otro_abogado = crear_cuenta_para_abogado(otros_parametros)

        subject

        cliente = Cliente.all.first
        expect(cliente.pertenece_a? abogado).to be true
        expect(cliente.pertenece_a? otro_abogado).to be false
      end

      context 'Con campos opcionales' do
        let(:parametros) {
          {cliente: fabrica_de_objetos.parametros_para_cliente(abogado.id,
                                                               fabrica_de_objetos.un_nombre_para_un_cliente,
                                                               fabrica_de_objetos.un_apellido_para_un_cliente,
                                                               fabrica_de_objetos.un_telefono_para_un_cliente,
                                                               fabrica_de_objetos.un_mail_para_un_cliente,
                                                               EstadoCivil::SOLTERO,
                                                               fabrica_de_objetos.una_empresa_para_un_cliente,
                                                               true)} }

        it 'con nombre, apellido, telefono, email, estado civil, empresa y si esta en blanco se crea satisfactoriamente' do
          subject

          cliente = Cliente.all.first

          asertar_que_todos_los_datos_del_cliente_son_correctos(cliente)
          asertar_que_la_respuesta_tiene_estado(response, :ok)
          asertar_que_se_muestra_un_mensaje_de_confirmacion(ad_hoc.mensaje_de_confirmacion_para_la_correcta_creacion_de_un_cliente)
        end
      end

      context 'Con una direccion' do
        let(:parametros) { {
            cliente: {
              abogado_id: abogado.id,
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
          expect(to eq ad_hoc.mensaje_de_confirmacion_para_la_correcta_creacion_de_un_cliente)
        end
      end

      context 'Con hijos' do
        let(:parametros) { {
            cliente: {
                abogado_id: abogado.id,
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
            expect(to eq ad_hoc.mensaje_de_confirmacion_para_la_correcta_creacion_de_un_cliente)
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
            expect(to eq ad_hoc.mensaje_de_confirmacion_para_la_correcta_creacion_de_un_cliente)
          end
        end
      end
    end

    context 'En la incorrecta creaasertar_que_el_template_escion de un cliente' do
      let (:parametros){ {cliente: fabrica_de_objetos.parametros_para_cliente(abogado.id, nil, nil)} }

      it 'sin nombre y apellido no puede ser creado' do
        subject

        asertar_que_se_muestra_un_mensaje_de_error(ad_hoc.mensaje_de_error_para_nombre_y_apellido_vacios)
        asertar_que_la_respuesta_tiene_estado(response, :ok)
      end
    end
  end

  context 'Busqueda de clientes' do

    before(:each) do
      fabrica_de_objetos.crear_un_cliente(abogado.id, fabrica_de_objetos.un_nombre_para_un_cliente, fabrica_de_objetos.un_apellido_para_un_cliente)
    end

    context 'Cuando el cliente buscado existe' do

      context 'Cuando se busca por nombre' do

        subject { get :index, params: { query: fabrica_de_objetos.un_nombre_para_un_cliente} }

        it 'te redirecciona a la vista del cliente' do
          subject

          asertar_que_el_template_es(:show)
          asertar_que_la_respuesta_tiene_estado(response, :ok)
        end
      end

      context 'Cuando se busca por apellido' do

        subject { get :index, params: { query: fabrica_de_objetos.un_apellido_para_un_cliente} }

        it 'te redirecciona a la vista del cliente' do
          subject

          asertar_que_el_template_es(:show)
          asertar_que_la_respuesta_tiene_estado(response, :ok)
        end
      end

      context 'Cuando se busca por una letra' do

        subject { get :index, params: { query: fabrica_de_objetos.un_nombre_para_un_abogado.chars.last} }

        it 'te redirecciona a la vista del cliente' do
          subject

          asertar_que_el_template_es(:show)
          asertar_que_la_respuesta_tiene_estado(response, :ok)
        end
      end
    end

    context 'Cuando el cliente buscado no existe' do

      subject { get :index, query: fabrica_de_objetos.otro_nombre_para_un_cliente }

      it 'devuelve un mensaje de error' do
        subject

        asertar_que_se_muestra_un_mensaje_de_error(ad_hoc.mensaje_de_error_para_busqueda_de_cliente_fallida(fabrica_de_objetos.otro_nombre_para_un_cliente))
        asertar_que_el_template_es(:new)
        asertar_que_la_respuesta_tiene_estado(response, :ok)
      end
    end
  end

  let(:cliente){ fabrica_de_objetos.crear_un_cliente(abogado.id, fabrica_de_objetos.un_nombre_para_un_cliente,
                                                     fabrica_de_objetos.un_apellido_para_un_cliente) }

  context 'Edicion de clientes' do

    context 'En la correcta edicion de un cliente' do

      subject { put :update, id: cliente.id, cliente: {nombre: fabrica_de_objetos.otro_nombre_para_un_cliente,
                                                       apellido: fabrica_de_objetos.otro_apellido_para_un_cliente}}

      it 'se le puede cambiar el nombre y el apellido' do
        subject

        cliente.reload

        expect(cliente.nombre).to eq fabrica_de_objetos.otro_nombre_para_un_cliente
        expect(cliente.apellido).to eq fabrica_de_objetos.otro_apellido_para_un_cliente
        asertar_que_la_respuesta_tiene_estado(response, :ok)
        asertar_que_se_muestra_un_mensaje_de_confirmacion(ad_hoc.mensaje_de_confirmacion_para_la_correcta_edicion_de_un_cliente)
      end
    end

    context 'En la incorrecta edicion del cliente' do
      subject { put :update, id: cliente.id, cliente: {nombre: nil, apellido: nil}}

      it 'no se puede poner un nombre o apellido vacio' do
        subject

        cliente.reload

        expect(cliente.nombre).to eq fabrica_de_objetos.un_nombre_para_un_cliente
        expect(cliente.apellido).to eq fabrica_de_objetos.un_apellido_para_un_cliente
        asertar_que_se_muestra_un_mensaje_de_error(ad_hoc.mensaje_de_error_para_nombre_y_apellido_vacios)
        asertar_que_la_respuesta_tiene_estado(response, :ok)
      end
    end
  end

  context 'Borrado de clientes' do
    subject { delete :destroy, id: cliente.id }

    it 'se puede eliminar un cliente' do
      subject

      expect(Cliente.all.count).to eq 0
      asertar_que_se_muestra_un_mensaje_de_confirmacion(ad_hoc.mensaje_de_confirmacion_para_correcta_eliminacion_de_un_cliente)
      asertar_que_la_respuesta_tiene_estado(response, :ok)
    end
  end

  def asertar_que_todos_los_datos_del_cliente_son_correctos(cliente)
    expect(cliente.telefono).to eq fabrica_de_objetos.un_telefono_para_un_cliente
    expect(cliente.correo_electronico).to eq fabrica_de_objetos.un_mail_para_un_cliente
    expect(cliente.estado_civil).to eq EstadoCivil::SOLTERO
    expect(cliente.empresa).to eq fabrica_de_objetos.una_empresa_para_un_cliente
    expect(cliente.esta_en_blanco).to eq true
  end

end
