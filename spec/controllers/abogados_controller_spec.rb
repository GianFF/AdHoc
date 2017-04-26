require_relative '../rails_helper'


def login_abogado
  abogado = Abogado.create!(email: 'ejemplo@mail.com', password: 'password',
                            nombre: 'Foo', apellido: 'Bar', sexo: 'Masculino')
  abogado.confirm
  sign_in abogado
  abogado
end

describe AbogadosController do

  let(:un_abogado){ login_abogado }

  context 'En la edicion de un abogado' do
    let(:parametros){ {
#        abogado: {
            nombre: 'Bar',
            apellido: 'Zaz',
            email: 'otro_ejemplo@mail.com',
            password: 'password'
#        }
    }}

    subject { post :put, abogado: parametros }

    before :each do
      @request.env['devise.mapping'] = Devise.mappings[:abogado]
    end

    it 'un abogado puede editar sus datos' do
      abogado = Abogado.find(un_abogado.id)

      subject

      expect(abogado.nombre).to eq 'Bar'
      expect(abogado.apellido).to eq 'Zaz'
      expect(abogado.email).to eq 'otro_ejemplo@mail.com'
    end

    it 'cuando se edita el nombre, apellido o email de un abogado es necesario probeer la contraseña' do

    end
  end

  it 'un abogado puede cancelar su cuenta' do

  end

end