require_relative '../rails_helper'

describe 'Hijo', type: :model do
  let(:hijo){ Hijo.new(nombre: "Zaz", apellido: "Bar") }

  it 'tiene un nombre y un apellido' do
    expect(hijo.nombre).to eq "Zaz"
    expect(hijo.apellido).to eq "Bar"
  end

  it 'tiene una edad' do
    hijo.edad = 14

    expect(hijo.edad).to eq 14
  end

  it 'debe ser el hijo de algun cliente' do
    expect(hijo).not_to be_valid
    expect(hijo.errors[:cliente]).equal? [Hijo.mensaje_de_error_para_padre_inexistente]
  end

  it 'el nombre y el apellido son obligatorios' do
    Hijo.create()

    expect(hijo).not_to be_valid
    expect(hijo.errors[:nombre]).equal? [Hijo.mensaje_de_error_para_nombre_invalido]
    expect(hijo.errors[:apellido]).equal? [Hijo.mensaje_de_error_para_apellido_invalido]
    expect(hijo.errors[:cliente]).equal? [Hijo.mensaje_de_error_para_padre_inexistente]
  end

end
