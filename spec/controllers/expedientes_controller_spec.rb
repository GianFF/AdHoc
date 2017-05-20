require_relative '../rails_helper'
require_relative '../helpers/asertar'
require_relative '../fabrica_de_objetos'

def login_abogado(email, contrasenia, nombre, apellido, sexo)
  abogado = crear_cuenta_para_abogado(email, contrasenia, nombre, apellido, sexo)
  sign_in abogado
  abogado
end

def crear_cuenta_para_abogado(email, contrasenia, nombre, apellido, sexo)
  abogado = Abogado.create!(email: email, password: contrasenia, nombre: nombre, apellido: apellido, sexo: sexo)
  #abogado.confirm
  abogado
end

def asertar_que_la_respuesta_tiene_estado(un_estado)
  expect(response).to have_http_status(un_estado)
end

def asertar_que_se_muestra_un_mensaje_de_confirmacion(un_mensaje)
  expect(flash[:success]).to eq un_mensaje
end

def asertar_que_se_muestra_un_mensaje_de_error(un_mensaje)
  expect(flash[:error]).to eq un_mensaje
end

def asertar_que_el_expediente_fue_correctamente_creado
  un_expediente = Expediente.first

  expect(un_expediente.actor).to eq "#{cliente.nombre} #{cliente.apellido}"
  expect(un_expediente.demandado).to eq fabrica_de_objetos.un_demandado
  expect(un_expediente.materia).to eq fabrica_de_objetos.una_materia
end

def asertar_que_el_expediente_no_fue_creado
  un_expediente = Expediente.first

  expect(un_expediente).to be nil
end

def asertar_que_el_expediente_no_fue_numerado
  expect(expediente.ha_sido_numerado?).to be nil
end

def asertar_que_el_expediente_fue_numerado
  expect(expediente.ha_sido_numerado?).to be true
end

def asertar_que_un_expediente_no_pertenece_a(otro_abogado)
  un_expediente = Expediente.first
  expect(un_expediente.pertenece_a? @abogado).to be true
  expect(un_expediente.pertenece_a? otro_abogado).to be false
end

def asertar_que_el_expediente_cambio(un_actor, un_demandado, una_materia)
  expect(expediente.actor).to eq un_actor
  expect(expediente.demandado).to eq un_demandado
  expect(expediente.materia).to eq una_materia
end

def asertar_que_el_expediente_no_cambio(un_actor, un_demandado, una_materia)
  expect(expediente.actor).to eq un_actor
  expect(expediente.demandado).to eq un_demandado
  expect(expediente.materia).to eq una_materia
end

def asertar_que_se_redirecciono_a(url)
  assert_redirected_to url
end

def asertar_que_se_elimino_el_expediente
  expect(Expediente.all.count).to eq 0
end

def numerar_expediente
  post :realizar_numeraracion,
       params: {
           id: expediente.id,
           cliente_id: cliente.id,
           expediente: {
               actor: "#{cliente.nombre_completo}",
               demandado: fabrica_de_objetos.un_demandado,
               materia: fabrica_de_objetos.una_materia,
               numero: fabrica_de_objetos.un_numero_de_expediente,
               juzgado: fabrica_de_objetos.un_juzgado,
               numero_de_juzgado: fabrica_de_objetos.un_numero_de_juzgado,
               departamento: fabrica_de_objetos.un_departamento,
               ubicacion_del_departamento: fabrica_de_objetos.una_ubicacion_de_un_departamento
           }
       }
end

def asertar_que_el_template_es(template)
  assert_template template
end

