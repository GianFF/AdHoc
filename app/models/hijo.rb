class Hijo < ApplicationRecord

  def self.mensaje_de_error_para_nombre_invalido
    'El nombre no puede estar vacio'
  end

  def self.mensaje_de_error_para_apellido_invalido
    'El apellido no puede estar vacio'
  end

  def self.mensaje_de_error_para_padre_inexistente
    'Debe existir un cliente para este hijo'
  end

  belongs_to :cliente

  validates :nombre,   presence: { message: mensaje_de_error_para_nombre_invalido}
  validates :apellido, presence: { message: mensaje_de_error_para_apellido_invalido}
  validates :cliente,  presence: { message: mensaje_de_error_para_padre_inexistente}

end
