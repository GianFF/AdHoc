require_relative '../rails_helper'

describe ExpedientesController do
  include ::ControllersHelper
  include ::ExpedientesHelper

  let(:fabrica_de_objetos){ FabricaDeObjetos.new }

  let(:parametros_del_abogado) { fabrica_de_objetos.parametros_para_un_abogado(fabrica_de_objetos.un_mail_para_un_abogado,
                                                                   fabrica_de_objetos.una_contrasenia,
                                                                   fabrica_de_objetos.un_nombre_para_un_abogado,
                                                                   fabrica_de_objetos.un_apellido_para_un_abogado,
                                                                   Sexo::MASCULINO,
                                                                   fabrica_de_objetos.una_matricula,
                                                                   fabrica_de_objetos.un_colegio,
                                                                   fabrica_de_objetos.un_cuit,
                                                                   fabrica_de_objetos.un_domicilio_procesal,
                                                                   fabrica_de_objetos.un_domicilio_electronico) }

  let(:abogado){ login_abogado(parametros_del_abogado) }

  let(:cliente){ fabrica_de_objetos.crear_cliente(abogado.id) }

  let(:ad_hoc){ AdHocAplicacion.new }

  subject { post :create, params: {
      expediente: {
          actor: "#{cliente.nombre_completo}",
          demandado: fabrica_de_objetos.un_demandado,
          materia: fabrica_de_objetos.una_materia
      },
      cliente_id: cliente.id
    }
  }

  it 'un expediente pertenece a un cliente' do
    subject

    un_expediente = Expediente.first

    expect(un_expediente.actor).to eq "#{cliente.nombre_completo}"
  end

  it 'un abogado no puede ver los expedientes de otro abogado' do
    otros_parametros = fabrica_de_objetos.parametros_para_un_abogado(fabrica_de_objetos.otro_mail_para_un_abogado,
                                                                     fabrica_de_objetos.una_contrasenia,
                                                                     fabrica_de_objetos.otro_nombre_para_un_abogado,
                                                                     fabrica_de_objetos.otro_apellido_para_un_abogado,
                                                                     Sexo::MASCULINO,
                                                                     fabrica_de_objetos.otra_matricula,
                                                                     fabrica_de_objetos.un_colegio,
                                                                     fabrica_de_objetos.otro_cuit,
                                                                     fabrica_de_objetos.un_domicilio_procesal,
                                                                     fabrica_de_objetos.otro_domicilio_electronico)
    otro_abogado = crear_cuenta_para_abogado(otros_parametros)

    subject

    asertar_que_un_expediente_no_pertenece_a(otro_abogado)
  end

  context 'Creacion de Expedientes' do

    context 'En la correcta creacion de un Expediente' do
      subject { post :create, params: {
          expediente: {
              actor: "#{cliente.nombre_completo}",
              demandado: fabrica_de_objetos.un_demandado,
              materia: fabrica_de_objetos.una_materia
          },
          cliente_id: cliente.id
        }
      }

      it 'se compone de actor, demandado y materia' do
        subject

        asertar_que_la_respuesta_tiene_estado(response, :ok)
        asertar_que_el_template_es(:show)
        asertar_que_se_muestra_un_mensaje_de_confirmacion(ad_hoc.mensaje_de_confirmacion_para_la_correcta_creacion_de_un_expediente)
        asertar_que_el_expediente_fue_correctamente_creado
      end
    end

    context 'En la incorrecta creacion de un Expediente' do
      subject {post :create, params: parametros}

      context 'Sin Actor' do

        let(:parametros) {{
            expediente: {
                demandado: fabrica_de_objetos.un_demandado,
                materia: fabrica_de_objetos.una_materia
            },
            cliente_id: cliente.id
        }}

        it 'no se puede crear' do
          subject

          asertar_que_la_respuesta_tiene_estado(response, :ok)
          assert_template :new
          asertar_que_se_incluye_un_mensaje_de_error("Actor #{Expediente.mensaje_de_error_para_campo_vacio}")
          asertar_que_el_expediente_no_fue_creado
        end
      end

      context 'Sin Demandado' do

        let(:parametros) {{
            expediente: {
                actor: "#{cliente.nombre} #{cliente.apellido}",
                materia: fabrica_de_objetos.una_materia
            },
            cliente_id: cliente.id
        }}

        it 'no se puede crear' do
          subject

          asertar_que_la_respuesta_tiene_estado(response, :ok)
          assert_template :new
          asertar_que_se_incluye_un_mensaje_de_error("Demandado #{Expediente.mensaje_de_error_para_campo_vacio}")
          asertar_que_el_expediente_no_fue_creado
        end
      end

      context 'Sin Materia' do

        let(:parametros) {{
            expediente: {
                actor: "#{cliente.nombre} #{cliente.apellido}",
                demandado: fabrica_de_objetos.un_demandado
            },
            cliente_id: cliente.id
        }}

        it 'no se puede crear' do
          subject

          asertar_que_la_respuesta_tiene_estado(response, :ok)
          assert_template :new
          asertar_que_se_incluye_un_mensaje_de_error("Materia #{Expediente.mensaje_de_error_para_campo_vacio}")
          asertar_que_el_expediente_no_fue_creado
        end
      end
    end
  end

  context 'Edicion de Expedientes' do
    let(:expediente) {fabrica_de_objetos.un_expediente_para(cliente.id)}

    context 'En la correcta edicion de un Expediente' do

      subject {
        put :update,
            params: {
                id: expediente.id,
                expediente: {
                    actor: fabrica_de_objetos.otro_actor,
                    demandado: fabrica_de_objetos.otro_demandado,
                    materia: fabrica_de_objetos.otra_materia
                },
                cliente_id: cliente.id,
            }
      }

      it 'se le puede cambiar el actor, demandado y materia' do
        subject

        expediente.reload

        asertar_que_la_respuesta_tiene_estado(response, :ok)
        asertar_que_se_muestra_un_mensaje_de_confirmacion(ad_hoc.mensaje_de_confirmacion_para_la_correcta_edicion_de_un_expediente)
        asertar_que_el_expediente_cambio(fabrica_de_objetos.otro_actor, fabrica_de_objetos.otro_demandado, fabrica_de_objetos.otra_materia)
      end
    end

    context 'En la incorrecta edicion de un Expediente' do

      subject {
        put :update,
            params: {
                id: expediente.id,
                expediente: parametros_del_expediente,
                cliente_id: cliente.id,
            }
      }

      context 'Sin Actor' do
        let(:parametros_del_expediente) { {
            actor: '',
            demandado: fabrica_de_objetos.otro_demandado,
            materia: fabrica_de_objetos.otra_materia
        } }

        it 'no puede ser editado' do
          subject

          expediente.reload

          asertar_que_la_respuesta_tiene_estado(response, :bad_request)
          asertar_que_se_incluye_un_mensaje_de_error("Actor #{Expediente.mensaje_de_error_para_campo_vacio}")
          asertar_que_el_expediente_no_cambio(fabrica_de_objetos.un_actor, fabrica_de_objetos.un_demandado, fabrica_de_objetos.una_materia)
        end
      end

      context 'Sin Demandado' do

        let(:parametros_del_expediente) { {
            actor: "#{cliente.nombre_completo}",
            demandado: '',
            materia: 'Otra Materia'
        } }

        it 'no puede ser editado' do
          subject

          expediente.reload

          asertar_que_la_respuesta_tiene_estado(response, :bad_request)
          asertar_que_se_incluye_un_mensaje_de_error("Demandado #{Expediente.mensaje_de_error_para_campo_vacio}")
          asertar_que_el_expediente_no_cambio(fabrica_de_objetos.un_actor, fabrica_de_objetos.un_demandado, fabrica_de_objetos.una_materia)
        end
      end

      context 'Sin Materia' do
        let(:parametros_del_expediente) { {
            actor: "#{cliente.nombre_completo}",
            demandado: fabrica_de_objetos.otro_demandado,
            materia: ''
        } }

        it 'la materia no puede estar vacia' do
          subject

          expediente.reload

          asertar_que_la_respuesta_tiene_estado(response, :bad_request)
          asertar_que_se_incluye_un_mensaje_de_error("Materia #{Expediente.mensaje_de_error_para_campo_vacio}")
          asertar_que_el_expediente_no_cambio(fabrica_de_objetos.un_actor, fabrica_de_objetos.un_demandado, fabrica_de_objetos.una_materia)
        end
      end
    end
  end

  context 'Borrado de Expedientes' do
    let(:expediente) {Expediente.create!(actor: "#{cliente.nombre_completo}",
                                         demandado: fabrica_de_objetos.un_demandado,
                                         materia: fabrica_de_objetos.una_materia,
                                         cliente_id: cliente.id)}

    subject { delete :destroy, params: {
        id: expediente.id,
        cliente_id: cliente.id,
    }}

    it 'se puede eliminar un expediente' do
      subject

      asertar_que_se_muestra_un_mensaje_de_confirmacion(ad_hoc.mensaje_de_confirmacion_para_la_correcta_eliminacion_de_un_expediente)
      asertar_que_se_redirecciono_a(cliente_url(cliente.id))
      asertar_que_la_respuesta_tiene_estado(response, :found)
      asertar_que_se_elimino_el_expediente
    end
  end

  context 'Numeracion de Expedientes' do
    subject { numerar_expediente }

    let(:expediente) {Expediente.create!(actor: "#{cliente.nombre_completo}",
                                         demandado: fabrica_de_objetos.un_demandado,
                                         materia: fabrica_de_objetos.una_materia,
                                         cliente_id: cliente.id)}

    context 'En la correcta numeracion de un Expediente' do

      let(:caratula_del_expediente_numerado){
        fabrica_de_objetos.una_caratula_numerada(expediente, numero, anio, juzgado, numero_de_juzgado,
                                                 departamento, ubicacion_del_departamento)
      }

      let(:ubicacion_del_departamento){ fabrica_de_objetos.una_ubicacion_de_un_departamento }

      let(:departamento){ fabrica_de_objetos.un_departamento } #TODO: este dato podria ir capturandolo para guardar en una base de datos retroalimentable.

      let(:numero_de_juzgado){ fabrica_de_objetos.un_numero_de_juzgado }

      let(:juzgado){ fabrica_de_objetos.un_juzgado } #TODO: extraer a un ENUM, para ello averiguar que entidad engloba a un Juzgado o un Tribunal

      let(:anio){ fabrica_de_objetos.un_anio }

      let(:numero){ fabrica_de_objetos.un_numero_de_expediente }

      it 'puede ser numerado' do
        subject
        expediente.reload

        asertar_que_la_respuesta_tiene_estado(response, :ok)
        asertar_que_el_template_es(:show)
        asertar_que_se_muestra_un_mensaje_de_confirmacion(ad_hoc.mensaje_de_confirmacion_para_la_correcta_numeracion_de_un_expediente)
        expect(expediente.caratula).to eq caratula_del_expediente_numerado
      end

      it 'no puede ser numerado dos veces' do
        subject
        expediente.reload
        numerar_expediente

        asertar_que_la_respuesta_tiene_estado(response, :ok)
        asertar_que_el_template_es(:numerar)
        asertar_que_se_incluye_un_mensaje_de_error(expediente.mensaje_de_error_para_expediente_numerado)
        asertar_que_el_expediente_fue_numerado
      end
    end

    context 'En la incorrecta numeracion de un Expediente' do
      subject{
        post :realizar_numeraracion,
             params: {
                 id: expediente.id,
                 cliente_id: cliente.id,
                 expediente: {
                     numero: nil,
                     juzgado: nil,
                     numero_de_juzgado: nil,
                     departamento: nil,
                     ubicacion_del_departamento: nil
                 }
             }
      }
      it 'todos los campos son requeridos a la hora de numerar' do
        subject

        asertar_que_la_respuesta_tiene_estado(response, :ok)
        assert_template :numerar
        asertar_que_se_incluye_un_mensaje_de_error(expediente.mensaje_de_error_para_datos_faltantes_en_la_numeracion)
        asertar_que_el_expediente_no_fue_numerado
      end
    end
  end

  context 'Archivo de Expedientes' do
    let(:expediente) { fabrica_de_objetos.un_expediente_para(cliente.id) }

    subject { post :archivar, params: {id: expediente.id, cliente_id: cliente.id} }

    context 'Archivar Expedientes' do

      it 'un expediente que no se mando a archivar no esta archivado' do
        expect(expediente.ha_sido_archivado?).to be false
      end

      it 'un expediente que se mando a archivar esta archivado' do
        subject
        expediente.reload

        expect(expediente.ha_sido_archivado?).to be true
        asertar_que_la_respuesta_tiene_estado(response, :found)
        asertar_que_se_redirecciono_a(cliente_url(cliente.id))
        asertar_que_se_muestra_un_mensaje_de_confirmacion(ad_hoc.mensaje_de_confirmacion_para_la_correcta_edicion_de_un_expediente)
      end

      context 'No se puede editar un expediente archivado' do

        it 'no se puede editar un expediente archivado' do
          subject

          put :update, params: { id: expediente.id,
                                 expediente:
                                     { actor: fabrica_de_objetos.otro_actor,
                                       demandado: fabrica_de_objetos.otro_demandado,
                                       materia: fabrica_de_objetos.otra_materia},
                                 cliente_id: cliente.id }

          asertar_que_la_respuesta_tiene_estado(response, :found)
          asertar_que_se_incluye_un_mensaje_de_error(ad_hoc.mensaje_de_error_para_expediente_archivado)
          asertar_que_el_expediente_no_cambio(fabrica_de_objetos.un_actor, fabrica_de_objetos.un_demandado, fabrica_de_objetos.una_materia)
        end

        it 'ni sus escritos' do
          demanda = fabrica_de_objetos.crear_demanda(expediente.id)

          subject
          parametros_escrito = {
              id: demanda.id,
              titulo: fabrica_de_objetos.otro_titulo_de_una_demanda,
              cuerpo: fabrica_de_objetos.otro_cuerpo_de_una_demanda,
              expediente_id: expediente.id
          }
          expect{ad_hoc.editar_escrito!(demanda.id, parametros_escrito, abogado)}.to raise_error AdHocHackExcepcion
          asertar_que_el_escrito_no_cambio(demanda, fabrica_de_objetos.un_titulo_de_una_demanda,
                                           fabrica_de_objetos.un_cuerpo_de_una_demanda)
        end

        pending 'ni sus adjuntos' do
          fail
        end
      end

      context 'En la incorrecta archivacion de un expediente' do
        let(:otro_abogado){ login_abogado(fabrica_de_objetos.otros_parametros_para_otro_abogado) }
        let(:otro_cliente){ fabrica_de_objetos.crear_otro_cliente(otro_abogado.id) }
        let(:otro_expediente){ fabrica_de_objetos.un_expediente_para(otro_cliente.id) }

        subject { post :archivar, params: {id: otro_expediente.id, cliente_id: cliente.id} }

        it 'no se puede archivar un expediente que no corresponde a un abogado' do
          subject
          expediente.reload

          expect(expediente.ha_sido_archivado?).to be false
          asertar_que_la_respuesta_tiene_estado(response, :found)
          asertar_que_se_incluye_un_mensaje_de_error(ad_hoc.mensaje_de_error_para_expediente_inexistente)
          asertar_que_el_expediente_no_cambio(fabrica_de_objetos.un_actor, fabrica_de_objetos.un_demandado, fabrica_de_objetos.una_materia)
        end
      end
    end

    context 'Busqueda de Expedientes archivados' do

      it 'cuando un expediente se archiva se encuentra en el archivador' do
        subject
        expediente.reload
        expediente_archivado = fabrica_de_objetos.un_expediente_archivado(expediente)

        expedientes_archivados = ad_hoc.buscar_expedientes_archivados

        expect(expedientes_archivados.count).to eq 1
        expect(expedientes_archivados.first).to eq expediente_archivado
      end

      it 'la respuesta contiene el id y titulo del expediente' do
        subject
        expediente.reload

        expediente_archivado = ad_hoc.buscar_expedientes_archivados.first

        expect(expediente_archivado[:id]).to eq expediente.id
        expect(expediente_archivado[:titulo]).to eq expediente.titulo
      end

      it 'la respuesta contiene el id y nombre completo del cliente' do
        subject
        expediente.reload

        expediente_archivado = ad_hoc.buscar_expedientes_archivados.first

        expect(expediente_archivado[:cliente_id]).to eq cliente.id
        expect(expediente_archivado[:cliente_nombre]).to eq cliente.nombre_completo
      end

      it 'la respuesta contiene cada id y titulo de los escritos del expediente' do
        subject
        escrito = ad_hoc.crear_nueva_demanda!({cuerpo: 'un cuerpo', titulo: 'un titulo'}, expediente.id, abogado)
        expediente.reload

        expediente_archivado = ad_hoc.buscar_expedientes_archivados.first

        expect(expediente_archivado[:escritos].count).to eq 1
        expect(expediente_archivado[:escritos].first[:escrito_id]).to eq escrito.id
        expect(expediente_archivado[:escritos].first[:escrito_titulo]).to eq escrito.titulo
      end
    end
  end
end
