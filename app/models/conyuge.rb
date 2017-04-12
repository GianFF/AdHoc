class Conyuge < ApplicationRecord

  def self.mensaje_de_error_para_nombre_invalido

  end

  def self.mensaje_de_error_para_apellido_invalido

  end

  def self.mensaje_de_error_para_conyuge_inexistente

  end

  belongs_to :cliente #TODO: como hacer un overload del mensaje de error de un belongs to

  validates :nombre, presence: { message: mensaje_de_error_para_nombre_invalido }
  validates :apellido, presence: { message: mensaje_de_error_para_apellido_invalido }
  validates :cliente, presence: { message: mensaje_de_error_para_conyuge_inexistente }
end
