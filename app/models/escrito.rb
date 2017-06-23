class Escrito < ApplicationRecord
  belongs_to :expediente

  def self.mensaje_de_error_para_campo_vacio
    'no puede estar en blanco'
  end

  def mensaje_de_error_para_escrito_presentado
    'Este escrito ya fue presentado'
  end

  validates :titulo, :expediente_id, presence: { message: mensaje_de_error_para_campo_vacio}

  def pertenece_a?(un_abogado)
    self.expediente.pertenece_a? un_abogado
  end

  def encabezado(abogado, expediente, cliente)
    subclass_responsibility
  end

  def fue_presentado?
    self.presentado?
  end

  def marcar_como_presentado!
    validar_que_no_haya_sido_presentado
    self.presentado = true
  end

  def validar_que_no_haya_sido_presentado
    raise AdHocUIExcepcion.new([mensaje_de_error_para_escrito_presentado]) if fue_presentado?
  end
end
