class Encabezado
  attr_reader :abogado, :expediente, :cliente

  def self.value(un_abogado, un_expediente, un_cliente)
    new(un_abogado, un_expediente, un_cliente).valor
  end

  def initialize(un_abogado, un_expediente, un_cliente)
    @abogado = un_abogado
    @expediente = un_expediente
    @cliente = un_cliente
  end

  def presentacion_del_abogado
    @abogado.presentacion
  end

  def matricula_del_abogado
    @abogado.matricula
  end

  def nombre_del_colegio_de_abogados
    @abogado.nombre_del_colegio_de_abogados
  end

  def cuit_del_abogado
    @abogado.cuit
  end

  def domicilio_procesal_del_abogado
    @abogado.domicilio_procesal
  end

  def domicilio_electronico_del_abogado
    @abogado.domicilio_electronico
  end

  def caratula_del_expediente
    @expediente.caratula_para_encabezado
  end

  def organo_que_actua_en_ese_expediente
    return @expediente.juzgado if @expediente.ha_sido_numerado?
    "<strong><span style='color: #ff0000;'>[JUZGADO O TRIBUNAL NO HA SIDO DEFINIDO]</span></strong>" #TODO: cambiar por organo cuando llegue el momento del refactor!
  end

  def nombre_del_cliente
    @cliente.nombre_completo
  end

  def datos_del_expediente
    ", en el marco del expediente caratulado #{caratula_del_expediente} en tramite ante #{organo_que_actua_en_ese_expediente}"
  end

  def valor
    "#{nombre_del_cliente} por mi propio derecho, en compañia de mi #{letrada_letrado} patrocinante, #{la_el} #{presentacion_del_abogado}, #{abogada_abogado} #{inscripta_inscripto} al #{matricula_del_abogado} del #{nombre_del_colegio_de_abogados} cuit e IIBB #{cuit_del_abogado} con domicilio procesal en calle #{domicilio_procesal_del_abogado} y electronico en #{domicilio_electronico_del_abogado} ante S.S. me presento y respetuosamente expongo:"
  end

  private

  def inscripta_inscripto
    abogado.inscripta_inscripto
  end

  def abogada_abogado
    abogado.abogada_abogado
  end

  def la_el
    abogado.la_el
  end

  def letrada_letrado
    abogado.letrada_letrado
  end
end
