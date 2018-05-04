require 'rails_helper'

describe Cliente, type: :model do
  include FactoryBot::Syntax::Methods

  let(:cliente){ create(:cliente) }

  context 'un cliente no puede crearse sin' do

    subject{ create(:cliente, nombre: '') }

    it 'nombre' do
      expect{subject}.to raise_error ActiveRecord::RecordInvalid
      expect{create(:cliente, nombre: nil)}.to raise_error ActiveRecord::RecordInvalid
    end

    it 'apellido' do
      expect{create(:cliente, apellido: '')}.to raise_error ActiveRecord::RecordInvalid
      expect{create(:cliente, apellido: nil)}.to raise_error ActiveRecord::RecordInvalid
    end

    it 'el abogado al que pertenece' do
      expect{create(:cliente, abogado: nil)}.to raise_error ActiveRecord::RecordInvalid
    end
  end

  it 'un cliente puede tener conyuge' do
    cliente.conyuge = create(:conyuge, cliente: cliente)

    expect(cliente.nombre_conyuge).to eq "Florencia"
    expect(cliente.apellido_conyuge).to eq "Giuliani"
  end

  it 'Un cliente puede tener hijos' do
    un_hijo = create(:hijo, cliente: cliente)
    una_hija = create(:hija, cliente: cliente)

    cliente.agregar_hijo un_hijo
    cliente.agregar_hijo una_hija

    expect(cliente.hijos).to contain_exactly(un_hijo, una_hija)
  end
end