require 'rails_helper'

describe DemandasController, type: :controller do
  include ::ControllersHelper

  let(:fabrica_de_objetos){ FabricaDeObjetos.new }

  let(:parametros) { fabrica_de_objetos.unos_parametros_para_un_abogado }

  let(:abogado){ login_abogado(parametros) }

  let(:cliente){ fabrica_de_objetos.crear_cliente(abogado.id) }

  let(:expediente){ fabrica_de_objetos.un_expediente_para(cliente.id) }

  let(:ad_hoc){ AdHocAplicacion.new }

  context 'En la creacion de un escrito' do
    let(:otros_parametros) { fabrica_de_objetos.otros_parametros_para_otro_abogado }

    let(:otro_abogado) { crear_cuenta_para_abogado(otros_parametros) }

    subject { post :create, params: {demanda: {cuerpo: 'un cuerpo', titulo: 'un titulo'}, expediente_id: expediente.id} }

    it 'Una escrito pertenece a un abogado' do
      subject

      un_escrito = Demanda.first

      expect(un_escrito.pertenece_a? abogado).to be true
      expect(un_escrito.pertenece_a? otro_abogado).to be false
      asertar_que_el_template_es(:show)
      asertar_que_la_respuesta_tiene_estado(response, :ok)
    end

    it 'otro abogado no puede ver los escritos de un abogado' do
      subject
      un_escrito = Demanda.first

      sign_out abogado
      login_abogado(otros_parametros)
      get :show, params: {id: un_escrito.id, expediente_id: expediente.id}

      asertar_que_se_redirecciono_a(root_path)
      asertar_que_la_respuesta_tiene_estado(response, :found)
      asertar_que_se_incluye_un_mensaje_de_error(ad_hoc.mensaje_de_error_para_escrito_invalido)
    end

    context 'Cuando es incorrecta' do
      subject { post :create, params: {demanda: {cuerpo: '', titulo: ''}, expediente_id: expediente.id} }

      it 'el titulo no puede ser vacio' do
        subject

        asertar_que_se_incluye_un_mensaje_de_error("Titulo #{Demanda.mensaje_de_error_para_campo_vacio}")
        asertar_que_la_respuesta_tiene_estado(response, :ok)
        asertar_que_el_template_es(:new)
      end
    end
  end

  context 'En la edicion de un escrito' do
    let(:demanda){fabrica_de_objetos.una_demanda_para(expediente.id)}

    subject {
      put :update,
          params: {
              id: demanda.id,
              demanda: {
                  titulo: fabrica_de_objetos.otro_titulo_de_una_demanda,
                  cuerpo: fabrica_de_objetos.otro_cuerpo_de_una_demanda
              },
              expediente_id: expediente.id,
          }
    }

    context 'Cuando es correcta' do

      it 'se puede editar un escrito' do
        subject
        demanda.reload

        expect(demanda.titulo).to eq fabrica_de_objetos.otro_titulo_de_una_demanda
        expect(demanda.cuerpo).to eq fabrica_de_objetos.otro_cuerpo_de_una_demanda
        asertar_que_el_template_es(:show)
        asertar_que_la_respuesta_tiene_estado(response, :ok)
        asertar_que_se_muestra_un_mensaje_de_confirmacion(ad_hoc.mensaje_de_confirmacion_para_la_correcta_edicion_de_un_escrito)
      end
    end

    context 'Cuando es incorrecta' do
      subject { put :update, params: {id: demanda.id, demanda: {cuerpo: '', titulo: ''}, expediente_id: expediente.id}}

      it 'el titulo no puede ser vacio' do
        subject
        demanda.reload

        expect(demanda.titulo).to eq fabrica_de_objetos.un_titulo_de_una_demanda
        expect(demanda.cuerpo).to eq fabrica_de_objetos.un_cuerpo_de_una_demanda
        asertar_que_se_incluye_un_mensaje_de_error("Titulo #{Demanda.mensaje_de_error_para_campo_vacio}")
        asertar_que_la_respuesta_tiene_estado(response, :ok)
        asertar_que_el_template_es(:show)
      end

      it 'el cuerpo no puede ser vacio' do
        subject
        demanda.reload

        expect(demanda.titulo).to eq fabrica_de_objetos.un_titulo_de_una_demanda
        expect(demanda.cuerpo).to eq fabrica_de_objetos.un_cuerpo_de_una_demanda
        asertar_que_se_incluye_un_mensaje_de_error("Cuerpo #{Demanda.mensaje_de_error_para_campo_vacio}")
        asertar_que_la_respuesta_tiene_estado(response, :ok)
        asertar_que_el_template_es(:show)
      end
    end
  end

  context 'En la eliminacion de un escrito' do
    let(:demanda){fabrica_de_objetos.una_demanda_para(expediente.id)}

    subject {
      delete :destroy,
             params: {
                 id: demanda.id,
                 expediente_id: expediente.id,
             }
    }

    it 'se puede eliminar un escrito' do
      subject

      asertar_que_se_muestra_un_mensaje_de_confirmacion(ad_hoc.mensaje_de_confirmacion_para_la_correcta_eliminacion_de_un_escrito)
      asertar_que_se_redirecciono_a(expediente_url(expediente.id))
      asertar_que_la_respuesta_tiene_estado(response, :found)
      expect(Demanda.all.count).to eq 0
    end
  end

  context 'En la presentacion de un escrito' do
    let(:demanda){fabrica_de_objetos.una_demanda_para(expediente.id)}

    subject {put :presentar, params: { id: demanda.id, expediente_id: expediente.id }}

    it 'se puede presentar un escrito' do
      subject

      asertar_que_se_muestra_un_mensaje_de_confirmacion(ad_hoc.mensaje_de_confirmacion_para_la_correcta_presentacion_de_un_escrito)
      asertar_que_el_template_es(:show)
      asertar_que_la_respuesta_tiene_estado(response, :ok)
    end

    context 'Una vez presentado el escrito' do

      it 'tiene estado presentado' do
        subject
        demanda.reload

        expect(demanda.fue_presentado?).to be true
      end

      it 'no puede seguir editandose' do
        subject

        demanda.reload
        put :update,
            params: {
                id: demanda.id,
                demanda: {
                    titulo: fabrica_de_objetos.otro_titulo_de_una_demanda,
                    cuerpo: fabrica_de_objetos.otro_cuerpo_de_una_demanda
                },
                expediente_id: expediente.id
            }

        expect(demanda.fue_presentado?).to be true
        expect(demanda.titulo).to eq fabrica_de_objetos.un_titulo_de_una_demanda
        expect(demanda.cuerpo).to eq fabrica_de_objetos.un_cuerpo_de_una_demanda
        asertar_que_se_incluye_un_mensaje_de_error(demanda.mensaje_de_error_para_escrito_presentado)
        asertar_que_la_respuesta_tiene_estado(response, :ok)
        asertar_que_el_template_es(:show)
      end
    end
  end

  context 'Clonacion de un escrito' do

    it 'se pueden buscar escritos para ser clonados' do
      escrito = fabrica_de_objetos.una_demanda_para(expediente.id)
      escrito_dao = {
          id: escrito.id,
          hasta_id: escrito.id,
          titulo: escrito.titulo,
          tipo: escrito.type,
          expediente: escrito.expediente.titulo,
          expediente_id: escrito.expediente.id,
          cliente: escrito.expediente.cliente.nombre_completo,
      }

      escritos = ad_hoc.buscar_escritos_para_clonar_en(escrito.id, abogado)

      expect(escritos.count).to be 1
      expect(escritos.first).to eq escrito_dao
    end

    it 'se puede clonar el cuerpo de un escrito en otro escrito' do
      desde_escrito = fabrica_de_objetos.una_demanda_para(expediente.id)
      hasta_escrito = fabrica_de_objetos.una_contestacion_de_demanda_para(expediente.id)

      ad_hoc.clonar_cuerpo(desde_escrito.id, hasta_escrito.id, abogado)
      hasta_escrito.reload

      expect(hasta_escrito.cuerpo).to eq desde_escrito.cuerpo
    end

    it 'no se puede clonar un escrito en otro que ya haya sido presentado' do
      desde_escrito = fabrica_de_objetos.una_demanda_para(expediente.id)
      hasta_escrito = fabrica_de_objetos.una_contestacion_de_demanda_para(expediente.id)
      ad_hoc.presentar_escrito!(hasta_escrito.id, abogado)

      expect{ad_hoc.clonar_cuerpo(desde_escrito.id, hasta_escrito.id, abogado)}.to raise_error AdHocExcepcion
    end
  end
end
