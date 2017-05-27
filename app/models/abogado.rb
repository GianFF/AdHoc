class Abogado < ApplicationRecord
  has_many :clientes

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :validatable, :timeoutable, :lockable


  def self.mensaje_de_error_para_sexo_en_invalido
    'solo puede ser Masculino o Femenino'
  end

  def self.mensaje_de_error_para_email_tomado
    'tomado'
  end

  def self.mensaje_de_error_para_campo_vacio
    'no puede estar en blanco'
  end

  validate :sexo_es_valido, on: :create
  validates :nombre,   presence: { message: mensaje_de_error_para_campo_vacio}
  validates :apellido, presence: { message: mensaje_de_error_para_campo_vacio}
  validates :matricula, presence: { message: mensaje_de_error_para_campo_vacio}
  validates :nombre_del_colegio_de_abogados, presence: { message: mensaje_de_error_para_campo_vacio}
  validates :cuit, presence: { message: mensaje_de_error_para_campo_vacio}
  validates :domicilio_procesal, presence: { message: mensaje_de_error_para_campo_vacio}
  validates :domicilio_electronico, presence: { message: mensaje_de_error_para_campo_vacio}
  validates :sexo, presence: { message: mensaje_de_error_para_campo_vacio}
  validates :email, presence: { message: mensaje_de_error_para_campo_vacio},
            uniqueness: { message: mensaje_de_error_para_email_tomado}

  def nombre_completo
    "#{self.apellido} #{self.nombre}"
  end

  def tu_email_es?(un_email)
    self.email  == un_email
  end

  private

  def sexo_es_valido
    errors.add(:sexo, Abogado.mensaje_de_error_para_sexo_en_invalido) unless el_sexo_es(Sexo::FEMENINO) || el_sexo_es(Sexo::MASCULINO)
  end

  def el_sexo_es(un_sexo)
    sexo == un_sexo
  end
end
