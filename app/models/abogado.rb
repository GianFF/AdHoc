class Abogado < ApplicationRecord
  has_many :clientes

  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :validatable, :timeoutable, :lockable


  def self.gensaje_de_error_para_genero_invalido
    'solo puede ser Masculino o Femenino'
  end

  def self.mensaje_de_error_para_campo_tomado
    'tomado'
  end

  def self.mensaje_de_error_para_campo_vacio
    'no puede estar en blanco'
  end


  validates_presence_of :nombre, :apellido, :nombre_del_colegio_de_abogados, :domicilio_procesal, :genero,
                        :encrypted_password, :matricula, :cuit, :domicilio_electronico, :email,
                        message: mensaje_de_error_para_campo_vacio

  validates_uniqueness_of :matricula, :cuit, :domicilio_electronico, :email,
                          message: mensaje_de_error_para_campo_tomado

  validate :genero_es_valido, on: :create


  def nombre_completo
    "#{self.apellido} #{self.nombre}"
  end

  def presentacion
    "#{doctor_o_doctora} #{nombre_completo}"
  end

  def tu_email_es?(un_email)
    self.email  == un_email
  end

  def doctor_o_doctora
    Genero::Genero.para(genero).doctor_o_doctora
  end

  def inscripta_inscripto
    Genero::Genero.para(genero).inscripta_inscripto
  end

  def abogada_abogado
    Genero::Genero.para(genero).abogada_abogado
  end

  def la_el
    Genero::Genero.para(genero).la_el
  end

  def letrada_letrado
    Genero::Genero.para(genero).letrada_letrado
  end

  private

  def genero_es_valido
    errors.add(:genero, Abogado.gensaje_de_error_para_genero_invalido) unless Genero::Genero.es_valido(genero)
  end
end
