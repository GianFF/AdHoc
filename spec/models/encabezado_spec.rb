require 'rails_helper'

describe Encabezado do
  let(:fabrica_de_objetos){ FabricaDeObjetos.new }

  let(:abogado){ fabrica_de_objetos.crear_un_abogado(fabrica_de_objetos.un_mail_para_un_abogado,
                                                    fabrica_de_objetos.una_contrasenia,
                                                    fabrica_de_objetos.un_nombre_para_un_abogado,
                                                    fabrica_de_objetos.un_apellido_para_un_abogado,
                                                    Sexo::MASCULINO) }

  let(:cliente){ fabrica_de_objetos.crear_cliente(abogado.id) }

  let(:expediente){ fabrica_de_objetos.crear_expediente(cliente.id) }

  let(:encabezado){ Encabezado.new(abogado, expediente, cliente) } # TODO: mover al factory

  context 'Se compone de' do

    it 'un nombre del abogado' do
      expect(encabezado.nombre_del_abogado).to eq abogado.nombre_completo
    end

    it 'un numero de matricula' do
      expect(encabezado.matricula_del_abogado).to eq abogado.matricula
    end

    it 'un nombre del colegio de abogados al que pertenece el abogado' do
      expect(encabezado.nombre_del_colegio_de_abogados).to eq abogado.nombre_del_colegio_de_abogados
    end

    it 'un cuit del abogado' do
      expect(encabezado.cuit_del_abogado).to eq abogado.cuit
    end


    it 'domicilio procesal del abogado' do
      expect(encabezado.domicilio_procesal_del_abogado).to eq abogado.domicilio_procesal
    end

    it 'domicilio electronico del abogado' do
      expect(encabezado.domicilio_electronico_del_abogado).to eq abogado.domicilio_electronico
    end

    it 'caratula del expediente' do
      expect(encabezado.caratula_del_expediente).to eq expediente.caratula_para_el_encabezado_automatico
    end


    it 'juzgado o tribunal que actua en ese expediente' do
      expect(encabezado.organo_que_actua_en_ese_expediente).to eq expediente.juzgado
    end


    it 'nombre del cliente' do
      expect(encabezado.nombre_del_cliente).to eq cliente.nombre_completo
    end
  end
end
