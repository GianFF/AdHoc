class Escrito < ApplicationRecord
  belongs_to :expediente

  def self.mensaje_de_error_para_campo_vacio
    'no puede estar en blanco'
  end

  validates :cuerpo, :titulo, :expediente_id, presence: { message: mensaje_de_error_para_campo_vacio}

  def pertenece_a?(un_abogado)
    self.expediente.pertenece_a? un_abogado
  end
end
