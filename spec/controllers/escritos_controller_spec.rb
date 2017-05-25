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
end
