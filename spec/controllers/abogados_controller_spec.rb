require_relative '../rails_helper'

def asertar_mensaje_de_error_respuesta_y_redireccion(mensaje_de_error)
  asertar_que_se_incluye_un_mensaje_de_error(mensaje_de_error)
  asertar_que_la_respuesta_tiene_estado(response, :ok)
  asertar_que_se_redirecciono_a(root_path)
end

describe AbogadosController do
  include ::ControllersHelper

  before :each do
    @request.env['devise.mapping'] = Devise.mappings[:abogado]
  end

  let(:fabrica_de_objetos){ FabricaDeObjetos.new }

  let(:parametros_del_abogado) {
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

  let(:un_abogado){ login_abogado(parametros_del_abogado) }

  subject { put :update, params: {id: un_abogado.id, abogado: parametros }, xhr: true }

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
      asertar_que_la_respuesta_tiene_estado(response, :ok)
    end

    context 'Un abogado puede editar su matricula' do
      let(:parametros){ {
          matricula: fabrica_de_objetos.otra_matricula,
          current_password: fabrica_de_objetos.una_contrasenia
      }}

      it {
        subject
        abogado = Abogado.find(un_abogado.id)

        expect(abogado.matricula).to eq fabrica_de_objetos.otra_matricula
        asertar_que_la_respuesta_tiene_estado(response, :ok)
      }
    end

    context 'Un abogado puede editar el nombre del colegio de abogados' do
      let(:parametros){ {
          nombre_del_colegio_de_abogados: fabrica_de_objetos.otro_colegio,
          current_password: fabrica_de_objetos.una_contrasenia
      }}

      it {
        subject
        abogado = Abogado.find(un_abogado.id)

        expect(abogado.nombre_del_colegio_de_abogados).to eq fabrica_de_objetos.otro_colegio
        asertar_que_la_respuesta_tiene_estado(response, :ok)
      }
    end

    context 'Un abogado puede editar su cuit' do
      let(:parametros){ {
          cuit: fabrica_de_objetos.otro_cuit,
          current_password: fabrica_de_objetos.una_contrasenia
      }}

      it {
        subject
        abogado = Abogado.find(un_abogado.id)

        expect(abogado.cuit).to eq fabrica_de_objetos.otro_cuit
        asertar_que_la_respuesta_tiene_estado(response, :ok)
      }
    end

    context 'Un abogado puede editar su domicilio procesal' do
      let(:parametros){ {
          domicilio_procesal: fabrica_de_objetos.otro_domicilio_procesal,
          current_password: fabrica_de_objetos.una_contrasenia
      }}

      it {
        subject
        abogado = Abogado.find(un_abogado.id)

        expect(abogado.domicilio_procesal).to eq fabrica_de_objetos.otro_domicilio_procesal
        asertar_que_la_respuesta_tiene_estado(response, :ok)
      }
    end

    context 'Un abogado puede editar su domicilio electronico' do
      let(:parametros){ {
          domicilio_electronico: fabrica_de_objetos.otro_domicilio_electronico,
          current_password: fabrica_de_objetos.una_contrasenia
      }}

      it {
        subject
        abogado = Abogado.find(un_abogado.id)

        expect(abogado.domicilio_electronico).to eq fabrica_de_objetos.otro_domicilio_electronico
        asertar_que_la_respuesta_tiene_estado(response, :ok)
      }
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
    let(:respuesta) { ActiveSupport::JSON.decode @response.body }

    context 'Cuando no se provee la contraseña' do
      let(:parametros){ {
          nombre: fabrica_de_objetos.otro_nombre_para_un_abogado,
          apellido: fabrica_de_objetos.otro_apellido_para_un_abogado
      }}

      it 'se muestra un mensaje de error y se redirije a la pagina de inicio' do
        subject


        expect(respuesta).to eq ['Debes completar tu contraseña actual para poder editar tu perfil']
        asertar_que_la_respuesta_tiene_estado(response, :found)
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

        expect(respuesta).to eq ['La contraseña es incorrecta']
        asertar_que_la_respuesta_tiene_estado(response, :found)
      end
    end

    context 'Cuando la contraseña es correcta' do

      let(:parametros_de_otro_abogado) {
        fabrica_de_objetos.parametros_para_un_abogado(fabrica_de_objetos.otro_mail_para_un_abogado,
                                                      fabrica_de_objetos.una_contrasenia,
                                                      fabrica_de_objetos.otro_nombre_para_un_abogado,
                                                      fabrica_de_objetos.otro_apellido_para_un_abogado,
                                                      Sexo::FEMENINO,
                                                      fabrica_de_objetos.otra_matricula,
                                                      fabrica_de_objetos.un_colegio,
                                                      fabrica_de_objetos.otro_cuit,
                                                      fabrica_de_objetos.un_domicilio_procesal,
                                                      fabrica_de_objetos.otro_domicilio_electronico)
      }

      let(:otro_abogado){ crear_cuenta_para_abogado(parametros_de_otro_abogado) }

      context 'Y no se probee el Nombre' do
        let(:parametros){ {
            nombre: '',
            current_password: fabrica_de_objetos.una_contrasenia
        }}

        it 'no puede ser editado' do
          subject

          expect(respuesta).to eq ["Nombre #{Abogado.mensaje_de_error_para_campo_vacio}"]
        end
      end

      context 'Y no se probee el Apellido' do
        let(:parametros){ {
            apellido: '',
            current_password: fabrica_de_objetos.una_contrasenia
        }}

        it 'no puede ser editado' do
          subject

          expect(respuesta).to eq ["Apellido #{Abogado.mensaje_de_error_para_campo_vacio}"]
        end
      end

      context 'Y no se probee el Email' do
        let(:parametros){ {
            email: '',
            current_password: fabrica_de_objetos.una_contrasenia
        }}

        it 'no puede ser editado' do
          subject

          expect(respuesta).to eq ["Email #{Abogado.mensaje_de_error_para_campo_vacio}"]
        end
      end

      context 'Y el Email ya fue tomado' do
        let(:parametros){ {
            email: otro_abogado.email,
            current_password: fabrica_de_objetos.una_contrasenia
        }}

        it 'no puede ser editado' do
          subject

          expect(respuesta).to eq ["Email #{Abogado.mensaje_de_error_para_campo_tomado}"]
        end
      end

      context 'Y no se probee el Colegio de Abogados' do
        let(:parametros){ {
            nombre_del_colegio_de_abogados: '',
            current_password: fabrica_de_objetos.una_contrasenia
        }}

        it 'no puede ser editado' do
          subject

          expect(respuesta).to eq ["Nombre del colegio de abogados #{Abogado.mensaje_de_error_para_campo_vacio}"]
        end
      end

      context 'Y no se probee la Matricula' do
        let(:parametros){ {
            matricula: '',
            current_password: fabrica_de_objetos.una_contrasenia
        }}

        it 'no puede ser editado' do
          subject

          expect(respuesta).to eq ["Matricula #{Abogado.mensaje_de_error_para_campo_vacio}"]
        end
      end

      context 'Y la Matricula ya fue tomada' do
        let(:parametros){ {
            matricula: otro_abogado.matricula,
            current_password: fabrica_de_objetos.una_contrasenia
        }}

        it 'no puede ser editado' do
          subject

          expect(respuesta).to eq ["Matricula #{Abogado.mensaje_de_error_para_campo_tomado}"]
        end
      end

      context 'Y no se probee el cuit' do
        let(:parametros){ {
            cuit: '',
            current_password: fabrica_de_objetos.una_contrasenia
        }}

        it 'no puede ser editado' do
          subject

          expect(respuesta).to eq ["Cuit #{Abogado.mensaje_de_error_para_campo_vacio}"]
        end
      end

      context 'Y el Cuit ya fue tomado' do
        let(:parametros){ {
            cuit: otro_abogado.cuit,
            current_password: fabrica_de_objetos.una_contrasenia
        }}

        it 'no puede ser editado' do
          subject

          expect(respuesta).to eq ["Cuit #{Abogado.mensaje_de_error_para_campo_tomado}"]
        end
      end

      context 'Y no se probee el Domicilio Procesal' do
        let(:parametros){ {
            domicilio_procesal: '',
            current_password: fabrica_de_objetos.una_contrasenia
        }}

        it 'no puede ser editado' do
          subject

          expect(respuesta).to eq ["Domicilio procesal #{Abogado.mensaje_de_error_para_campo_vacio}"]
        end
      end

      context 'Y no se probee el Domicilio Electronico' do
        let(:parametros){ {
            domicilio_electronico: '',
            current_password: fabrica_de_objetos.una_contrasenia
        }}

        it 'no puede ser editado' do
          subject

          expect(respuesta).to eq ["Domicilio electronico #{Abogado.mensaje_de_error_para_campo_vacio}"]
        end
      end

      context 'Y el Domicilio Electronico ya fue tomado' do
        let(:parametros){ {
            domicilio_electronico: otro_abogado.domicilio_electronico,
            current_password: fabrica_de_objetos.una_contrasenia
        }}

        it 'no puede ser editado' do
          subject

          expect(respuesta).to eq ["Domicilio electronico #{Abogado.mensaje_de_error_para_campo_tomado}"]
        end
      end
    end
  end
end
