class Cliente < ApplicationRecord
  belongs_to :abogado
  has_many :expedientes

  def self.mensaje_de_error_para_nombre_invalido
    'El nombre no puede estar vacio'
  end

  def self.mensaje_de_error_para_apellido_invalido
    'El apellido no puede estar vacio'
  end

  has_one :conyuge
  has_one :direccion
  has_many :hijos

  validates :nombre,   presence: { message: mensaje_de_error_para_nombre_invalido}
  validates :apellido, presence: { message: mensaje_de_error_para_apellido_invalido}
  validates :abogado_id, presence: { message: 'Abogado inexistente'}

  def nombre_completo
    "#{self.apellido} #{self.nombre}"
  end

  def calle
    self.direccion.calle
  end

  def localidad
    self.direccion.localidad
  end

  def provincia
    self.direccion.provincia
  end

  def pais
    self.direccion.pais
  end

  def nombre_conyuge
    self.conyuge.nombre
  end

  def apellido_conyuge
    self.conyuge.apellido
  end

  def agregar_hijo hijo
    self.hijos << hijo
  end

  def pertenece_a?(un_abogado)
    self.abogado.tu_email_es?(un_abogado.email)
  end
end
