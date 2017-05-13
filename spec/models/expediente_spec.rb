require 'rails_helper'

describe Expediente, type: :model do
  let(:expediente){Expediente.new(actor: "Juan Pepe", demandado: "Maria Perez", materia: "Daños y Perjuicios")}

  it "tiene un titulo" do
    expect(expediente.titulo).to eq "#{expediente.actor} c/ #{expediente.demandado}"
  end

  context 'Antes de numerarse' do

    it "tiene una caratula" do
      expect(expediente.caratula).to eq "#{expediente.titulo} s/ #{expediente.materia}"
    end
  end

  context 'Despues de numerarse' do
    let(:datos){{ numero: 123,
                  juzgado: 'Juzgado Civil y Comercial', #TODO: extraer a un ENUM, para ello averiguar que entidad engloba a un Juzgado o un Tribunal
                  numero_de_juzgado: 7,
                  departamento: 'Departamento Judicial de Quilmes', #TODO: este dato podria ir capturandolo para guardar en una base de datos retroalimentable.
                  ubicacion_del_departamento: 'Alvear 465 piso N°1 de Quilmes'
    }}
    it "tiene otra caratula" do
      anio = DateTime.now.year % 100
      caratula_del_expediente_numerado = "#{expediente.titulo} s/ #{expediente.materia} (#{datos[:numero]}/#{anio}) en tramite ante el #{datos[:juzgado]} N°#{datos[:numero_de_juzgado]} del #{datos[:departamento]} sito en #{datos[:ubicacion_del_departamento]}"

      expediente.numerar!(datos)

      expect(expediente.caratula).to eq caratula_del_expediente_numerado
    end

    it "no puede volver a ser numerado" do
      datos = {
          numero: 123,
          juzgado: 'Juzgado Civil y Comercial',
          numero_de_juzgado: 7,
          departamento: 'Departamento Judicial de Quilmes',
          ubicacion_del_departamento: 'Alvear 465 piso N°1 de Quilmes'
      }
      caratula_del_expediente_numerado = "#{expediente.titulo} s/ #{expediente.materia} (#{datos[:numero]}/#{datos[:anio]}) en tramite ante el #{datos[:juzgado]} N°#{datos[:numero_de_juzgado]} del #{datos[:departamento]} sito en #{datos[:ubicacion_del_departamento]}"

      expediente.numerar!(datos)

      expect{expediente.numerar!(datos)}.to raise_error StandardError
    end
  end
end
