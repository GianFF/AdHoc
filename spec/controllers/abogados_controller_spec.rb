require_relative '../rails_helper'
require_relative '../fabrica_de_objetos'

def login_abogado(sexo, apellido, nombre, contrasenia, mail)
  abogado = crear_cuenta_para_abogado(mail, contrasenia, nombre, apellido, sexo)
  sign_in abogado
  abogado
end

def crear_cuenta_para_abogado(mail, contrasenia, nombre, apellido, sexo)
  abogado = fabrica_de_objetos.un_abogado(mail, contrasenia, nombre, apellido, sexo)
  #abogado.confirm
  abogado
end

describe AbogadosController do

  before :each do
    @request.env['devise.mapping'] = Devise.mappings[:abogado]
  end

  let(:fabrica_de_objetos){ FrabricaDeObjetos.new }
  let(:un_abogado){ login_abogado(Sexo::MASCULINO, fabrica_de_objetos.un_apellido_para_un_abogado,
                                  fabrica_de_objetos.un_nombre_para_un_abogado, fabrica_de_objetos.una_contrasenia,
                                  fabrica_de_objetos.un_mail_para_un_abogado) }

  subject { put :update, id: un_abogado.id, abogado: parametros }

  context 'En la correcta edicion de un abogado' do
    let(:parametros){ {
        nombre: fabrica_de_objetos.otro_nombre_para_un_abogado,
        apellido: fabrica_de_objetos.otro_apellido_para_un_abogado,
        current_password: fabrica_de_objetos.una_contrasenia
    }}

    it 'un abogado puede editar su nombre y apellido' do
      subject
      abogado = Abogado.find(un_abogado.id)

      expect(abogado.nombre).to eq fabrica_de_objetos.otro_nombre_para_un_abogado
      expect(abogado.apellido).to eq fabrica_de_objetos.otro_apellido_para_un_abogado
      expect(response).to have_http_status(:found)
    end

    context 'Se puede modificar el email' do
      let(:parametros){ {
          email: fabrica_de_objetos.otro_mail_para_un_abogado,
          current_password: fabrica_de_objetos.una_contrasenia
      }}

      it 'un abogado puede cambiar su email' do
        subject
        abogado = Abogado.find(un_abogado.id)

        expect(abogado.email).to eq fabrica_de_objetos.otro_mail_para_un_abogado
      end
    end
  end

  context 'En la incorrecta edicion de un abogado' do

    context 'Cuando no se provee la contraseña' do
      let(:parametros){ {
          nombre: fabrica_de_objetos.otro_nombre_para_un_abogado,
          apellido: fabrica_de_objetos.otro_apellido_para_un_abogado
      }}

      it 'se muestra un mensaje de error y se redirije a la pagina de inicio' do
        subject

        expect(flash[:error]).to eq @controller.ad_hoc.mensaje_de_error_para_contrasenia_no_proveida
        expect(response).to have_http_status(:found)
        assert_redirected_to root_path
      end
    end

    context 'Cuando la contraseña es incorrecta' do
      let(:parametros){ {
          nombre: fabrica_de_objetos.otro_nombre_para_un_abogado,
          apellido: fabrica_de_objetos.otro_apellido_para_un_abogado,
          current_password: fabrica_de_objetos.una_contrasenia_incorrecta
      }}

      it 'se muestra un mensaje de error y se redirije a la pagina de inicio' do
        subject

        expect(flash[:error]).to eq @controller.ad_hoc.mensaje_de_error_para_contrasenia_invalida
        expect(response).to have_http_status(:found)
        assert_redirected_to root_path
      end
    end
  end
end
