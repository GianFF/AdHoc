class Expediente < ApplicationRecord
  before_save :cargar_caratula

  belongs_to :cliente
  has_many :demandas
  has_many :contestacion_de_demandas
  has_many :mero_tramites
  has_many :notificacions
  has_many :adjuntos

  def self.mensaje_de_error_para_campo_vacio
    'no puede estar en blanco'
  end

  def mensaje_de_error_expediente_numerado
    'Este expediente ya ha sido numerado'
  end

  def mensaje_de_error_datos_faltantes_para_numerar
    'Todos los datos son requeridos a la hora de numerar un expediente'
  end

  validates :actor, :demandado, :materia, :cliente, presence: { message: mensaje_de_error_para_campo_vacio}

  def cargar_caratula
    self.caratula = caratula_sin_numerar
  end

  def titulo
    "#{actor} c/ #{demandado}"
  end

  def escritos
    demandas + contestacion_de_demandas + mero_tramites + notificacions || []
  end

  def caratula_para_encabezado
    !ha_sido_numerado? ?  caratula_sin_numerar : "#{caratula_sin_numerar} #{numero_para_caratula}"
  end

  def numerar(datos)
    validar_que_se_puede_numerar
    validar_datos_para_numerar(datos)

    self.numero = datos[:numero]
    self.anio = DateTime.now.year % 100
    self.juzgado = datos[:juzgado]
    self.numero_de_juzgado = datos[:numero_de_juzgado]
    self.departamento = datos[:departamento]
    self.ubicacion_del_departamento = datos[:ubicacion_del_departamento]

    self.caratula = caratula_numerada
    self.ha_sido_numerado = true
  end


  def pertenece_a?(un_abogado)
    cliente.pertenece_a?(un_abogado)
  end

  def ha_sido_numerado?
    ha_sido_numerado
  end


  def validar_datos_para_numerar(datos)
    raise Errores::AdHocDomainError.new([mensaje_de_error_datos_faltantes_para_numerar]) if datos_invalidos?(datos)
  end

  def validar_que_se_puede_numerar
    raise Errores::AdHocDomainError.new([mensaje_de_error_expediente_numerado ]) if ha_sido_numerado?
  end

  private

  def numero_para_caratula
    "(#{numero}/#{anio})"
  end

  def caratula_sin_numerar
    "#{titulo} s/ #{materia}"
  end

  def caratula_numerada
    "#{caratula_sin_numerar} #{numero_para_caratula} en tramite ante el #{juzgado} N°#{numero_de_juzgado} del #{departamento} sito en #{ubicacion_del_departamento}"
  end

  def datos_invalidos?(datos)
    [datos[:actor], datos[:demandado], datos[:materia], datos[:numero], datos[:juzgado], datos[:numero_de_juzgado],
     datos[:departamento], datos[:ubicacion_del_departamento]].any?{ |campo| campo.blank? }
  end
end
