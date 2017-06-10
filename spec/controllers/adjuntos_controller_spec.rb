require_relative '../rails_helper'

describe AdjuntosController, type: :controller do
  include ::ControllersHelper

  let(:fabrica_de_objetos){ FabricaDeObjetos.new }

  let(:parametros_de_un_abogado) {
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

  let(:parametros_de_otro_abogado) {
    fabrica_de_objetos.parametros_para_un_abogado(fabrica_de_objetos.otro_mail_para_un_abogado,
                                                  fabrica_de_objetos.una_contrasenia,
                                                  fabrica_de_objetos.otro_nombre_para_un_abogado,
                                                  fabrica_de_objetos.otro_apellido_para_un_abogado,
                                                  Sexo::FEMENINO,
                                                  fabrica_de_objetos.otra_matricula,
                                                  fabrica_de_objetos.otro_colegio,
                                                  fabrica_de_objetos.otro_cuit,
                                                  fabrica_de_objetos.otro_domicilio_procesal,
                                                  fabrica_de_objetos.otro_domicilio_electronico)
  }

  let(:abogado){ login_abogado(parametros_de_un_abogado) }

  let(:cliente){ fabrica_de_objetos.crear_cliente(abogado.id) }

  let(:expediente){ fabrica_de_objetos.crear_expediente(cliente.id) }

  let(:ad_hoc){ AdHocAplicacion.new }


  context 'En la correcta creacion de un adjunto' do
    let(:parametros) { {
        adjunto: {
            titulo: 'un titulo',
            archivo_adjunto: File.open(Rails.root.join('public', 'test_pdf.pdf')),
        },
        expediente_id: expediente.id
    } }

    subject { post :create, params: parametros }

    it 'se sube correctamente' do
      subject

      adjuntos = Adjunto.all
      adjunto = Adjunto.first
      adjunto.reload

      expect(adjuntos.size).to eq 1
      expect(adjunto.archivo.file.nil?).to eq false
      expect(adjunto.archivo.url).to eq '../../public/test_pedf.pdf'
      expect(adjunto.archivo.current_path).to eq '../../public/test_pedf.pdf'
      expect(adjunto.archivo_identifier).to eq 'test_pedf.pdf'
    end

    it 'pertenece al expediente de un cliente' do
      subject

      adjuntos = Adjunto.all
      adjunto = Adjunto.first
      adjunto.reload

      expect(adjuntos.size).to eq 1
      expect(adjunto.expediente).to eq expediente
      expect(adjunto.expediente.cliente).to eq cliente
    end

    it 'pertenece a un abogado' do
      subject

      adjuntos = Adjunto.all
      adjunto = Adjunto.first
      adjunto.reload

      expect(adjuntos.size).to eq 1
      expect(adjunto.pertenece_a?(abogado)).to eq true
    end

    it 'otro abogado no puede ver los archivos de un abogado' do
      subject
      adjunto = Adjunto.first

      sign_out(abogado)
      otro_abogado = login_abogado(parametros_de_otro_abogado)
      get :show, params: {id: adjunto.id, expediente_id: expediente.id}

      expect(adjunto.pertenece_a?(abogado)).to eq true
      expect(adjunto.pertenece_a?(otro_abogado)).to eq false
      asertar_que_se_redirecciono_a(root_path)
      asertar_que_la_respuesta_tiene_estado(response, :found)
      asertar_que_se_incluye_un_mensaje_de_error(ad_hoc.mensaje_de_error_para_adjunto_invalido)
    end
  end

  context 'En la incorrecta creacion de un adjunto' do

    context 'cuando la extension no es una imagen o un pdf' do

      it 'se muestra un mensaje de error' do

      end
    end
  end
end
