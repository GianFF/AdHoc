require_relative '../rails_helper'

def asertar_que_la_respuesta_tiene_estado(un_estado)
  expect(response).to have_http_status(un_estado)
end

def asertar_que_se_muestra_un_mensaje_de_confirmacion(un_mensaje)
  expect(flash[:success]).to eq un_mensaje
end

def asertar_que_el_expediente_fue_correctamente_creado()
  un_expediente = Expediente.first

  expect(un_expediente.actor).to eq "#{@cliente.nombre} #{@cliente.apellido}"
  expect(un_expediente.demandado).to eq 'Maria Perez'
  expect(un_expediente.materia).to eq 'Daños y Perjuicios'
end

def asertar_que_se_muestra_un_mensaje_de_error(un_mensaje)
  expect(flash[:error]).to eq un_mensaje
end

def asertar_que_el_expediente_no_fue_creado()
  un_expediente = Expediente.first

  expect(un_expediente).to be nil
end

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

def asertar_que_un_expediente_pertenece_a_un_abogado(otro_abogado)
  un_expediente = Expediente.first
  expect(un_expediente.pertenece_a? @abogado).to be true
  expect(un_expediente.pertenece_a? otro_abogado).to be false
end

describe ExpedientesController do

  before(:each) do
    @abogado = login_abogado
    @cliente = Cliente.create!(nombre: 'Foo', apellido: 'Bar', abogado_id: @abogado.id)
  end

  subject { post :create, params: {
      expediente: {
          actor: "#{@cliente.nombre} #{@cliente.apellido}",
          demandado: 'Maria Perez',
          materia: 'Daños y Perjuicios',
          cliente: @cliente.id
      }
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

    asertar_que_un_expediente_pertenece_a_un_abogado(otro_abogado)
  end

  context 'En la correcta creacion de un Expediente' do
    subject { post :create, params: {
        expediente: {
            actor: "#{@cliente.nombre} #{@cliente.apellido}",
            demandado: 'Maria Perez',
            materia: 'Daños y Perjuicios',
            cliente: @cliente.id
        }
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

    let(:parametros) {{ expediente: { demandado: 'Maria Perez', materia: 'Daños y Perjuicios', cliente: @cliente.id} }}

    it 'un expediente no se puede crear sin actor' do
      subject

      asertar_que_la_respuesta_tiene_estado(:ok)
      assert_template :new
      asertar_que_se_muestra_un_mensaje_de_error('El Actor, Demandado, y Materia no pueden ser vacios')
      asertar_que_el_expediente_no_fue_creado
    end

    let(:parametros) {{ expediente: {
        actor: "#{@cliente.nombre} #{@cliente.apellido}",
        materia: 'Daños y Perjuicios',
        cliente: @cliente.id}
      }
    }

    it 'un expediente no se puede crear sin demandado' do
      subject

      asertar_que_la_respuesta_tiene_estado(:ok)
      assert_template :new
      asertar_que_se_muestra_un_mensaje_de_error('El Actor, Demandado, y Materia no pueden ser vacios')
      asertar_que_el_expediente_no_fue_creado
    end

    let(:parametros) {{ expediente: {
        actor: "#{@cliente.nombre} #{@cliente.apellido}",
        demandado: 'Maria Perez',
        cliente: @cliente.id}
      }
    }

    it 'un expediente no se puede crear sin materia' do
      subject

      asertar_que_la_respuesta_tiene_estado(:ok)
      assert_template :new
      asertar_que_se_muestra_un_mensaje_de_error('El Actor, Demandado, y Materia no pueden ser vacios')
      asertar_que_el_expediente_no_fue_creado
    end
  end
end