describe ExpedientesController do
  let(:fabrica_de_objetos){ FrabricaDeObjetos.new }
  let(:abogado){ login_abogado('ejemplo@mail.com', 'password', 'Foo', 'Bar', Sexo::MASCULINO) }
  let(:cliente){ fabrica_de_objetos.crear_cliente(abogado.id) }
  let(:ad_hoc){ AdHocAplicacion.new }
  let(:asertar){ Asertar.new(fabrica_de_objetos) }

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
    otro_abogado = crear_cuenta_para_abogado('otro_ejemplo@mail.com', 'password', 'Bar', 'Zaz', Sexo::FEMENINO)

    subject

    asertar.que_un_expediente_no_pertenece_a(abogado, otro_abogado)
  end

  context 'Numeracion de Expedientes' do
    subject {
      numerar_expediente
    }

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


        asertar.que_la_respuesta_tiene_estado(response, :ok)
        asertar_que_la_respuesta_tiene_estado(:ok)
        asertar_que_el_template_es(:show)
        asertar_que_se_muestra_un_mensaje_de_confirmacion(ad_hoc.mensaje_de_confirmacion_para_la_correcta_numeracion_de_un_expediente)
        expect(expediente.caratula).to eq caratula_del_expediente_numerado
      end

      it 'no puede ser numerado dos veces' do
        subject
        expediente.reload
        numerar_expediente

        asertar_que_la_respuesta_tiene_estado(:ok)
        assert_template :numerar
        asertar_que_se_muestra_un_mensaje_de_error(expediente.mensaje_de_error_para_expediente_numerado)
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
        
        asertar_que_la_respuesta_tiene_estado(:ok)
        assert_template :numerar
        asertar_que_se_muestra_un_mensaje_de_error(expediente.mensaje_de_error_para_datos_faltantes_en_la_numeracion)
        asertar_que_el_expediente_no_fue_numerado
      end
    end
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

        asertar_que_la_respuesta_tiene_estado(:ok)
        asertar_que_el_template_es(:show)
        asertar_que_se_muestra_un_mensaje_de_confirmacion('Expediente creado satisfactoriamente')
        asertar_que_el_expediente_fue_correctamente_creado
      end
    end

    context 'En la incorrecta creacion de un Expediente' do
      subject {post :create, params: parametros}

      let(:parametros) {{
          expediente: {
              demandado: fabrica_de_objetos.un_demandado,
              materia: fabrica_de_objetos.una_materia
          },
          cliente_id: cliente.id
      }}

      it 'un expediente no se puede crear sin actor' do
        subject

        asertar_que_la_respuesta_tiene_estado(:ok)
        assert_template :new
        asertar_que_se_muestra_un_mensaje_de_error('El Actor, Demandado, y Materia no pueden ser vacios')
        asertar_que_el_expediente_no_fue_creado
      end

      let(:parametros) {{
          expediente: {
              actor: "#{cliente.nombre} #{cliente.apellido}",
              materia: fabrica_de_objetos.una_materia
          },
          cliente_id: cliente.id
      }}

      it 'un expediente no se puede crear sin demandado' do
        subject

        asertar_que_la_respuesta_tiene_estado(:ok)
        assert_template :new
        asertar_que_se_muestra_un_mensaje_de_error('El Actor, Demandado, y Materia no pueden ser vacios')
        asertar_que_el_expediente_no_fue_creado
      end

      let(:parametros) {{
          expediente: {
              actor: "#{cliente.nombre} #{cliente.apellido}",
              demandado: 'Maria Perez'
          },
          cliente_id: cliente.id
      }}

      it 'un expediente no se puede crear sin materia' do
        subject

        asertar_que_la_respuesta_tiene_estado(:ok)
        assert_template :new
        asertar_que_se_muestra_un_mensaje_de_error('El Actor, Demandado, y Materia no pueden ser vacios')
        asertar_que_el_expediente_no_fue_creado
      end
    end
  end

  context 'Edicion de Expedientes' do
    let(:expediente) {Expediente.create!(actor: "#{cliente.nombre_completo}",
                                         demandado: 'Maria Perez',
                                         materia: fabrica_de_objetos.una_materia,
                                         cliente_id: cliente.id)}

    context 'En la correcta edicion de un Expediente' do

      subject {
        put :update,
            params: {
                id: expediente.id,
                expediente: {
                    actor: "Otro Actor",
                    demandado: 'Otro Demandado',
                    materia: 'Otra Materia'
                },
                cliente_id: cliente.id,
            }
      }

      it 'se le puede cambiar el actor, demandado y materia' do
        subject

        expediente.reload

        asertar_que_el_expediente_cambio('Otro Actor', 'Otro Demandado', 'Otra Materia')
        asertar_que_se_muestra_un_mensaje_de_confirmacion(@ad_hoc.mensaje_de_confirmacion_para_la_correcta_edicion_de_un_expediente)
        asertar_que_la_respuesta_tiene_estado(:ok)
      end
    end

    context 'En la incorrecta edicion de un Expediente' do

      subject {
        put :update,
            params: {
                id: expediente.id,
                expediente: {
                    actor: "",
                    demandado: 'Otro Demandado',
                    materia: 'Otra Materia'
                },
                cliente_id: cliente.id,
            }
      }

      it 'el actor no puede estar vacio' do
        subject

        expediente.reload

        asertar_que_el_expediente_no_cambio("#{cliente.nombre_completo}", 'Maria Perez', fabrica_de_objetos.una_materia)
        asertar_que_se_muestra_un_mensaje_de_error(@ad_hoc.mensaje_de_error_para_expediente_invalido)
        asertar_que_la_respuesta_tiene_estado(:bad_request)
      end

      subject {
        put :update,
            params: {
                id: expediente.id,
                expediente: {
                    actor: "#{cliente.nombre_completo}",
                    demandado: '',
                    materia: 'Otra Materia'
                },
                cliente_id: cliente.id,
            }
      }

      it 'el demandado no puede estar vacio' do
        subject

        expediente.reload

        asertar_que_el_expediente_no_cambio("#{cliente.nombre_completo}", 'Maria Perez', fabrica_de_objetos.una_materia)
        asertar_que_se_muestra_un_mensaje_de_error(@ad_hoc.mensaje_de_error_para_expediente_invalido)
        asertar_que_la_respuesta_tiene_estado(:bad_request)
      end

      subject {
        put :update,
            params: {
                id: expediente.id,
                expediente: {
                    actor: "#{cliente.nombre_completo}",
                    demandado: 'Otro Demandado',
                    materia: ''
                },
                cliente_id: cliente.id,
            }
      }

      it 'la materia no puede estar vacia' do
        subject

        expediente.reload

        asertar_que_el_expediente_no_cambio("#{cliente.nombre_completo}", 'Maria Perez', fabrica_de_objetos.una_materia)
        asertar_que_se_muestra_un_mensaje_de_error(@ad_hoc.mensaje_de_error_para_expediente_invalido)
        asertar_que_la_respuesta_tiene_estado(:bad_request)
      end
    end

  end

  context 'Borrado de Expedientes' do
    let(:expediente) {Expediente.create!(actor: "#{cliente.nombre_completo}",
                                         demandado: 'Maria Perez',
                                         materia: fabrica_de_objetos.una_materia,
                                         cliente_id: cliente.id)}

    subject { delete :destroy, params: {
        id: expediente.id,
        cliente_id: cliente.id,
    }}

    it 'se puede eliminar un expediente' do
      subject

      asertar_que_se_muestra_un_mensaje_de_confirmacion(@ad_hoc.mensaje_de_confirmacion_para_la_correcta_eliminacion_de_un_expediente)
      asertar_que_se_elimino_el_expediente
      asertar_que_la_respuesta_tiene_estado(:found)
      asertar_que_se_redirecciono_a(cliente_url(cliente.id))
    end
  end
end
