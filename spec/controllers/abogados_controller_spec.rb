require_relative '../rails_helper'

def asertar_mensaje_de_error_respuesta_y_redireccion(mensaje_de_error)
  expect(flash[:error]).to include mensaje_de_error
  expect(response).to have_http_status(:found)
  asertar_que_se_redirecciono_a(root_path)
end

describe AbogadosController do
  include ::ControllersHelper
  include FactoryBot::Syntax::Methods

  before :each do
    @request.env['devise.mapping'] = Devise.mappings[:abogado]
  end

  let(:un_abogado){ abogado_logeado }

  subject { put :update, params: {id: un_abogado.id, abogado: parametros} }

  let(:parametros){ {
      nombre: 'otro nombre',
      apellido: 'otro apellido',
      matricula: 'otra matricula',
      nombre_del_colegio_de_abogados: 'otro colegio',
      cuit: 'otro cuit',
      domicilio_procesal: 'otro_domicilio_procesal',
      domicilio_electronico: 'otro_domicilio_electronico',
      email: 'otro@mail.com',
      password: 'otrapassword123',
      encrypted_password: un_abogado.password
  }}

  it 'un abogado puede editar sus datos' do
    subject

    abogado = Abogado.find(un_abogado.id)

    expect(abogado.nombre).to eq 'otro nombre'
    expect(abogado.apellido).to eq 'otro apellido'
    expect(abogado.matricula).to eq 'otra matricula'
    expect(abogado.nombre_del_colegio_de_abogados).to eq 'otro colegio'
    expect(abogado.cuit).to eq 'otro cuit'
    expect(abogado.domicilio_procesal).to eq 'otro_domicilio_procesal'
    expect(abogado.domicilio_electronico).to eq 'otro_domicilio_electronico'
    expect(abogado.email).to eq 'otro@mail.com'
    expect(response).to have_http_status(:found)
  end

  it 'un abogado puede editar su contraseña' do
    subject

    un_abogado.reload

    expect(un_abogado.valid_password? parametros[:password]).to be true
  end

  describe 'No se puede editar un abogado cuando' do

    context 'no se provee la contraseña' do
      let(:parametros){ {
          nombre: 'otro nombre'
      }}

      it 'se muestra un mensaje de error y se redirije a la pagina de inicio' do
        subject

        asertar_que_se_muestra_un_mensaje_de_error(AdHocAbogados.new.mensaje_de_error_para_contrasenia_incorrecta)
        expect(response).to have_http_status(:found)
        asertar_que_se_redirecciono_a(root_path)
      end
    end

    context 'la contraseña es incorrecta' do
      let(:parametros){ {
          nombre: 'otro nombre',
          encrypted_password: 'passwordIncorrecta'
      }}

      it 'se muestra un mensaje de error y se redirije a la pagina de inicio' do
        subject

        asertar_que_se_muestra_un_mensaje_de_error(AdHocAbogados.new.mensaje_de_error_para_contrasenia_incorrecta)
        expect(response).to have_http_status(:found)
        asertar_que_se_redirecciono_a(root_path)
      end
    end

    context 'el nombre esta en blanco' do
      let(:parametros){ {
          nombre: '',
          encrypted_password: un_abogado.password
      }}

      it 'no puede ser editado' do
        subject

        asertar_mensaje_de_error_respuesta_y_redireccion("Nombre #{Abogado.mensaje_de_error_para_campo_vacio}")
      end
    end

    context 'el apellido esta en blanco' do
      let(:parametros){ {
          apellido: '',
          encrypted_password: un_abogado.password
      }}

      it 'no puede ser editado' do
        subject

        asertar_mensaje_de_error_respuesta_y_redireccion("Apellido #{Abogado.mensaje_de_error_para_campo_vacio}")
      end
    end

    context 'el email esta en blanco' do
      let(:parametros){ {
          email: '',
          encrypted_password: un_abogado.password
      }}

      it 'no puede ser editado' do
        subject

        asertar_mensaje_de_error_respuesta_y_redireccion("Email #{Abogado.mensaje_de_error_para_campo_vacio}")
      end
    end

    context 'el email ya fue tomado' do
      let(:una_abogada) { create(:abogada) }
      let(:parametros){ {
          email: una_abogada.email,
          encrypted_password: un_abogado.password
      }}

      it 'no puede ser editado' do
        subject

        asertar_mensaje_de_error_respuesta_y_redireccion("Email #{Abogado.mensaje_de_error_para_campo_tomado}")
      end
    end

    context 'el Colegio de Abogados esta en blanco' do
      let(:parametros){ {
          nombre_del_colegio_de_abogados: '',
          encrypted_password: un_abogado.password
      }}

      it 'no puede ser editado' do
        subject

        asertar_mensaje_de_error_respuesta_y_redireccion("Nombre del colegio de abogados #{Abogado.mensaje_de_error_para_campo_vacio}")
      end
    end

    context 'la Matricula esta en blanco' do
      let(:parametros){ {
          matricula: '',
          encrypted_password: un_abogado.password
      }}

      it 'no puede ser editado' do
        subject

        asertar_mensaje_de_error_respuesta_y_redireccion("Matricula #{Abogado.mensaje_de_error_para_campo_vacio}")
      end
    end

    context 'la Matricula ya fue tomada' do
      let(:una_abogada) { create(:abogada) }

      let(:parametros){ {
          matricula: una_abogada.matricula,
          encrypted_password: un_abogado.password
      }}

      it 'no puede ser editado' do
        subject

        asertar_mensaje_de_error_respuesta_y_redireccion("Matricula #{Abogado.mensaje_de_error_para_campo_tomado}")
      end
    end

    context 'el cuit esta en blanco' do
      let(:parametros){ {
          cuit: '',
          encrypted_password: un_abogado.password
      }}

      it 'no puede ser editado' do
        subject

        asertar_mensaje_de_error_respuesta_y_redireccion("Cuit #{Abogado.mensaje_de_error_para_campo_vacio}")
      end
    end

    context 'el cuit ya fue tomado' do
      let(:una_abogada) { create(:abogada) }
      let(:parametros){ {
          cuit: una_abogada.cuit,
          encrypted_password: un_abogado.password
      }}

      it 'no puede ser editado' do
        subject

        asertar_mensaje_de_error_respuesta_y_redireccion("Cuit #{Abogado.mensaje_de_error_para_campo_tomado}")
      end
    end

    context 'el Domicilio Procesal esta en blanco' do
      let(:parametros){ {
          domicilio_procesal: '',
          encrypted_password: un_abogado.password
      }}

      it 'no puede ser editado' do
        subject

        asertar_mensaje_de_error_respuesta_y_redireccion("Domicilio procesal #{Abogado.mensaje_de_error_para_campo_vacio}")
      end
    end

    context 'el Domicilio Electronico esta en blanco' do
      let(:parametros){ {
          domicilio_electronico: '',
          encrypted_password: un_abogado.password
      }}

      it 'no puede ser editado' do
        subject

        asertar_mensaje_de_error_respuesta_y_redireccion("Domicilio electronico #{Abogado.mensaje_de_error_para_campo_vacio}")
      end
    end

    context 'el Domicilio Electronico ya fue tomado' do
      let(:una_abogada) { create(:abogada) }
      let(:parametros){ {
          domicilio_electronico: una_abogada.domicilio_electronico,
          encrypted_password: un_abogado.password
      }}

      it 'no puede ser editado' do
        subject

        asertar_mensaje_de_error_respuesta_y_redireccion("Domicilio electronico #{Abogado.mensaje_de_error_para_campo_tomado}")
      end
    end
  end
end
