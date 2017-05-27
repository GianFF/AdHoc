class Encabezado
  def initialize(un_abogado, un_expediente, un_cliente)
    @abogado = un_abogado
    @expediente = un_expediente
    @cliente = un_cliente
  end

  def nombre_del_abogado
    @abogado.nombre_completo
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
    @expediente.caratula_para_el_encabezado_automatico
  end

  def organo_que_actua_en_ese_expediente
    @expediente.juzgado #TODO: cambiar por organo cuando llegue el momento del refactor!
  end

  def nombre_del_cliente
    @cliente.nombre_completo
  end
end