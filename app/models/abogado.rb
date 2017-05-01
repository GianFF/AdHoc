class Abogado < ApplicationRecord
  has_many :clientes

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :validatable, :timeoutable, :lockable


  def self.mensaje_de_error_para_nombre_en_blanco
    'no puede estar en blanco'
  end

  def self.mensaje_de_error_para_apellido_en_blanco
    'no puede estar en blanco'
  end

  def self.mensaje_de_error_para_sexo_en_blanco
    'no puede estar en blanco'
  end

  def self.mensaje_de_error_para_sexo_en_invalido
    'solo puede ser Masculino o Femenino'
  end

  def self.mensaje_de_error_para_email_tomado
    'tomado'
  end

  def self.mensaje_de_error_para_email_en_blanco
    'no puede estar en blanco'
  end

  validate :sexo_es_valido, on: :create
  validates :nombre,   presence: { message: mensaje_de_error_para_nombre_en_blanco}
  validates :apellido, presence: { message: mensaje_de_error_para_apellido_en_blanco}
  validates :sexo,     presence: { message: mensaje_de_error_para_sexo_en_blanco}
  validates :email,    presence: { message: mensaje_de_error_para_email_en_blanco},
            uniqueness: { message: mensaje_de_error_para_email_tomado}


  def tu_email_es?(un_email)
    self.email  == un_email
  end

  private

  def sexo_es_valido
    errors.add(:sexo, Abogado.mensaje_de_error_para_sexo_en_invalido) unless sexo == 'Femenino' || sexo == 'Masculino'
  end

end
