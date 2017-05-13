require_relative '../rails_helper'

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

  expect(un_expediente.actor).to eq "#{@cliente.nombre} #{@cliente.apellido}"
  expect(un_expediente.demandado).to eq 'Maria Perez'
  expect(un_expediente.materia).to eq 'Daños y Perjuicios'
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
           cliente_id: @cliente.id,
           expediente: {
               numero: 123,
               juzgado: "Juzgado Civil y Comercial",
               numero_de_juzgado: 7,
               departamento: "Departamento Judicial de Quilmes",
               ubicacion_del_departamento: "Alvear 465 piso N°1 de Quilmes"
           }
       }
end

describe ExpedientesController do

  before(:each) do
    @abogado = login_abogado
    @cliente = Cliente.create!(nombre: 'Foo', apellido: 'Bar', abogado_id: @abogado.id)
    @ad_hoc = AdHocAplicacion.new
  end

  subject { post :create, params: {
      expediente: {
          actor: "#{@cliente.nombre_completo}",
          demandado: 'Maria Perez',
          materia: 'Daños y Perjuicios'
      },
      cliente_id: @cliente.id
    }
  }

  it 'un expediente pertenece a un cliente' do
    subject

    un_expediente = Expediente.first

    expect(un_expediente.actor).to eq "#{@cliente.nombre} #{@cliente.apellido}"
  end

  it 'un abogado no puede ver los expedientes de otro abogado' do
    otro_abogado = crear_cuenta_para_abogado

    subject

    asertar_que_un_expediente_no_pertenece_a(otro_abogado)
  end

  context 'Numeracion de Expedientes' do
    subject {
      numerar_expediente
    }

    let(:expediente) {Expediente.create!(actor: "#{@cliente.nombre_completo}",
                                         demandado: 'Maria Perez',
                                         materia: 'Daños y Perjuicios',
                                         cliente_id: @cliente.id)}

    context 'En la correcta numeracion de un Expediente' do

      let(:caratula_del_expediente_numerado){ "#{expediente.titulo} s/ #{expediente.materia} (#{numero}/#{anio}) en tramite ante el #{juzgado} N°#{numero_de_juzgado} del #{departamento} sito en #{ubicacion_del_departamento}"}

      let(:ubicacion_del_departamento){ "Alvear 465 piso N°1 de Quilmes"}

      let(:departamento){ "Departamento Judicial de Quilmes"} #TODO: este dato podria ir capturandolo para guardar en una base de datos retroalimentable.

      let(:numero_de_juzgado){ 7}

      let(:juzgado){ "Juzgado Civil y Comercial"} #TODO: extraer a un ENUM, para ello averiguar que entidad engloba a un Juzgado o un Tribunal

      let(:anio){ DateTime.now.year % 100}

      let(:numero){ 123}

      it 'puede ser numerado' do
        subject
        expediente.reload

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
                 cliente_id: @cliente.id,
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
              actor: "#{@cliente.nombre_completo}",
              demandado: 'Maria Perez',
              materia: 'Daños y Perjuicios'
          },
          cliente_id: @cliente.id
        }
      }

      it 'se compone de actor, demandado y materia' do
        subject

        asertar_que_la_respuesta_tiene_estado(:ok)
        assert_template :show
        asertar_que_se_muestra_un_mensaje_de_confirmacion('Expediente creado satisfactoriamente')
        asertar_que_el_expediente_fue_correctamente_creado
      end
    end

    context 'En la incorrecta creacion de un Expediente' do
      subject {post :create, params: parametros}

      let(:parametros) {{
          expediente: {
              demandado: 'Maria Perez',
              materia: 'Daños y Perjuicios'
          },
          cliente_id: @cliente.id
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
              actor: "#{@cliente.nombre} #{@cliente.apellido}",
              materia: 'Daños y Perjuicios'
          },
          cliente_id: @cliente.id
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
              actor: "#{@cliente.nombre} #{@cliente.apellido}",
              demandado: 'Maria Perez'
          },
          cliente_id: @cliente.id
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
    let(:expediente) {Expediente.create!(actor: "#{@cliente.nombre_completo}",
                                         demandado: 'Maria Perez',
                                         materia: 'Daños y Perjuicios',
                                         cliente_id: @cliente.id)}

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
                cliente_id: @cliente.id,
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
                cliente_id: @cliente.id,
            }
      }

      it 'el actor no puede estar vacio' do
        subject

        expediente.reload

        asertar_que_el_expediente_no_cambio("#{@cliente.nombre_completo}", 'Maria Perez', 'Daños y Perjuicios')
        asertar_que_se_muestra_un_mensaje_de_error(@ad_hoc.mensaje_de_error_para_expediente_invalido)
        asertar_que_la_respuesta_tiene_estado(:bad_request)
      end

      subject {
        put :update,
            params: {
                id: expediente.id,
                expediente: {
                    actor: "#{@cliente.nombre_completo}",
                    demandado: '',
                    materia: 'Otra Materia'
                },
                cliente_id: @cliente.id,
            }
      }

      it 'el demandado no puede estar vacio' do
        subject

        expediente.reload

        asertar_que_el_expediente_no_cambio("#{@cliente.nombre_completo}", 'Maria Perez', 'Daños y Perjuicios')
        asertar_que_se_muestra_un_mensaje_de_error(@ad_hoc.mensaje_de_error_para_expediente_invalido)
        asertar_que_la_respuesta_tiene_estado(:bad_request)
      end

      subject {
        put :update,
            params: {
                id: expediente.id,
                expediente: {
                    actor: "#{@cliente.nombre_completo}",
                    demandado: 'Otro Demandado',
                    materia: ''
                },
                cliente_id: @cliente.id,
            }
      }

      it 'la materia no puede estar vacia' do
        subject

        expediente.reload

        asertar_que_el_expediente_no_cambio("#{@cliente.nombre_completo}", 'Maria Perez', 'Daños y Perjuicios')
        asertar_que_se_muestra_un_mensaje_de_error(@ad_hoc.mensaje_de_error_para_expediente_invalido)
        asertar_que_la_respuesta_tiene_estado(:bad_request)
      end
    end

  end

  context 'Borrado de Expedientes' do
    let(:expediente) {Expediente.create!(actor: "#{@cliente.nombre_completo}",
                                         demandado: 'Maria Perez',
                                         materia: 'Daños y Perjuicios',
                                         cliente_id: @cliente.id)}

    subject { delete :destroy, params: {
        id: expediente.id,
        cliente_id: @cliente.id,
    }}

    it 'se puede eliminar un expediente' do
      subject

      asertar_que_se_muestra_un_mensaje_de_confirmacion(@ad_hoc.mensaje_de_confirmacion_para_la_correcta_eliminacion_de_un_expediente)
      asertar_que_se_elimino_el_expediente
      asertar_que_la_respuesta_tiene_estado(:found)
      asertar_que_se_redirecciono_a(cliente_url(@cliente.id))
    end
  end
end
