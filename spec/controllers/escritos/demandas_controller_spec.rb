require 'rails_helper'

describe DemandasController, type: :controller do
  include ::ControllersHelper

  let(:fabrica_de_objetos){ FabricaDeObjetos.new }

  let(:parametros) { fabrica_de_objetos.parametros_para_un_abogado(fabrica_de_objetos.un_mail_para_un_abogado,
                                                                   fabrica_de_objetos.una_contrasenia,
                                                                   fabrica_de_objetos.un_nombre_para_un_abogado,
                                                                   fabrica_de_objetos.un_apellido_para_un_abogado,
                                                                   Sexo::MASCULINO,
                                                                   fabrica_de_objetos.una_matricula,
                                                                   fabrica_de_objetos.un_colegio,
                                                                   fabrica_de_objetos.un_cuit,
                                                                   fabrica_de_objetos.un_domicilio_procesal,
                                                                   fabrica_de_objetos.un_domicilio_electronico) }

  let(:abogado){ abogado_logeado(parametros) }

  let(:cliente){ fabrica_de_objetos.crear_cliente(abogado.id) }

  let(:expediente){ fabrica_de_objetos.crear_expediente(cliente.id) }

  let(:ad_hoc){ AdHocEscritos.new }

  context 'En la creacion de una demanda' do
    let(:otros_parametros) {
      fabrica_de_objetos.parametros_para_un_abogado(fabrica_de_objetos.otro_mail_para_un_abogado,
                                                    fabrica_de_objetos.una_contrasenia,
                                                    fabrica_de_objetos.otro_nombre_para_un_abogado,
                                                    fabrica_de_objetos.otro_apellido_para_un_abogado,
                                                    Sexo::MASCULINO,
                                                    fabrica_de_objetos.otra_matricula,
                                                    fabrica_de_objetos.un_colegio,
                                                    fabrica_de_objetos.otro_cuit,
                                                    fabrica_de_objetos.un_domicilio_procesal,
                                                    fabrica_de_objetos.otro_domicilio_electronico)
    }

    let(:otro_abogado) { crear_cuenta_para_abogado(otros_parametros) }

    subject { post :create, params: {demanda: {cuerpo: 'un cuerpo', titulo: 'un titulo'}, expediente_id: expediente.id} }

    context 'Cuando es correcta' do
      subject { get :new, params: {expediente_id: expediente.id} }

      it 'se obtiene un escrito con encabezado para Demanda' do
        subject

        expect(@controller.escrito).to_not be nil
        expect(@controller.escrito.cuerpo).to be nil
        expect(@controller.escrito.encabezado(abogado, expediente, cliente)).to eq fabrica_de_objetos.encabezado_para_demanda(abogado, expediente, cliente).valor
      end
    end

    context 'Cuando es incorrecta' do
      subject { post :create, params: {demanda: {cuerpo: '', titulo: ''}, expediente_id: expediente.id} }

      it 'el cuerpo no puede ser vacio' do
        subject

        expect(flash[:error]).to include "Cuerpo #{Demanda.mensaje_de_error_para_campo_vacio}"
        expect(response).to have_http_status(:ok)
        asertar_que_el_template_es(:new)
      end
    end
  end
end
