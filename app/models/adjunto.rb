class Adjunto < ApplicationRecord
  belongs_to :expediente
  mount_uploader :archivo_adjunto, ArchivoUploader

  def self.mensaje_de_error_para_campo_vacio
    'no puede estar en blanco'
  end

  validates :titulo, :expediente_id, presence: { message: mensaje_de_error_para_campo_vacio}

  def pertenece_a?(un_abogado)
    self.expediente.pertenece_a? un_abogado
  end
end
