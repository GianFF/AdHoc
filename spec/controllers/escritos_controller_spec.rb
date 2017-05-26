require 'rails_helper'

describe EscritosController, type: :controller do
  include ::ControllersHelper

  let(:fabrica_de_objetos){ FabricaDeObjetos.new }

  let(:abogado){ login_abogado(fabrica_de_objetos.un_mail_para_un_abogado,
                               fabrica_de_objetos.una_contrasenia,
                               fabrica_de_objetos.un_nombre_para_un_abogado,
                               fabrica_de_objetos.un_apellido_para_un_abogado,
                               Sexo::MASCULINO) } # TODO: eliminar parametros de este metodo

  let(:cliente){ fabrica_de_objetos.crear_cliente(abogado.id) }

  let(:expediente){ fabrica_de_objetos.crear_expediente(cliente.id) }

  let(:ad_hoc){ AdHocAplicacion.new }

  context 'En la creacion de un escrito' do

    subject { get :new, params: { expediente_id: expediente.id } }

    it 'se obtiene un escrito vacio' do
      subject

      expect(@controller.escrito).to_not be nil
      expect(@controller.escrito.cuerpo).to be nil
    end
  end

  subject { post :create, params: { escrito:{ cuerpo: '' }, expediente_id: expediente.id } }

  it 'Un escrito pertenece a un abogado' do
    otro_abogado = crear_cuenta_para_abogado(fabrica_de_objetos.otro_mail_para_un_abogado,
                                             fabrica_de_objetos.una_contrasenia,
                                             fabrica_de_objetos.otro_nombre_para_un_abogado,
                                             fabrica_de_objetos.otro_apellido_para_un_abogado,
                                             Sexo::MASCULINO)
    subject

    un_escrito = Escrito.first

    expect(un_escrito.pertenece_a? abogado).to be true
    expect(un_escrito.pertenece_a? otro_abogado).to be false
    asertar_que_el_template_es(:show)
    asertar_que_la_respuesta_tiene_estado(response, :ok)
  end

  context 'En la edicion de un escrito' do
    let(:escrito){fabrica_de_objetos.crear_escrito(expediente.id)}

    subject {
      put :update,
          params: {
              id: escrito.id,
              escrito: {
                  titulo: fabrica_de_objetos.otro_titulo_de_una_demanda,
                  cuerpo: fabrica_de_objetos.otro_cuerpo_de_una_demanda
              },
              expediente_id: expediente.id,
          }
    }

    it 'se puede editar un escrito' do
      subject
      escrito.reload

      expect(escrito.titulo).to eq fabrica_de_objetos.otro_titulo_de_una_demanda
      expect(escrito.cuerpo).to eq fabrica_de_objetos.otro_cuerpo_de_una_demanda
      asertar_que_el_template_es(:show)
      asertar_que_la_respuesta_tiene_estado(response, :ok)
      asertar_que_se_muestra_un_mensaje_de_confirmacion(ad_hoc.mensaje_de_confirmacion_para_la_correcta_edicion_de_un_escrito)
    end
  end

  context 'En la eliminacion de un escrito' do
    let(:escrito){fabrica_de_objetos.crear_escrito(expediente.id)}

    subject {
      delete :destroy,
             params: {
                 id: escrito.id,
                 expediente_id: expediente.id,
             }
    }

    it 'se puede eliminar un escrito' do
      subject

      asertar_que_se_muestra_un_mensaje_de_confirmacion(ad_hoc.mensaje_de_confirmacion_para_la_correcta_eliminacion_de_un_escrito)
      asertar_que_se_redirecciono_a(expediente_url(expediente.id))
      asertar_que_la_respuesta_tiene_estado(response, :found)
      expect(Escrito.all.count).to eq 0
    end
  end
end
