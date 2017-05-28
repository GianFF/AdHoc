require 'rails_helper'

def parametros_para_numerar_expediente
  {actor: "#{cliente.nombre_completo}",
   demandado: fabrica_de_objetos.un_demandado,
   materia: fabrica_de_objetos.una_materia,
   numero: fabrica_de_objetos.un_numero_de_expediente,
   juzgado: fabrica_de_objetos.un_juzgado,
   numero_de_juzgado: fabrica_de_objetos.un_numero_de_juzgado,
   departamento: fabrica_de_objetos.un_departamento,
   ubicacion_del_departamento: fabrica_de_objetos.una_ubicacion_de_un_departamento}
end

def numerar_expediente
  expediente.numerar!(parametros_para_numerar_expediente)
end

describe Encabezado do
  let(:fabrica_de_objetos){ FabricaDeObjetos.new }

  let(:parametros){ fabrica_de_objetos.parametros_para_un_abogado(fabrica_de_objetos.un_mail_para_un_abogado,
                                                                  fabrica_de_objetos.una_contrasenia,
                                                                  fabrica_de_objetos.un_nombre_para_un_abogado,
                                                                  fabrica_de_objetos.un_apellido_para_un_abogado,
                                                                  Sexo::FEMENINO,
                                                                  fabrica_de_objetos.una_matricula,
                                                                  fabrica_de_objetos.un_colegio,
                                                                  fabrica_de_objetos.un_cuit,
                                                                  fabrica_de_objetos.un_domicilio_procesal,
                                                                  fabrica_de_objetos.un_domicilio_electronico)
  }
  let(:abogado){ fabrica_de_objetos.crear_un_abogado(parametros) }

  let(:cliente){ fabrica_de_objetos.crear_cliente(abogado.id) }

  let(:expediente){ fabrica_de_objetos.crear_expediente(cliente.id) }

  let(:encabezado){ fabrica_de_objetos.crear_encabezado(abogado, expediente, cliente) } # TODO: mover al factory

  context 'Se compone de' do

    it 'un nombre del abogado' do
      expect(encabezado.presentacion_del_abogado).to eq "Dra. #{abogado.nombre_completo}"
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

    context 'organo que actua en ese expediente ' do

      it 'cuando el expediente no fue numerado' do
        expect(encabezado.organo_que_actua_en_ese_expediente).to eq '[JUZGADO O TRIBUNAL NO HA SIDO DEFINIDO]'
      end

      it 'cuando el expediente fue numerado' do
        numerar_expediente

        expect(encabezado.organo_que_actua_en_ese_expediente).to eq expediente.juzgado
      end
    end

    it 'nombre del cliente' do
      expect(encabezado.nombre_del_cliente).to eq cliente.nombre_completo
    end
  end

  context 'Un encabezado puede ser para patrocinante' do

    it 'cuando el expediente no fue numerado tiene un cuerpo' do
      expect(encabezado.cuerpo).to eq "#{cliente.nombre_completo} por mi propio derecho, en compañia de mi letrada patrocinante, la #{abogado.presentacion}, abogada inscripta al #{abogado.matricula} del #{abogado.nombre_del_colegio_de_abogados} cuit e IIBB #{abogado.cuit} con domicilio procesal en calle #{abogado.domicilio_procesal} y electronico en #{abogado.domicilio_electronico}, en el marco del expediente caratulado #{expediente.caratula_para_el_encabezado_automatico} en tramite ante <strong><span style='color: #ff0000;'>[JUZGADO O TRIBUNAL NO HA SIDO DEFINIDO]</span></strong> ante S.S. me presento y respetuosamente expongo:"
    end

    it 'cuando el expediente fue numerado tiene otro cuerpo' do
      numerar_expediente

      expect(encabezado.cuerpo).to eq "#{cliente.nombre_completo} por mi propio derecho, en compañia de mi letrada patrocinante, la #{abogado.presentacion}, abogada inscripta al #{abogado.matricula} del #{abogado.nombre_del_colegio_de_abogados} cuit e IIBB #{abogado.cuit} con domicilio procesal en calle #{abogado.domicilio_procesal} y electronico en #{abogado.domicilio_electronico}, en el marco del expediente caratulado #{expediente.caratula_para_el_encabezado_automatico} en tramite ante #{expediente.juzgado} ante S.S. me presento y respetuosamente expongo:"
    end
  end
end
