class Conyuge < ApplicationRecord
  belongs_to :cliente

  def self.mensaje_de_error_para_nombre_invalido

  end

  def self.mensaje_de_error_para_apellido_invalido

  end

  def self.mensaje_de_error_para_conyuge_inexistente

  end


  validates :nombre, presence: { message: mensaje_de_error_para_nombre_invalido }
  validates :apellido, presence: { message: mensaje_de_error_para_apellido_invalido }
  validates :cliente, presence: { message: mensaje_de_error_para_conyuge_inexistente }
end
