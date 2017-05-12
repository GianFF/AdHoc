class Expediente < ApplicationRecord
  belongs_to :cliente

  validates :actor, :demandado, :materia, :cliente_id, presence: true

  def titulo
    "#{self.actor} c/ #{self.demandado}"
  end

  def caratula
    return "#{self.titulo} s/ #{self.materia}" unless self.ha_sido_numerado
    "#{self.titulo} s/ #{self.materia} (#{self.numero}/#{self.anio}) en tramite ante el #{self.juzgado} N°#{self.numero_de_juzgado} del #{self.departamento} sito en #{self.ubicacion_del_departamento}"
  end

  def numerar!(datos) #TODO: hay un mejor nombre para datos? serian los datos necesarios para numerar el expediente...
    raise StandardError, mensaje_de_error_para_expediente_numerado if self.ha_sido_numerado?

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

  def mensaje_de_error_para_expediente_numerado
    'Este expediente ya ha sido numerado'
  end
end
