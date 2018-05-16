require 'rails_helper'

describe Expediente, type: :model do
  include FactoryBot::Syntax::Methods

  let(:expediente){create(:expediente)}
  let(:datos){ attributes_for(:expediente_numerado) }
  let(:datos_invalidos){attributes_for(:expediente_numerado, actor: nil, demandado: '')}

  it 'tiene un titulo' do
    expect(expediente.titulo).to eq "#{expediente.actor} c/ #{expediente.demandado}"
  end

  context 'Antes de numerarse' do

    it 'tiene una caratula' do
      expect(expediente.caratula).to eq "#{expediente.titulo} s/ #{expediente.materia}"
    end
  end

  context 'Despues de numerarse' do

    subject { expediente.numerar(datos) }

    it 'tiene otra caratula' do
      anio = DateTime.now.year % 100
      caratula_del_expediente_numerado = "#{expediente.titulo} s/ #{expediente.materia} (#{datos[:numero]}/#{anio}) en tramite ante el #{datos[:juzgado]} N°#{datos[:numero_de_juzgado]} del #{datos[:departamento]} sito en #{datos[:ubicacion_del_departamento]}"

      subject

      expect(expediente.caratula).to eq caratula_del_expediente_numerado
    end

    it 'no puede volver a ser numerado' do
      subject

      expect{expediente.numerar(datos)}.to raise_error Errores::AdHocDomainError
    end
  end

  describe '#validar_datos_para_numerar' do
    it 'lanza una excepcion si los datos para la numeración son invalidos' do
      expect{expediente.validar_datos_para_numerar(datos_invalidos)}.to raise_error Errores::AdHocDomainError
    end
  end

  describe '#validar_que_se_puede_numerar' do
    it 'lanza una excepcion si ya se numero el expediente' do
      expediente.numerar(datos)
      expect{expediente.validar_que_se_puede_numerar}.to raise_error Errores::AdHocDomainError
    end
  end
end
