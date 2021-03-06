class Abogado < ApplicationRecord
  has_many :clientes

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :timeoutable, :lockable


  def self.mensaje_de_error_para_sexo_en_invalido
    'solo puede ser Masculino o Femenino'
  end

  def self.mensaje_de_error_para_campo_tomado
    'tomado'
  end

  def self.mensaje_de_error_para_campo_vacio
    'no puede estar en blanco'
  end

  validate :sexo_es_valido, on: :create

  validates :nombre, :apellido, :nombre_del_colegio_de_abogados, :domicilio_procesal, :sexo, :encrypted_password,
            presence: { message: mensaje_de_error_para_campo_vacio}

  validates :matricula, :cuit, :domicilio_electronico, :email,
            presence: { message: mensaje_de_error_para_campo_vacio},
            uniqueness: { message: mensaje_de_error_para_campo_tomado}

  def nombre_completo
    "#{self.apellido} #{self.nombre}"
  end

  def presentacion
    "#{doctor_o_doctora} #{nombre_completo}"
  end

  def tu_email_es?(un_email)
    self.email  == un_email
  end

  #TODO: reificar enums femenino y masculino.
  def doctor_o_doctora
    Sexo.doctor_o_doctora(sexo)
  end

  def inscripta_inscripto
    Sexo.inscripta_inscripto(sexo)
  end

  def abogada_abogado
    Sexo.abogada_abogado(sexo)
  end

  def la_el
    Sexo.la_el(sexo)
  end

  def letrada_letrado
    Sexo.letrada_letrado(sexo)
  end
  private

  def sexo_es_valido
    errors.add(:sexo, Abogado.mensaje_de_error_para_sexo_en_invalido) unless el_sexo_es(Sexo::FEMENINO) || el_sexo_es(Sexo::MASCULINO)
  end

  def el_sexo_es(un_sexo)
    sexo == un_sexo
  end
end
