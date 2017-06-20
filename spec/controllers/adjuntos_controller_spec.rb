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

  let(:expediente){ fabrica_de_objetos.un_expediente_para(cliente.id) }

  let(:ad_hoc){ AdHocAplicacion.new }

  context 'En la creacion de un adjunto' do
    subject { post :create, params: parametros }

    context 'Cuando es correcta' do
      after(:each)do
        delete :destroy, params: {
            adjunto: {
                titulo: fabrica_de_objetos.un_titulo_para_un_adjunto,
                #TODO: esto va a traer problemas,
                # no deberia estar eliminando los adjuntos sino mas bien almacenandolos en tmp
                archivo_adjunto: fixture_file_upload(path, extension_del_adjunto)
            },
            id: 1,
            expediente_id: expediente.id
        }
      end

      let(:parametros) { {
          adjunto: {
              titulo: fabrica_de_objetos.un_titulo_para_un_adjunto,
              archivo_adjunto: fixture_file_upload(path, extension_del_adjunto),
          },
          expediente_id: expediente.id
      } }

      let(:path) { "images/#{nombre_del_adjunto}" }

      let(:extension_del_adjunto) { 'image/jpg' }

      let(:nombre_del_adjunto) { 'test.jpg' }

      it 'se sube correctamente' do
        uploader = ArchivoUploader.new
        subject

        adjuntos = Adjunto.all
        adjunto = Adjunto.first
        adjunto.reload

        expect(adjuntos.size).to eq 1
        expect(adjunto.archivo_adjunto.file.nil?).to eq false
        expect(adjunto.archivo_adjunto.url).to eq uploader.path_for(adjunto)
        expect(adjunto.archivo_adjunto.current_path).to eq uploader.complete_path_for(adjunto)
        expect(adjunto.archivo_adjunto_identifier).to eq nombre_del_adjunto
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

    context 'Cuando es incorrecta' do

      context 'cuando la extension no es una imagen o un pdf' do
        let(:parametros) { {
            adjunto: {
                titulo: fabrica_de_objetos.un_titulo_para_un_adjunto,
                archivo_adjunto: fixture_file_upload(path, extension_del_adjunto),
            },
            expediente_id: expediente.id
        } }

        let(:path) { "txts/#{nombre_del_adjunto}" }

        let(:extension_del_adjunto) { 'image/txt' }

        let(:nombre_del_adjunto) { 'test.txt' }

        it 'se muestra un mensaje de error' do
          subject

          expect(Adjunto.all.count).to eq 0
          asertar_que_se_incluye_un_mensaje_de_error('Archivo adjunto formato invalido. Sólo se admite jpg, png, jpeg o pdf')
          asertar_que_la_respuesta_tiene_estado(response, :ok)
          asertar_que_el_template_es(:new)
        end
      end

      context 'cuando no se carga un titulo' do
        let(:parametros) { {
            adjunto: {
                titulo: nil,
                archivo_adjunto: nil,
            },
            expediente_id: expediente.id
        } }

        it 'se muestra un mensaje de error' do
          subject

          expect(Adjunto.all.count).to eq 0
          asertar_que_se_incluye_un_mensaje_de_error("Titulo #{Adjunto.mensaje_de_error_para_campo_vacio}")
          asertar_que_la_respuesta_tiene_estado(response, :ok)
          asertar_que_el_template_es(:new)
        end
      end
    end
  end

  context 'En la edicion de un adjunto' do
    let(:un_adjunto) do
      fabrica_de_objetos.un_adjunto_para(expediente, fixture_file_upload('images/test.png', 'image/png'), fabrica_de_objetos.un_titulo_para_un_adjunto)
    end

    subject { put :update, params: parametros }

    context 'Cuando es correcta' do
      after(:each)do
        delete :destroy, params: parametros
      end

      let(:parametros) { {
          id: un_adjunto.id,
          adjunto: {
              titulo: fabrica_de_objetos.otro_titulo_para_un_adjunto,
              archivo_adjunto: fixture_file_upload(path, extension_del_adjunto),
          },
          expediente_id: expediente.id
      } }

      let(:path) { "images/#{nombre_del_adjunto}" }

      let(:extension_del_adjunto) { 'image/jpg' }

      let(:nombre_del_adjunto) { 'test.jpg' }

      it 'se le puede cambiar el titulo y el archivo adjunto' do
        subject
        adjunto = Adjunto.first
        adjuntos = Adjunto.all
        uploader = ArchivoUploader.new

        expect(adjuntos.size).to eq 1
        expect(adjunto.archivo_adjunto.file.nil?).to eq false
        expect(adjunto.archivo_adjunto.url).to eq uploader.path_for(adjunto)
        expect(adjunto.archivo_adjunto.current_path).to eq uploader.complete_path_for(adjunto)
        expect(adjunto.titulo).to eq fabrica_de_objetos.otro_titulo_para_un_adjunto
        expect(adjunto.archivo_adjunto_identifier).to eq nombre_del_adjunto
      end
    end

    context 'Cuando es incorrecta' do
      let(:parametros) { {
          id: un_adjunto.id,
          adjunto: {
              titulo: nil,
              archivo_adjunto: fixture_file_upload(path, extension_del_adjunto),
          },
          expediente_id: expediente.id
      } }

      let(:path) { "txts/#{nombre_del_adjunto}" }

      let(:extension_del_adjunto) { 'image/txt' }

      let(:nombre_del_adjunto) { 'test.txt' }

      it 'no se le puede poner un titulo vacio o una extension invalida' do
        subject
        adjunto = Adjunto.first
        adjuntos = Adjunto.all
        uploader = ArchivoUploader.new

        expect(adjuntos.size).to eq 1
        expect(adjunto.titulo).to eq un_adjunto.titulo
        expect(adjunto.archivo_adjunto.file.nil?).to eq false
        expect(adjunto.archivo_adjunto.url).to eq uploader.path_for(un_adjunto)
        expect(adjunto.archivo_adjunto.current_path).to eq uploader.complete_path_for(un_adjunto)
        expect(adjunto.archivo_adjunto_identifier).to eq un_adjunto.archivo_adjunto_identifier

        asertar_que_se_incluye_un_mensaje_de_error('Archivo adjunto formato invalido. Sólo se admite jpg, png, jpeg o pdf')
        asertar_que_se_incluye_un_mensaje_de_error("Titulo #{Adjunto.mensaje_de_error_para_campo_vacio}")
      end
    end
  end

  context 'Cuando se elimina un adjunto' do
    let(:extension_del_adjunto) { 'image/png' }

    let(:path) { 'images/test.png' }

    let(:un_adjunto) do
      fabrica_de_objetos.un_adjunto_para(expediente, fixture_file_upload(path, extension_del_adjunto), fabrica_de_objetos.un_titulo_para_un_adjunto)
    end

    let(:parametros) { {
        id: un_adjunto.id,
        adjunto: {
            titulo: fabrica_de_objetos.un_titulo_para_un_adjunto,
            archivo_adjunto: fixture_file_upload(path, extension_del_adjunto),
        },
        expediente_id: expediente.id
    } }

    subject { delete :destroy, params: parametros }

    it 'el archivo adjunto tambien es eliminado' do
      subject
      adjuntos = Adjunto.all

      expect(adjuntos.size).to eq 0
    end
  end
end
