class Expediente < ApplicationRecord
  belongs_to :cliente
  has_many :demandas

  def self.mensaje_de_error_para_campo_vacio
    'no puede estar en blanco'
  end

  validates :actor, :demandado, :materia, :cliente_id, presence: { message: mensaje_de_error_para_campo_vacio}

  def titulo
    "#{self.actor} c/ #{self.demandado}"
  end

  def caratula
    return caratula_sin_numerar unless self.ha_sido_numerado
    caratula_numerada
  end

  def caratula_para_el_encabezado_automatico
    return caratula_sin_numerar unless self.ha_sido_numerado
    "#{caratula_sin_numerar} #{numero_para_caratula}"
  end

  def numerar!(datos) #TODO: hay un mejor nombre para datos? serian los datos necesarios para numerar el expediente...
    self.validar_que_el_expediente_no_haya_sido_numerado!
    self.validar_que_no_falte_ningun_dato_para_la_numeracion!(datos)

    self.ha_sido_numerado = true

    self.numero = datos[:numero]
    self.anio = DateTime.now.year % 100
    self.juzgado = datos[:juzgado]
    self.numero_de_juzgado = datos[:numero_de_juzgado]
    self.departamento = datos[:departamento]
    self.ubicacion_del_departamento = datos[:ubicacion_del_departamento]
  end

  def pertenece_a?(un_abogado)
    self.cliente.pertenece_a?(un_abogado)
  end

  def ha_sido_numerado?
    self.ha_sido_numerado
  end

  def los_datos_para_numerar_son_invalidos?(datos)
    datos[:actor].blank? || datos[:demandado].blank? || datos[:materia].blank? || datos[:numero].blank? ||
        datos[:juzgado].blank? || datos[:numero_de_juzgado].blank? || datos[:departamento].blank? || datos[:ubicacion_del_departamento].blank?
  end

  def validar_que_no_falte_ningun_dato_para_la_numeracion!(datos)
    raise ArgumentError, self.mensaje_de_error_para_datos_faltantes_en_la_numeracion if self.los_datos_para_numerar_son_invalidos?(datos)
  end

  def validar_que_el_expediente_no_haya_sido_numerado!
    raise StandardError, self.mensaje_de_error_para_expediente_numerado if self.ha_sido_numerado?
  end

  def mensaje_de_error_para_expediente_numerado
    'Este expediente ya ha sido numerado'
  end

  def mensaje_de_error_para_datos_faltantes_en_la_numeracion
    'Todos los datos son requeridos a la hora de numerar un expediente'
  end

  private

  def numero_para_caratula
    "(#{self.numero}/#{self.anio})"
  end

  def caratula_sin_numerar
    "#{self.titulo} s/ #{self.materia}"
  end

  def caratula_numerada
    "#{caratula_sin_numerar} #{numero_para_caratula} en tramite ante el #{self.juzgado} N°#{self.numero_de_juzgado} del #{self.departamento} sito en #{self.ubicacion_del_departamento}"
  end
end
