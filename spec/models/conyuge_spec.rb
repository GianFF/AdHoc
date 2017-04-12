require_relative '../rails_helper'

describe 'Conyuge', type: :model do

  it 'tiene un nombre y apellido' do
    conyuge = Conyuge.new(nombre: "Bar", apellido: "Foo")

    expect(conyuge.nombre).to eq "Bar"
    expect(conyuge.apellido).to eq "Foo"
  end

  it 'el nombre y el apellido son obligatorios' do
    conyuge = Conyuge.create()

    expect(conyuge).not_to be_valid
    expect(conyuge).not_to be_valid
    expect(conyuge).not_to be_valid
  end
end